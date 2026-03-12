# Referenzlösung – Übung 05: DWH Modell und Star Schema

## Sternschema-Konzept: `models/05_ol_dm/sternschema.md`

```markdown
# Sternschema Willibald Webshop

## Fakten (Kennzahlen)
- Menge (Anzahl bestellter Produkte)
- Positionspreis (Preis pro Position)
- Rabatt (Rabatt auf die Bestellung)

## Dimensionen
- Kunde (kundeid, vorname, nachname, geschlecht, email)
- Produkt (produktid, bezeichnung, preis, produktkategorie)
- Zeit (bestelldatum)
```

## Dimension: `models/05_ol_dm/dim_kunde.sql`

```sql
SELECT
    k.kundeid    AS kunde_id,
    k.vorname,
    k.name       AS nachname,
    k.geschlecht,
    k.email
FROM {{ ref('webshop_kunde') }} k
WHERE k.sys_cdc != 'D'
```

## Faktentabelle: `models/05_ol_dm/fact_bestellposition.sql`

```sql
SELECT
    b.bestellungid,
    p.posid,
    b.kundeid      AS kunde_id,
    p.produktid    AS produkt_id,
    b.bestelldatum,
    p.menge,
    p.preis        AS positionspreis,
    b.rabatt
FROM {{ ref('webshop_bestellung') }} b
JOIN {{ ref('webshop_position') }} p
    ON b.bestellungid = p.bestellungid
WHERE b.sys_cdc != 'D'
```

## Optionale Erweiterungen

### `models/05_ol_dm/dim_produkt.sql`

```sql
SELECT
    p.produktid   AS produkt_id,
    p.bezeichnung,
    p.preis,
    pk.name       AS kategorie
FROM {{ ref('webshop_produkt') }} p
LEFT JOIN {{ ref('webshop_produktkategorie') }} pk
    ON p.katid = pk.katid
WHERE p.sys_cdc != 'D'
```

## Prüfpunkte

- [ ] `sternschema.md` mit identifizierten Fakten und Dimensionen vorhanden
- [ ] `dim_kunde.sql` mit Kundenspalten und `sys_cdc != 'D'`-Filter
- [ ] `fact_bestellposition.sql` mit JOIN und Kennzahlen
- [ ] Modelle in Databricks im Schema `ol_dm` sichtbar
- [ ] Änderungen auf Branch `uebung` gepusht
- [ ] Pull Request erstellt
