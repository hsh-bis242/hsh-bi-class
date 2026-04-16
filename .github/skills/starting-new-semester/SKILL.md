---
name: starting-new-semester
description: >
  Use when the user wants to prepare the BIS242 workspace for a new semester.
  This includes creating a new Databricks workspace, GitHub Classroom assignment,
  Moodle groups, QR codes, semester labels, group files, and Databricks setup notebooks.
user-invocable: true
metadata:
  author: BIS242
  version: "1.0"
---

# Neues Semester starten – BIS242

Dieser Skill führt alle Schritte durch, um den BIS242-Workspace auf ein neues Semester umzustellen.

## Voraussetzungen

Bevor du startest, brauchst du folgende Informationen vom Dozenten:

| Information | Beispiel | Variable |
|-------------|----------|----------|
| Neues Semester (Kürzel) | `ws26` oder `ss27` | `SEMESTER` |
| Semester-Label (lang) | `WiSe 2026/27` oder `SoSe 2027` | `SEMESTER_LABEL` |
| Neue Databricks Workspace-URL | `https://dbc-XXXXX.cloud.databricks.com/` | `DATABRICKS_URL` |
| Neuer GitHub Classroom Einladungslink | `https://classroom.github.com/a/XXXXXX` | `CLASSROOM_LINK` |
| Neuer Moodle-Kurslink | `https://moodle.hs-hannover.de/course/view.php?id=XXXXX` | `MOODLE_LINK` |
| Neuer Moodle-Gruppenwahllink | `https://moodle.hs-hannover.de/mod/choicegroup/view.php?id=XXXXX` | `MOODLE_GROUP_LINK` |

## Schritt-für-Schritt-Anleitung

### 1. Semestervariablen bestimmen

Leite aus dem Semester-Kürzel ab:

| Variable | Formel | Beispiel `ws26` |
|----------|--------|-----------------|
| `PREV_SEMESTER` | Vorgänger | `ss26` |
| `ASSIGNMENT_NAME` | `bis-242-{SEMESTER}` | `bis-242-ws26` |
| `PREV_ASSIGNMENT` | `bis-242-{PREV_SEMESTER}` | `bis-242-ss26` |
| `DB_SUFFIX` | `ss` oder `ws` | `ws` |
| `PREV_DB_SUFFIX` | Vorgänger | `ss` |

### 2. Databricks Workspace-URL aktualisieren

Ersetze die alte Databricks-URL in folgenden Dateien:

| Datei (hsh-bi-class) | Was suchen |
|-----------------------|------------|
| `U01_InfrastrukturZugang.html` | `https://dbc-...cloud.databricks.com` |
| `U03_DBTEinarbeitung.html` | `dbc-...cloud.databricks.com` (Host + URL) |
| `U08_Dashboard.html` | `https://dbc-...cloud.databricks.com` |
| `.github/copilot-instructions.md` | `https://dbc-...cloud.databricks.com` |

| Datei (hsh-bis242-bis-242-bis242base) | Was suchen |
|---------------------------------------|------------|
| `willibald_dwh/profiles.yml` | `host: dbc-...cloud.databricks.com` |
| `.github/copilot-instructions.md` | `https://dbc-...cloud.databricks.com` |

**Suchbefehl:**
```bash
grep -rn "dbc-" --include="*.html" --include="*.yml" --include="*.md" \
  /path/to/hsh-bi-class /path/to/hsh-bis242-bis-242-bis242base
```

### 3. GitHub Classroom Assignment aktualisieren

Ersetze den Einladungslink und den Assignment-Namen:

| Datei (hsh-bi-class) | Alt → Neu |
|-----------------------|-----------|
| `U01_InfrastrukturZugang.html` | `PREV_ASSIGNMENT` → `ASSIGNMENT_NAME`, alter Classroom-Link → `CLASSROOM_LINK` |
| `.github/copilot-instructions.md` | `PREV_ASSIGNMENT` → `ASSIGNMENT_NAME`, alter Link → `CLASSROOM_LINK` |

| Datei (hsh-bis242-bis-242-bis242base) | Alt → Neu |
|---------------------------------------|-----------|
| `.github/copilot-instructions.md` | `PREV_ASSIGNMENT` → `ASSIGNMENT_NAME`, alter Link → `CLASSROOM_LINK` |

**Suchbefehl:**
```bash
grep -rn "bis-242-${PREV_SEMESTER}\|classroom.github.com" --include="*.html" --include="*.md" \
  /path/to/hsh-bi-class /path/to/hsh-bis242-bis-242-bis242base
```

### 4. Moodle-Links aktualisieren

| Datei (hsh-bi-class) | Was |
|-----------------------|-----|
| `U01_InfrastrukturZugang.html` | Moodle-Gruppenwahllink → `MOODLE_GROUP_LINK` |
| `V01_OrganisatorischeVorbemerkungen.html` | Moodle-Kurslink → `MOODLE_LINK`, Semester-Label → `SEMESTER_LABEL` |

### 5. QR-Code ersetzen

1. Neue Umfrage erstellen (z. B. LimeSurvey, Google Forms)
2. QR-Code generieren
3. Datei ersetzen: `static/U01/QR_Code_Umfrage.png`

> Dieser Schritt erfordert manuellen Input – der QR-Code kann nicht automatisch generiert werden.

### 6. Semesterbezeichnungen in Übungsfolien aktualisieren

Ersetze das Semester-Kürzel in Databricks-Pfaden und Schema-Referenzen:

