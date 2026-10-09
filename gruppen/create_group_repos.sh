#!/usr/bin/env bash
# ============================================================
# create_group_repos.sh
# ------------------------------------------------------------
# Einmaliges, statisches Setup zu Semesterbeginn:
# Legt für die Gruppen 01..N ein privates GitHub-Repository aus
# dem Template-Repository hsh-bis242-bis-242-bis242base an und
# ein gleichnamiges, noch leeres GitHub-Team mit Push-Recht NUR
# auf das jeweils eigene Gruppen-Repo.
#
# Die Aufnahme der Studierenden in ihr Team erfolgt NICHT durch
# dieses Skript, sondern per Self-Service über das GitHub-Issue-
# Formular "Gruppen-Beitritt" (.github/ISSUE_TEMPLATE/gruppe-
# beitritt.yml) + die Action .github/workflows/gruppe-beitritt.yml.
#
# Idempotent: kann gefahrlos mehrfach ausgeführt werden.
#
# Voraussetzungen:
#   - GitHub CLI (gh) installiert und eingeloggt:
#       brew install gh
#       gh auth login
#     (Account benötigt Owner/Admin-Rechte in der Organisation)
#   - Das Basis-Repo ist einmalig als "Template repository"
#     markiert (Settings → General → Template repository), z. B.:
#       gh api -X PATCH repos/hsh-bis242/hsh-bis242-bis-242-bis242base \
#         -f is_template=true
#
# Namensschema (muss zu U01_InfrastrukturZugang.html und zur
# Action gruppe-beitritt.yml passen):
#   Repo:  <prefix>-gruppe<NN>   z. B. bis-242-ws26-gruppe02
#   Team:  <prefix>-gruppe<NN>   z. B. bis-242-ws26-gruppe02
#
# Nutzung:
#   ./create_group_repos.sh bis-242-ws26 10
#
#   $1 = Präfix für die Repo-/Teamnamen (z. B. bis-242-ws26)
#   $2 = Anzahl Gruppen (optional, Default: 10)
# ============================================================
set -euo pipefail

ORG="hsh-bis242"
TEMPLATE_REPO="hsh-bis242-bis-242-bis242base"

PREFIX="${1:?Usage: $0 <repo-prefix> [anzahl-gruppen=10]}"
NUM_GROUPS="${2:-10}"

command -v gh >/dev/null 2>&1 || {
	echo "❌ GitHub CLI (gh) nicht gefunden. Installation: brew install gh" >&2
	exit 1
}
gh auth status >/dev/null 2>&1 || {
	echo "❌ Bitte zuerst 'gh auth login' ausführen." >&2
	exit 1
}

for i in $(seq -w 1 "$NUM_GROUPS"); do
	gruppe="$i"
	repo="${PREFIX}-gruppe${gruppe}"
	team="${PREFIX}-gruppe${gruppe}"

	echo "▶ Gruppe ${gruppe} → Repo ${ORG}/${repo}, Team ${team}"

	# 1) Repo aus Template erzeugen (falls noch nicht vorhanden)
	if gh repo view "${ORG}/${repo}" >/dev/null 2>&1; then
		echo "  • Repo existiert bereits, überspringe Erstellung."
	else
		gh repo create "${ORG}/${repo}" \
			--private \
			--template "${ORG}/${TEMPLATE_REPO}"
		echo "  • Repo erstellt."
	fi

	# 2) Team anlegen (falls noch nicht vorhanden), noch ohne Mitglieder
	if gh api "orgs/${ORG}/teams/${team}" >/dev/null 2>&1; then
		echo "  • Team existiert bereits."
	else
		gh api "orgs/${ORG}/teams" -f name="${team}" -f privacy=closed >/dev/null
		echo "  • Team erstellt (noch ohne Mitglieder)."

		# GitHub fügt den Ersteller eines Teams automatisch als Maintainer
		# hinzu. Das verfälscht die Kapazitätsprüfung (max. 3) in der
		# Self-Service-Action, da sie alle Team-Mitglieder zählt.
		# Daher: Ersteller sofort wieder aus dem Team entfernen.
		CREATOR="$(gh api user --jq .login)"
		gh api -X DELETE "orgs/${ORG}/teams/${team}/memberships/${CREATOR}" >/dev/null 2>&1 || true
		echo "  • Ersteller (${CREATOR}) aus Team entfernt (nur Studierende sollen zählen)."
	fi

	# 3) Team bekommt Push-Recht NUR auf dieses eine Repo
	gh api -X PUT "orgs/${ORG}/teams/${team}/repos/${ORG}/${repo}" -f permission=push >/dev/null
	echo "  • Push-Recht auf ${repo} gesetzt."
done

echo "✅ Fertig. ${NUM_GROUPS} Repos + Teams angelegt (noch ohne Mitglieder)."
echo "   Studierende treten per GitHub-Issue \"Gruppen-Beitritt\" selbst ihrem Team bei."
