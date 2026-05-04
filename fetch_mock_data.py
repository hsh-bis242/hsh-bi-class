"""Fetch all data from Databricks source and generate SQL setup script."""
import json
import urllib.request
import ssl
import sys

DATABRICKS_HOST = "https://dbc-77aa5718-ad9a.cloud.databricks.com"
TOKEN = "dapi66d7211caaa71ccb40c3dd9c3ecfb7f6"
WAREHOUSE_ID = "9d9d44f9428c50eb"
SOURCE_SCHEMA = "bis242_00.willibald_ol_dm"
TARGET_CATALOG = "bis242_00"
TARGET_SCHEMA = "willibald_ol_dm"

TABLES = [
    "dim_association", "dim_customer", "dim_product", "dim_delivery",
    "dim_snapshot", "fact_orderitem", "dim_date", "dim_order_date",
    "dim_delivery_date", "dim_request_date"
]

# Type mapping from Databricks to SQL types
TYPE_MAP = {
    "STRING": "STRING",
    "BIGINT": "BIGINT",
    "INT": "INT",
    "DOUBLE": "DOUBLE",
    "BOOLEAN": "BOOLEAN",
    "TIMESTAMP": "TIMESTAMP",
}

ctx = ssl.create_default_context()

def run_sql(statement, row_limit=None):
    """Execute SQL via Databricks SQL Statement API and return result."""
    url = f"{DATABRICKS_HOST}/api/2.0/sql/statements/"
    body = {
        "warehouse_id": WAREHOUSE_ID,
        "statement": statement,
        "wait_timeout": "50s",
    }
    if row_limit:
        body["row_limit"] = row_limit
    payload = json.dumps(body).encode()
    req = urllib.request.Request(url, data=payload, headers={
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json",
    })
    with urllib.request.urlopen(req, context=ctx, timeout=120) as resp:
        return json.loads(resp.read())


def get_columns(table):
    """Get column definitions for a table."""
    result = run_sql(f"DESCRIBE TABLE {SOURCE_SCHEMA}.{table}")
    cols = []
    for row in result["result"]["data_array"]:
        name, dtype, _ = row
        sql_type = TYPE_MAP.get(dtype.upper(), dtype.upper())
        cols.append((name, sql_type))
    return cols


def get_data(table):
    """Fetch all rows for a table."""
    result = run_sql(f"SELECT * FROM {SOURCE_SCHEMA}.{table}")
    if result["status"]["state"] != "SUCCEEDED":
        print(f"  ERROR fetching {table}: {result['status']}", file=sys.stderr)
        return [], []
    columns = [c["name"] for c in result["manifest"]["schema"]["columns"]]
    col_types = [c["type_name"] for c in result["manifest"]["schema"]["columns"]]
    rows = result["result"]["data_array"]
    total = result["manifest"]["total_row_count"]
    print(f"  {table}: {len(rows)} rows fetched (total: {total})", file=sys.stderr)

    # Handle pagination via external links
    if result["manifest"]["total_chunk_count"] > 1:
        for chunk in result["manifest"]["chunks"][1:]:
            chunk_url = f"{DATABRICKS_HOST}/api/2.0/sql/statements/{result['statement_id']}/result/chunks/{chunk['chunk_index']}"
            req = urllib.request.Request(chunk_url, headers={
                "Authorization": f"Bearer {TOKEN}",
            })
            with urllib.request.urlopen(req, context=ctx) as resp:
                chunk_data = json.loads(resp.read())
                if "data_array" in chunk_data:
                    rows.extend(chunk_data["data_array"])
                elif "external_links" in chunk_data:
                    for link in chunk_data["external_links"]:
                        ext_req = urllib.request.Request(link["external_link"])
                        with urllib.request.urlopen(ext_req, context=ctx) as ext_resp:
                            ext_data = json.loads(ext_resp.read())
                            rows.extend(ext_data)
        print(f"  {table}: {len(rows)} rows after pagination", file=sys.stderr)

    return (columns, col_types), rows


def escape_sql(val, col_type):
    """Escape a value for SQL INSERT."""
    if val is None or val == "":
        return "NULL"
    if col_type in ("STRING",):
        escaped = str(val).replace("'", "''")
        return f"'{escaped}'"
    if col_type in ("BOOLEAN",):
        return str(val).lower()
    if col_type in ("TIMESTAMP",):
        return f"TIMESTAMP '{val}'"
    return str(val)


def generate_table_sql(table, cols, col_types, rows):
    """Generate SQL for a single table."""
    lines = []
    lines.append(f"-- {table} ({len(rows)} rows)")
    lines.append(f"DROP TABLE IF EXISTS {TARGET_CATALOG}.{TARGET_SCHEMA}.{table};")
    col_defs = ",\n  ".join(f"`{name}` {dtype}" for name, dtype in cols)
    lines.append(f"CREATE TABLE {TARGET_CATALOG}.{TARGET_SCHEMA}.{table} (\n  {col_defs}\n);")
    lines.append("")
    batch_size = 500
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i+batch_size]
        lines.append(f"INSERT INTO {TARGET_CATALOG}.{TARGET_SCHEMA}.{table} VALUES")
        value_lines = []
        for row in batch:
            vals = ", ".join(escape_sql(v, col_types[j]) for j, v in enumerate(row))
            value_lines.append(f"  ({vals})")
        lines.append(",\n".join(value_lines) + ";")
        lines.append("")
    return "\n".join(lines)


if __name__ == "__main__":
    import os

    # Fetch all data first
    table_data = {}
    for table in TABLES:
        print(f"Fetching {table}...", file=sys.stderr)
        (col_names, col_types), rows = get_data(table)
        cols = list(zip(col_names, [TYPE_MAP.get(t.upper(), t.upper()) for t in col_types]))
        table_data[table] = (cols, col_types, rows)

    # Write combined file
    combined_lines = []
    combined_lines.append(f"-- ============================================================")
    combined_lines.append(f"-- Mock-Daten für Dashboard-Übung")
    combined_lines.append(f"-- Katalog: {TARGET_CATALOG} / Schema: {TARGET_SCHEMA}")
    combined_lines.append(f"-- ============================================================")
    combined_lines.append("")
    combined_lines.append(f"CREATE SCHEMA IF NOT EXISTS {TARGET_CATALOG}.{TARGET_SCHEMA};")
    combined_lines.append("")
    for table in TABLES:
        cols, col_types, rows = table_data[table]
        combined_lines.append(generate_table_sql(table, cols, col_types, rows))
    combined_sql = "\n".join(combined_lines)
    output_path = "static/U05/setup_mock_data.sql"
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(combined_sql)
    print(f"\nCombined SQL: {output_path} ({len(combined_sql):,} chars)", file=sys.stderr)

    # Write per-table files
    per_table_dir = "static/U05/mock_data"
    os.makedirs(per_table_dir, exist_ok=True)
    for table in TABLES:
        cols, col_types, rows = table_data[table]
        table_sql = generate_table_sql(table, cols, col_types, rows)
        filepath = f"{per_table_dir}/{table}.sql"
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(table_sql)
        print(f"  {filepath} ({len(table_sql):,} chars)", file=sys.stderr)
    print("Done.", file=sys.stderr)
