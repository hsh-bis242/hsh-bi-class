# Referenzlösung – Übung 04: dbt Tests und Macros

## Modell (Grundversion): `models/04_il_bdv/uebung4_{kuerzel}.sql`

```sql
{{ config(materialized='table') }}

SELECT
    p.bestellungid,
    p.posid,
    p.menge,
    p.preis       AS positionspreis,
    pr.bezeichnung AS produktname,
    pr.preis       AS produktpreis
FROM {{ ref('webshop_position') }} p
JOIN {{ ref('webshop_produkt') }} pr
    ON p.produktid = pr.produktid
```

## Tests: `models/04_il_bdv/uebung4_{kuerzel}.yml`

```yaml
version: 2
models:
  - name: uebung4_{kuerzel}
    description: "Bestellpositionen mit Produktinfos"
    columns:
      - name: produktname
        data_tests:
          - not_null
      - name: positionspreis
        data_tests:
          - not_null
```

## Macro: `macros/euro_to_dollar.sql`

```sql
{% macro euro_to_dollar(column_name) %}
    ROUND({{ column_name }} * 1.08, 2)
{% endmacro %}
```

## Modell (mit Macro): `models/04_il_bdv/uebung4_{kuerzel}.sql`

```sql
{{ config(materialized='table') }}

SELECT
    p.bestellungid,
    p.posid,
    p.preis        AS positionspreis_eur,
    pr.preis       AS produktpreis_eur,
    {{ euro_to_dollar('p.preis') }}  AS positionspreis_usd,
    {{ euro_to_dollar('pr.preis') }} AS produktpreis_usd,
    p.menge,
    pr.bezeichnung AS produktname
FROM {{ ref('webshop_position') }} p
JOIN {{ ref('webshop_produkt') }} pr
    ON p.produktid = pr.produktid
```

## Prüfpunkte

- [ ] `.sql`-Datei mit JOIN über `produktid` vorhanden
- [ ] `.yml`-Datei mit mindestens einem `not_null`-Test vorhanden
- [ ] `dbt test` läuft erfolgreich (Screenshot vorhanden)
- [ ] Macro `euro_to_dollar.sql` in `macros/` erstellt
- [ ] Macro im Modell verwendet (`positionspreis_usd` o.ä.)
- [ ] `dbt compile` zeigt aufgelöstes Macro-SQL
- [ ] Änderungen auf Branch `uebung` gepusht