```bash
grep -rn "242${PREV_DB_SUFFIX}" --include="*.html" /path/to/hsh-bi-class
```

Typische Ersetzungen: `242ss` → `242ws` (oder umgekehrt) in:
- `U01_InfrastrukturZugang.html`
- `U03_DBTEinarbeitung.html`
- `U08_Dashboard.html`

### 7. V01 Organisatorische Vorbemerkungen prüfen

In `V01_OrganisatorischeVorbemerkungen.html`:
- Semester-Label aktualisieren (`SEMESTER_LABEL`)
- Terminübersicht prüfen und anpassen
- Moodle-Link prüfen
- Organisatorische Hinweise aktualisieren

### 8. Neue Gruppen-Datei anlegen

Erstelle `gruppen/{SEMESTER}.md` auf Basis der Vorlage:

```markdown
# Übungsgruppen – BIS242 {SEMESTER_UPPER}

> **Assignment:** `{ASSIGNMENT_NAME}`
> **Einladungslink:** <{CLASSROOM_LINK}>
> **Moodle:** <{MOODLE_LINK}>
> **Stand:** {DATUM}

## Gruppe 01 – ⚠️ **Thema fehlt**

| Name | E-Mail | GitHub |
|------|--------|--------|

## Gruppe 02 – ⚠️ **Thema fehlt**

| Name | E-Mail | GitHub |
|------|--------|--------|

(... bis Gruppe 10)

## Ohne Gruppe

| Name | E-Mail | GitHub | Thema |
|------|--------|--------|-------|
```

### 9. Databricks Setup-Notebook erstellen

Erstelle `gruppen/setup_databricks_{SEMESTER}.ipynb` auf Basis von `gruppen/setup_databricks_ss26.ipynb`:

Das Notebook enthält:
1. **Konfiguration** – Workspace-URL und Admin-Token
2. **Gruppendefinition** – Python-Dict mit E-Mails (anfangs leer)
3. **User anlegen** – SCIM API (`POST /api/2.0/preview/scim/v2/Users`)
4. **User-Kontrolle** – Alle Workspace-User auflisten
5. **Gruppen anlegen** – SCIM Groups API + Mitglieder zuweisen
6. **Datenbanken anlegen** – `CREATE DATABASE IF NOT EXISTS bis242_XX`
7. **Owner setzen** – Erstes Gruppenmitglied als DB-Owner
8. **Aufräumen** – Auskommentierter Block für Semesterende

Aktualisiere im Notebook:
- `WORKSPACE_URL` → `DATABRICKS_URL`
- Alle `SS26` / `ss26` Referenzen → neues Semester
- Gruppen-Dict leeren (wird nach Moodle-Gruppenbildung befüllt)

### 10. Copilot-Instructions in beiden Repos aktualisieren

In `.github/copilot-instructions.md` beider Repos:
- `Aktuelles Assignment:` → `ASSIGNMENT_NAME`
- `Einladungslink:` → `CLASSROOM_LINK`
- `Aktuelle Workspace-URL:` → `DATABRICKS_URL`
- Semester-Referenz (z. B. `Sommersemester 2026`) → `SEMESTER_LABEL`

### 11. Altes Semester aufräumen (optional)

Am Ende des Vorsemesters:
- Aufräum-Block im alten Setup-Notebook ausführen (Datenbanken löschen, User deaktivieren)
- Alte Gruppen-Datei bleibt als Archiv erhalten
- Alte Setup-Dateien bleiben als Referenz erhalten

## Checkliste zum Abhaken

```
[ ] Databricks Workspace erstellt, URL notiert
[ ] GitHub Classroom Assignment erstellt, Link notiert
[ ] Moodle-Kurs + Gruppenwahl erstellt, Links notiert
[ ] Databricks-URL in 6 Dateien aktualisiert
[ ] Classroom-Link in 4 Dateien aktualisiert
[ ] Moodle-Links in 2 Dateien aktualisiert
[ ] QR-Code erstellt und ersetzt
[ ] Semesterbezeichnungen in Übungsfolien aktualisiert
[ ] V01 Organisatorische Vorbemerkungen geprüft
[ ] Neue Gruppen-Datei angelegt (gruppen/{SEMESTER}.md)
[ ] Neues Setup-Notebook erstellt (gruppen/setup_databricks_{SEMESTER}.ipynb)
[ ] Copilot-Instructions in beiden Repos aktualisiert
[ ] Alle Änderungen committed und gepusht
```

## Dateien-Übersicht (alle betroffenen Dateien)

### hsh-bi-class

| Datei | Änderungstyp |
|-------|-------------|
| `U01_InfrastrukturZugang.html` | Databricks-URL, Classroom-Link, Assignment-Name, Moodle-Link |
| `U03_DBTEinarbeitung.html` | Databricks Host + URL |
| `U08_Dashboard.html` | Databricks-URL, Semester-Kürzel |
| `V01_OrganisatorischeVorbemerkungen.html` | Moodle-Link, Semester-Label, Termine |
| `static/U01/QR_Code_Umfrage.png` | QR-Code ersetzen |
| `gruppen/{SEMESTER}.md` | Neu erstellen |
| `gruppen/setup_databricks_{SEMESTER}.ipynb` | Neu erstellen |
| `.github/copilot-instructions.md` | Assignment, Link, Databricks-URL |

### hsh-bis242-bis-242-bis242base

| Datei | Änderungstyp |
|-------|-------------|
| `willibald_dwh/profiles.yml` | Databricks Host |
| `.github/copilot-instructions.md` | Assignment, Link, Databricks-URL |
