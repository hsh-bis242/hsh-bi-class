"""Direct workspace-to-workspace data transfer with schema renames.

Reads from source Databricks, writes directly to target Databricks.
No intermediate files. Streams in batches of 1000 rows.

Schema renames:
  - dim_association → dim_club (association_name → club_name, hkey_dim_association → hkey_dim_club)
  - dim_request_date → dim_purchase_date (hkey_dim_request_date → hkey_dim_purchase_date)
  - fact_orderitem: hkey_dim_requesteddate → hkey_dim_purchasedate, hkey_dim_association → hkey_dim_club
"""
import json
import urllib.request
import ssl
import sys
import time

# Source workspace (read-only)
SRC_HOST = "https://dbc-77aa5718-ad9a.cloud.databricks.com"
SRC_TOKEN = "dapi66d7211caaa71ccb40c3dd9c3ecfb7f6"
SRC_WAREHOUSE = "9d9d44f9428c50eb"
SRC_SCHEMA = "bis242_00.willibald_ol_dm"

# Target workspace (write)
TGT_HOST = "https://dbc-15d76289-5b7c.cloud.databricks.com"
TGT_TOKEN = "dapi2b8d40ce84bf6860af39a3669b934c82"
TGT_WAREHOUSE = "4c4bcb9dfa01a5f0"
TGT_SCHEMA = "bis242_00.willibald_ol_dm"

ctx = ssl.create_default_context()

# Column renames per table: {src_col: tgt_col}
COLUMN_RENAMES = {
    "dim_association": {
        "hkey_dim_association": "hkey_dim_club",
        "association_name": "club_name",
    },
    "dim_request_date": {
        "hkey_dim_request_date": "hkey_dim_purchase_date",
    },
    "fact_orderitem": {
        "hkey_dim_requesteddate": "hkey_dim_purchasedate",
        "hkey_dim_association": "hkey_dim_club",
    },
}

# Table renames: {src_table: tgt_table}
TABLE_RENAMES = {
    "dim_association": "dim_club",
    "dim_request_date": "dim_purchase_date",
}

# Order: small tables first
TABLES = [
    "dim_snapshot", "dim_association", "dim_product", "dim_customer",
    "dim_delivery", "dim_date", "dim_order_date", "dim_delivery_date",
    "dim_request_date", "fact_orderitem",
]

TYPE_MAP = {
    "STRING": "STRING", "BIGINT": "BIGINT", "INT": "INT",
    "DOUBLE": "DOUBLE", "BOOLEAN": "BOOLEAN", "TIMESTAMP": "TIMESTAMP",
}

BATCH_SIZE = 1000


def api_call(host, token, warehouse, statement, timeout=120):
    """Execute SQL on a Databricks workspace."""
    url = f"{host}/api/2.0/sql/statements/"
    body = {"warehouse_id": warehouse, "statement": statement, "wait_timeout": "50s"}
    payload = json.dumps(body).encode()
    req = urllib.request.Request(url, data=payload, headers={
        "Authorization": f"Bearer {token}", "Content-Type": "application/json",
    })
    with urllib.request.urlopen(req, context=ctx, timeout=timeout) as resp:
        return json.loads(resp.read())


def src_sql(stmt):
    return api_call(SRC_HOST, SRC_TOKEN, SRC_WAREHOUSE, stmt)

def tgt_sql(stmt):
    return api_call(TGT_HOST, TGT_TOKEN, TGT_WAREHOUSE, stmt)


def escape_val(val, col_type):
    if val is None or val == "":
        return "NULL"
    if col_type in ("STRING",):
        return "'" + str(val).replace("'", "''") + "'"
    if col_type in ("BOOLEAN",):
        return str(val).lower()
    if col_type in ("TIMESTAMP",):
        return f"TIMESTAMP '{val}'"
    return str(val)


def rename_col(table, col_name):
    """Apply column rename for a given source table."""
    renames = COLUMN_RENAMES.get(table, {})
    return renames.get(col_name, col_name)


