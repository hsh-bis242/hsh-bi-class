# Referenzlösung – Übung 03: dbt Einarbeitung

## Modell: `models/04_il_bdv/uebung3_{kuerzel}.sql`

```sql
{{ config(materialized='table') }}

SELECT
    b.bestellungid,
    b.bestelldatum,
    k.vorname,
    k.name
FROM {{ ref('webshop_bestellung') }} b
JOIN {{ ref('webshop_kunde') }} k
    ON b.kundeid = k.kundeid
WHERE b.bestelldatum = '2022-03-20'
```

### Erwartetes Ergebnis

Die Tabelle enthält alle Bestellungen vom 20.03.2022 mit den Vor- und Nachnamen der zugehörigen Kunden.

## Dokumentation: `models/04_il_bdv/uebung3_{kuerzel}.yml`

```yaml
version: 2
models:
  - name: uebung3_{kuerzel}
    description: "Bestellungen vom 20.03.2022 mit Kundennamen"
    columns:
      - name: bestellungid
        description: "ID der Bestellung"
      - name: bestelldatum
        description: "Datum der Bestellung"
      - name: vorname
        description: "Vorname des Kunden"
      - name: name
        description: "Nachname des Kunden"
```

## Prüfpunkte

- [ ] `.sql`-Datei mit `{{ config(materialized='table') }}` vorhanden
- [ ] `{{ ref('...') }}` statt Hardcoded-Tabellennamen verwendet
- [ ] JOIN über `kundeid` korrekt
- [ ] WHERE-Klausel filtert auf `2022-03-20`
- [ ] `.yml`-Datei mit Beschreibung vorhanden
- [ ] Tabelle in Databricks (Schema `il_bdv`) sichtbar
- [ ] Pull Request auf GitHub erstellt
