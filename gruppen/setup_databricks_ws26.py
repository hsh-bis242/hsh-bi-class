#!/usr/bin/env python3
"""Databricks Workspace-Setup BIS242 WS26 – lokal ausführbares Pendant zu
setup_databricks_ws26.ipynb.

Legt User und Gruppen über die SCIM API an/synchronisiert sie, setzt die
Entitlements (Workspace-/SQL-Zugriff, Cluster-Erstellung) und erstellt pro
Gruppe einen eigenen Unity-Catalog-Catalog über die SQL Statement Execution
API. Liest die Gruppenzuordnung direkt aus ws26_github.csv (single source
of truth).

Idempotent: mehrfaches Ausführen aktualisiert User-Liste und Entitlements,
synchronisiert Gruppenmitgliedschaften (add + remove), legt fehlende
Kataloge nach und setzt die Grants erneut (schadet nicht, falls bereits
vorhanden).

Benötigte Umgebungsvariablen:
  DATABRICKS_HOST   z.B. https://dbc-9bacfc50-2c71.cloud.databricks.com
  DATABRICKS_TOKEN  Personal Access Token eines Workspace-Admins

Nutzung:
  DATABRICKS_HOST=... DATABRICKS_TOKEN=... python gruppen/setup_databricks_ws26.py
"""

from __future__ import annotations

import csv
import os
import sys
import time
from pathlib import Path

import requests

CSV_PATH = Path(__file__).parent / "ws26_github.csv"

DOZIERENDE = [
    "peter.grass@hs-hannover.de",
    "stephan.rensmann@hs-hannover.de",
    "maximilian.vollmer@hs-hannover.de",
]

# Entitlements, die alle angelegten User erhalten sollen (Workspace- und SQL-Zugriff
# sowie Cluster-Erstellung fuer eigene Compute-Ressourcen). "Admin access" (Mitgliedschaft
# in der admins-Gruppe) wird bewusst NICHT vergeben, da das vollen Workspace-Zugriff auf
# fremde User/Gruppen/Kataloge beduetet. "Consumer access" ist kein eigenstaendiges SCIM-
# Entitlement (wird von der API ignoriert) und daher hier nicht erforderlich.
ENTITLEMENTS = ["workspace-access", "databricks-sql-access", "allow-cluster-create"]


def load_config() -> tuple[str, str]:
    host = os.environ.get("DATABRICKS_HOST", "").rstrip("/")
    token = os.environ.get("DATABRICKS_TOKEN", "")
    if not host or not token:
        sys.exit("Fehler: DATABRICKS_HOST und DATABRICKS_TOKEN müssen gesetzt sein.")
    return host, token


