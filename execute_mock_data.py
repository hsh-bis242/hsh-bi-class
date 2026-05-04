"""Execute SQL mock data files against a Databricks workspace."""
import json
import urllib.request
import ssl
import sys
import os
import re
import time

DATABRICKS_HOST = "https://dbc-15d76289-5b7c.cloud.databricks.com"
TOKEN = "dapi2b8d40ce84bf6860af39a3669b934c82"
WAREHOUSE_ID = "4c4bcb9dfa01a5f0"

ctx = ssl.create_default_context()


def run_sql(statement):
    """Execute a single SQL statement."""
    url = f"{DATABRICKS_HOST}/api/2.0/sql/statements/"
    body = {
        "warehouse_id": WAREHOUSE_ID,
        "statement": statement,
        "wait_timeout": "50s",
    }
    payload = json.dumps(body).encode()
    req = urllib.request.Request(url, data=payload, headers={
        "Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json",
    })
    resp = urllib.request.urlopen(req, context=ctx, timeout=120)
    result = json.loads(resp.read())
    return result


def split_sql_statements(sql_text):
    """Split SQL file into individual statements."""
    # Remove comments
    lines = sql_text.split('\n')
    clean_lines = [l for l in lines if not l.strip().startswith('--')]
    full_text = '\n'.join(clean_lines).strip()
    
    # Split on semicolons, but be careful with values containing semicolons
    # Simple approach: split on ;\n (semicolon followed by newline)
    statements = []
    current = []
    for line in sql_text.split('\n'):
        if line.strip().startswith('--'):
            continue
        current.append(line)
        if line.rstrip().endswith(';'):
            stmt = '\n'.join(current).strip()
            if stmt and stmt != ';':
                # Remove trailing semicolon for API
                if stmt.endswith(';'):
                    stmt = stmt[:-1].strip()
                if stmt:
                    statements.append(stmt)
            current = []
    # Handle any remaining
    if current:
        stmt = '\n'.join(current).strip()
        if stmt and stmt != ';':
            if stmt.endswith(';'):
                stmt = stmt[:-1].strip()
            if stmt:
                statements.append(stmt)
    return statements


def execute_file(filepath):
    """Execute all SQL statements from a file."""
    print(f"\n{'='*60}")
    print(f"Processing: {filepath}")
    print(f"{'='*60}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        sql_text = f.read()
    
    statements = split_sql_statements(sql_text)
    print(f"  Found {len(statements)} statements")
    
    for i, stmt in enumerate(statements):
        stmt_preview = stmt[:80].replace('\n', ' ')
        print(f"  [{i+1}/{len(statements)}] {stmt_preview}...")
        
        try:
            result = run_sql(stmt)
            state = result.get('status', {}).get('state', 'UNKNOWN')
            if state == 'SUCCEEDED':
                print(f"    ✓ OK")
            elif state == 'FAILED':
                error = result.get('status', {}).get('error', {})
                print(f"    ✗ FAILED: {error.get('message', 'unknown')[:200]}")
                return False
            else:
                print(f"    ? State: {state}")
        except Exception as e:
            print(f"    ✗ ERROR: {e}")
            return False
    
    return True


# Tables ordered from small to large
TABLES = [
    "dim_snapshot",       # 3 rows
    "dim_association",    # 23 rows
    "dim_product",        # 378 rows
    "dim_customer",       # 1151 rows
    "dim_delivery",       # 10027 rows
    "fact_orderitem",     # 16408 rows
    "dim_date",           # 6222 rows
    "dim_order_date",     # 6222 rows
    "dim_delivery_date",  # 6222 rows
    "dim_request_date",   # 6222 rows
]

if __name__ == "__main__":
    mock_dir = "static/U05/mock_data"
    
    # First create schema
    print("Creating schema...")
    result = run_sql("CREATE SCHEMA IF NOT EXISTS bis242_00.willibald_ol_dm")
    print(f"  Schema: {result.get('status', {}).get('state', 'UNKNOWN')}")
    
    success = []
    failed = []
    
    for table in TABLES:
        filepath = f"{mock_dir}/{table}.sql"
        if not os.path.exists(filepath):
            print(f"  SKIP: {filepath} not found")
            failed.append(table)
            continue
        
        ok = execute_file(filepath)
        if ok:
            success.append(table)
        else:
            failed.append(table)
    
    print(f"\n{'='*60}")
    print(f"SUMMARY")
    print(f"{'='*60}")
    print(f"  Success: {len(success)} tables: {', '.join(success)}")
    if failed:
        print(f"  Failed:  {len(failed)} tables: {', '.join(failed)}")
    else:
        print(f"  All tables created successfully!")
