# Checkliste Semesterwechsel

Folgende Schritte sind zu Beginn jedes neuen Semesters erforderlich:

## 1. Databricks Workspace
- Neuen Databricks-Community-Workspace erstellen.
- Workspace-URL in `U01_InfrastrukturZugang.html` und in `.github/copilot-instructions.md` (beide Repos) aktualisieren.

## 2. Gruppen-Repositories (kein GitHub Classroom mehr)
- Einmalig statisch anlegen: `gruppen/create_group_repos.sh <prefix> <anzahl-gruppen>` (z. B. `bis-242-ws26 10`).
- Beitritt der Studierenden läuft danach eigenständig per Self-Service-Issue "Gruppen-Beitritt" (siehe `.github/ISSUE_TEMPLATE/gruppe-beitritt.yml` + zugehörige Action).
- Zugriff erfolgt über ein gruppenspezifisches GitHub-Team mit Push-Recht nur auf das eigene Repo.

## 3. Vorkenntnisse
- Werden mündlich in der Vorlesung abgefragt (keine QR-Code-Umfrage mehr nötig).

## 4. Moodle-Gruppen
- Gruppen in Moodle anlegen oder zurücksetzen.
- Moodle-Link in `U01_InfrastrukturZugang.html` prüfen.

## 5. Semesterbezeichnungen
- In den Übungsfolien `242ss` → `242ws` (oder umgekehrt) aktualisieren.

## 6. Vorlesungsfolien
- `V01_OrganisatorischeVorbemerkungen.html` auf aktuelle Termine und organisatorische Hinweise prüfen.