def load_gruppen() -> tuple[dict[str, list[str]], list[str]]:
    gruppen: dict[str, list[str]] = {f"{i:02d}": [] for i in range(1, 11)}
    ohne_gruppe: list[str] = []
    with CSV_PATH.open(newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            email = row["email"].strip()
            gruppe = row["gruppe"].strip()
            if not email:
                continue
            if gruppe:
                gruppen.setdefault(gruppe, []).append(email)
            else:
                ohne_gruppe.append(email)
    return gruppen, ohne_gruppe


def create_user(session: requests.Session, scim_url: str, email: str) -> dict:
    local_part = email.split("@")[0]
    name_parts = local_part.replace("-", " ").split(".")
    first_name = (
        " ".join(p.capitalize() for p in name_parts[:-1])
        if len(name_parts) > 1
        else name_parts[0].capitalize()
    )
    last_name = name_parts[-1].capitalize() if name_parts else ""

    payload = {
        "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
        "userName": email,
        "name": {"givenName": first_name, "familyName": last_name},
        "emails": [{"type": "work", "value": email, "primary": True}],
        "active": True,
    }
    resp = session.post(scim_url, json=payload)
    try:
        detail = resp.json()
    except ValueError:
        detail = {}
    return {"email": email, "status": resp.status_code, "detail": detail}


def sync_users(session: requests.Session, scim_url: str, emails: list[str]) -> dict[str, str]:
    print("\n=== 1. User anlegen ===")
    created = existed = failed = 0
    for email in emails:
        result = create_user(session, scim_url, email)
        status = result["status"]
        if status == 201:
            print(f"  OK   {email} - angelegt")
            created += 1
        elif status == 409:
            print(f"  SKIP {email} - existiert bereits")
            existed += 1
        else:
            print(f"  FAIL {email} - HTTP {status}: {result['detail']}")
            failed += 1
    print(f"\nErgebnis: {created} neu, {existed} existierten bereits, {failed} fehlgeschlagen")

    resp = session.get(scim_url, params={"count": 200})
    resp.raise_for_status()
    return {u["userName"]: u["id"] for u in resp.json().get("Resources", [])}


def set_entitlements(
    session: requests.Session, scim_url: str, emails: list[str], user_ids: dict[str, str]
) -> None:
    """Setzt die Entitlements (siehe ENTITLEMENTS) fuer alle uebergebenen User. PATCH mit
    'replace' ist idempotent - mehrfaches Ausfuehren aendert nichts an bereits korrekt
    gesetzten Entitlements. Retried bei HTTP 429 (Rate Limit) mit Backoff."""
    print("\n=== 2. Entitlements setzen ===")
    patch = {
        "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
        "Operations": [
            {"op": "replace", "path": "entitlements", "value": [{"value": e} for e in ENTITLEMENTS]}
        ],
    }
    for email in emails:
        user_id = user_ids.get(email)
        if user_id is None:
            print(f"  WARN {email} nicht im Workspace gefunden - uebersprungen")
            continue
        for attempt in range(5):
            resp = session.patch(f"{scim_url}/{user_id}", json=patch)
            if resp.status_code == 200:
                print(f"  OK   {email}")
                break
            if resp.status_code == 429:
                wait = 2 ** attempt
                time.sleep(wait)
                continue
            print(f"  FAIL {email} - HTTP {resp.status_code}: {resp.text}")
            break
        else:
            print(f"  FAIL {email} - weiterhin Rate Limit nach mehreren Versuchen")
        time.sleep(0.5)


def get_existing_groups(session: requests.Session, groups_url: str) -> dict[str, dict]:
    resp = session.get(groups_url, params={"count": 200})
    resp.raise_for_status()
    return {
        g["displayName"]: g
        for g in resp.json().get("Resources", [])
        if g.get("displayName", "").startswith("bis242_gruppe")
    }


def sync_group(
    session: requests.Session,
    groups_url: str,
    group_name: str,
    desired_emails: list[str],
    user_ids: dict[str, str],
    existing_groups: dict[str, dict],
) -> str:
    for email in desired_emails:
        if email not in user_ids:
            print(f"    WARN {email} nicht im Workspace gefunden - uebersprungen")
    desired_ids = {user_ids[e] for e in desired_emails if e in user_ids}

    group = existing_groups.get(group_name)
    if group is None:
        payload = {
            "schemas": ["urn:ietf:params:scim:schemas:core:2.0:Group"],
            "displayName": group_name,
            "members": [{"value": uid} for uid in desired_ids],
        }
        resp = session.post(groups_url, json=payload)
        resp.raise_for_status()
        return f"angelegt ({len(desired_ids)} Mitglieder)"

    group_id = group["id"]
    current_ids = {m["value"] for m in group.get("members", [])}
    to_add = desired_ids - current_ids
    to_remove = current_ids - desired_ids

    for uid in to_remove:
        patch = {
            "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
            "Operations": [{"op": "remove", "path": f'members[value eq "{uid}"]'}],
        }
        session.patch(f"{groups_url}/{group_id}", json=patch).raise_for_status()

    if to_add:
        patch = {
            "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
            "Operations": [
                {"op": "add", "path": "members", "value": [{"value": uid} for uid in to_add]}
            ],
        }
        session.patch(f"{groups_url}/{group_id}", json=patch).raise_for_status()

    if not to_add and not to_remove:
        return f"unveraendert ({len(current_ids)} Mitglieder)"
    return f"synchronisiert (+{len(to_add)} / -{len(to_remove)})"


def sync_groups(
    session: requests.Session, groups_url: str, gruppen: dict[str, list[str]], user_ids: dict[str, str]
) -> None:
    print("\n=== 3. Gruppen anlegen/synchronisieren ===")
    existing_groups = get_existing_groups(session, groups_url)
    for nr, emails in gruppen.items():
        group_name = f"bis242_gruppe{nr}"
        status = sync_group(session, groups_url, group_name, emails, user_ids, existing_groups)
        print(f"  OK   {group_name} - {status}")


def get_warehouse_id(session: requests.Session, host: str) -> str:
    resp = session.get(f"{host}/api/2.0/sql/warehouses")
    resp.raise_for_status()
    warehouses = resp.json().get("warehouses", [])
    if not warehouses:
        sys.exit("Fehler: Kein SQL-Warehouse im Workspace gefunden.")
    return warehouses[0]["id"]


def run_sql_statement(session: requests.Session, host: str, warehouse_id: str, statement: str) -> dict:
    payload = {"warehouse_id": warehouse_id, "statement": statement, "wait_timeout": "30s"}
    resp = session.post(f"{host}/api/2.0/sql/statements", json=payload)
    resp.raise_for_status()
    result = resp.json()
    # Bei COST_OPTIMIZED/gestopptem Warehouse kann der Status zunaechst PENDING/RUNNING sein
    statement_id = result["statement_id"]
    while result.get("status", {}).get("state") in ("PENDING", "RUNNING"):
        time.sleep(2)
        resp = session.get(f"{host}/api/2.0/sql/statements/{statement_id}")
        resp.raise_for_status()
        result = resp.json()
    return result


def create_catalogs(session: requests.Session, host: str, warehouse_id: str) -> None:
    print("\n=== 4. Kataloge anlegen ===")
    for i in range(1, 11):
        nr = f"{i:02d}"
        statement = f"CREATE CATALOG IF NOT EXISTS bis242_{nr} COMMENT 'BIS242 WS26 - Gruppe {nr}'"
        result = run_sql_statement(session, host, warehouse_id, statement)
        state = result.get("status", {}).get("state")
        if state == "SUCCEEDED":
            print(f"  OK   bis242_{nr}")
        else:
            print(f"  FAIL bis242_{nr} - {result.get('status')}")


def grant_permissions(
    session: requests.Session, host: str, warehouse_id: str, gruppen: dict[str, list[str]]
) -> None:
    """Vergibt Unity-Catalog-Berechtigungen auf die Gruppen-Kataloge.

    Einschraenkung: Unity Catalog erkennt ueber die Workspace-SCIM-API angelegte
    Gruppen (resourceType "WorkspaceGroup") nicht als Grant-Principal
    (Fehler PRINCIPAL_DOES_NOT_EXIST) - dafuer waeren Account-level-Gruppen noetig,
    die nur ueber die Account-Console-API verwaltbar sind. Als Workaround werden die
    Rechte daher direkt an die einzelnen Gruppenmitglieder (User-E-Mails) vergeben.
    """
    print("\n=== 5. Berechtigungen vergeben (Unity Catalog) ===")

    for i in range(1, 11):
        nr = f"{i:02d}"
        emails = gruppen.get(nr, [])
        if not emails:
            print(f"  SKIP bis242_{nr} - keine Mitglieder")
            continue
        for email in emails:
            statement = f"GRANT ALL PRIVILEGES ON CATALOG bis242_{nr} TO `{email}`"
            result = run_sql_statement(session, host, warehouse_id, statement)
            state = result.get("status", {}).get("state")
            if state == "SUCCEEDED":
                print(f"  OK   ALL PRIVILEGES bis242_{nr} -> {email}")
            else:
                print(f"  FAIL ALL PRIVILEGES bis242_{nr} -> {email} - {result.get('status')}")


def grant_token_permission(session: requests.Session, host: str) -> None:
    """Erlaubt allen Usern (eingebaute Gruppe 'users', enthaelt automatisch alle per
    SCIM angelegten User) das Erstellen eigener Personal Access Tokens. Idempotent:
    ueberschreibt die ACL mit demselben Stand, aendert also nichts bei erneuter
    Ausfuehrung. Die admins-Gruppe behaelt CAN_MANAGE."""
    print("\n=== 6. Token-Erstellung fuer alle User erlauben ===")
    payload = {
        "access_control_list": [
            {"group_name": "admins", "permission_level": "CAN_MANAGE"},
            {"group_name": "users", "permission_level": "CAN_USE"},
        ]
    }
    resp = session.put(f"{host}/api/2.0/permissions/authorization/tokens", json=payload)
    if resp.status_code == 200:
        print("  OK   Gruppe 'users' kann jetzt eigene Access Tokens erstellen (CAN_USE)")
    else:
        print(f"  FAIL HTTP {resp.status_code}: {resp.text}")


def main() -> None:
    host, token = load_config()
    gruppen, ohne_gruppe = load_gruppen()
    alle_emails = [e for members in gruppen.values() for e in members] + ohne_gruppe + DOZIERENDE

    print(f"Workspace: {host}")
    print(f"{len(alle_emails)} User gesamt ({len(DOZIERENDE)} Dozierende, {len(ohne_gruppe)} ohne Gruppe)")
    for nr, emails in gruppen.items():
        print(f"  Gruppe {nr}: {len(emails)} Mitglieder")

    session = requests.Session()
    session.headers.update(
        {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/scim+json",
            "Accept": "application/scim+json",
        }
    )

    scim_url = f"{host}/api/2.0/preview/scim/v2/Users"
    groups_url = f"{host}/api/2.0/preview/scim/v2/Groups"

    user_ids = sync_users(session, scim_url, alle_emails)
    set_entitlements(session, scim_url, alle_emails, user_ids)
    sync_groups(session, groups_url, gruppen, user_ids)

    # Fuer SQL-Statements wird kein SCIM-Content-Type benoetigt
    session.headers.update({"Content-Type": "application/json", "Accept": "application/json"})
    warehouse_id = get_warehouse_id(session, host)
    print(f"\nWarehouse: {warehouse_id} (startet automatisch falls gestoppt, kann ~1 Min dauern)")
    create_catalogs(session, host, warehouse_id)
    grant_permissions(session, host, warehouse_id, gruppen)
    grant_token_permission(session, host)

    print("\nFertig.")


if __name__ == "__main__":
    main()