def transfer_table(src_table):
    """Transfer one table from source to target workspace."""
    tgt_table = TABLE_RENAMES.get(src_table, src_table)
    tgt_full = f"{TGT_SCHEMA}.{tgt_table}"

    print(f"\n--- {src_table} → {tgt_table} ---")

    # Get schema from source
    desc = src_sql(f"DESCRIBE TABLE {SRC_SCHEMA}.{src_table}")
    if desc["status"]["state"] != "SUCCEEDED":
        print(f"  SKIP: cannot describe {src_table}")
        return False

    src_cols = []
    tgt_cols = []
    col_types = []
    for row in desc["result"]["data_array"]:
        name, dtype, _ = row
        sql_type = TYPE_MAP.get(dtype.upper(), dtype.upper())
        src_cols.append(name)
        tgt_cols.append(rename_col(src_table, name))
        col_types.append(sql_type)

    # Drop + Create on target
    col_defs = ", ".join(f"`{c}` {t}" for c, t in zip(tgt_cols, col_types))
    tgt_sql(f"DROP TABLE IF EXISTS {tgt_full}")
    r = tgt_sql(f"CREATE TABLE {tgt_full} ({col_defs})")
    if r["status"]["state"] != "SUCCEEDED":
        print(f"  FAILED to create table: {r['status']}")
        return False
    print(f"  Created {tgt_full} ({len(tgt_cols)} cols)")

    # Count rows
    cnt = src_sql(f"SELECT COUNT(*) FROM {SRC_SCHEMA}.{src_table}")
    total_rows = int(cnt["result"]["data_array"][0][0])
    print(f"  {total_rows} rows to transfer")

    if total_rows == 0:
        return True

    # Transfer in batches using LIMIT/OFFSET
    transferred = 0
    offset = 0
    while offset < total_rows:
        # Fetch batch from source
        fetch = src_sql(f"SELECT * FROM {SRC_SCHEMA}.{src_table} LIMIT {BATCH_SIZE} OFFSET {offset}")
        if fetch["status"]["state"] != "SUCCEEDED":
            print(f"  FAILED to read at offset {offset}")
            return False

        rows = fetch["result"]["data_array"]
        if not rows:
            break

        ftypes = [c["type_name"] for c in fetch["manifest"]["schema"]["columns"]]

        # Build INSERT
        value_rows = []
        for row in rows:
            vals = ", ".join(escape_val(v, ftypes[j]) for j, v in enumerate(row))
            value_rows.append(f"({vals})")

        insert_sql = f"INSERT INTO {tgt_full} VALUES\n" + ",\n".join(value_rows)
        r = tgt_sql(insert_sql)
        if r["status"]["state"] != "SUCCEEDED":
            err = r.get("status", {}).get("error", {}).get("message", "unknown")
            print(f"  FAILED INSERT at offset {offset}: {err[:200]}")
            return False

        transferred += len(rows)
        offset += BATCH_SIZE
        pct = min(100, int(transferred / total_rows * 100))
        print(f"  {transferred}/{total_rows} ({pct}%)", end="\r")

    print(f"  {transferred}/{total_rows} (100%) ✓")
    return True


if __name__ == "__main__":
    start = time.time()

    # Create schema on target
    print("Creating target schema...")
    r = tgt_sql(f"CREATE SCHEMA IF NOT EXISTS {TGT_SCHEMA}")
    print(f"  Schema: {r['status']['state']}")

    ok, fail = [], []
    for table in TABLES:
        if transfer_table(table):
            ok.append(table)
        else:
            fail.append(table)

    elapsed = time.time() - start
    print(f"\n{'='*50}")
    print(f"Done in {elapsed:.0f}s")
    print(f"  OK:     {len(ok)} tables ({', '.join(ok)})")
    if fail:
        print(f"  FAILED: {len(fail)} tables ({', '.join(fail)})")
    else:
        print("  All tables transferred successfully!")
