-- ============================================================
-- Databricks Workspace-Setup BIS242 WS26 (Unity Catalog)
-- ============================================================
-- Dieses Skript dokumentiert die Kataloge und Berechtigungen, die
-- für alle Gruppen im Wintersemester 2026 angelegt werden.
--
-- Zielumgebung: Databricks Free Edition mit Unity Catalog
--               → Kataloge statt Datenbanken/Schemas,
--                 kein SQL-basiertes User-/Gruppenmanagement
--
-- Einschränkung: Über die Workspace-SCIM-API angelegte Gruppen
-- (resourceType "WorkspaceGroup") werden von Unity Catalog NICHT
-- als Grant-Principal erkannt (Fehler PRINCIPAL_DOES_NOT_EXIST).
-- Dafür wären Account-level-Gruppen nötig, die nur über die
-- separate Account-Console-API verwaltbar sind (eigene
-- Authentifizierung, nicht über das Workspace-Token erreichbar).
-- Als Workaround werden die Rechte daher direkt an die einzelnen
-- Gruppenmitglieder (User-E-Mails) vergeben.
--
-- User anlegen, Gruppen anlegen/synchronisieren, Kataloge anlegen
-- und Grants vergeben erfolgt NICHT manuell hier, sondern
-- automatisiert über das Skript setup_databricks_ws26.py (liest
-- die Gruppenzuordnung direkt aus ws26_github.csv). Dieses SQL
-- dient nur als Referenz/manuelle Fallback-Option.
--
-- Ausführung: Als Workspace-Admin in einem Databricks Notebook
--             ausführen (eine Zelle pro Abschnitt), falls nicht
--             über setup_databricks_ws26.py gearbeitet wird.
--
-- Catalog-Namenskonvention:  bis242_XX  (XX = Gruppennummer)
-- Dozenten-Catalog:          bis242_00  (bleibt unverändert)
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. USER & GRUPPEN (siehe setup_databricks_ws26.py)
-- ────────────────────────────────────────────────────────────
-- User und Gruppen können NICHT per SQL angelegt werden.
-- setup_databricks_ws26.py erledigt dies automatisiert über die
-- SCIM API, abgeleitet aus ws26_github.csv.
--
-- Alternative (manuell): Settings → Admin Settings → Users → Invite User
--
-- Gruppe 01: (noch keine Moodle-Gruppe zugeordnet)
--
-- Gruppe 02 – BIS24202:
--   jonathan.jacob@stud.hs-hannover.de
--   ethan.menzel@stud.hs-hannover.de
--   bogdan.mosmann@stud.hs-hannover.de
--
-- Gruppe 03 – BIS24203:
--   daniel.engel@stud.hs-hannover.de
--
-- Gruppe 04 – BIS24204:
--   mohammad-javad.nuri@stud.hs-hannover.de
--   aleksandr.trifonov@stud.hs-hannover.de
--
-- Gruppe 05 – BIS24205:
--   umar.ruslanovic-humasev@stud.hs-hannover.de
--
-- Gruppe 06 – BIS24206:
--   ky-duyen.doan@stud.hs-hannover.de
--   bettina.habenicht@stud.hs-hannover.de
--
-- Gruppe 07 – BIS24207:
--   tobias.kraemer@stud.hs-hannover.de
--   fynn.nehmer@stud.hs-hannover.de
--
-- Gruppe 08 – BIS24208:
--   bouchra.elbarji@stud.hs-hannover.de
--
-- Gruppe 09 – BIS24209:
--   joyce-mirella.kuetche-dongue@stud.hs-hannover.de
--   fotso-tuedom.solaine-christy@stud.hs-hannover.de
--
-- Gruppe 10: (leer)
--
-- Ohne Gruppe (werden trotzdem als User angelegt):
--   mohamed.abduljalil@stud.hs-hannover.de
--   ary.farag@stud.hs-hannover.de
--   selim.franz@stud.hs-hannover.de
--   sayed-mahdi.hashemi@stud.hs-hannover.de
--   baran.kilic@stud.hs-hannover.de
--   meriem.othmani@stud.hs-hannover.de
--   daniel.pessler@stud.hs-hannover.de
--   ramneet.singh@stud.hs-hannover.de
--   tim-benjamin.suether@stud.hs-hannover.de

-- ────────────────────────────────────────────────────────────
-- 2. KATALOGE FÜR JEDE GRUPPE ANLEGEN
-- ────────────────────────────────────────────────────────────
-- Jede Gruppe arbeitet in ihrem eigenen Catalog. Die Studierenden
-- setzen in ihrer profiles.yml:
--   catalog: bis242_XX
--
-- Der Dozenten-Catalog bis242_00 wird hier NICHT angefasst.

CREATE CATALOG IF NOT EXISTS bis242_01 COMMENT 'BIS242 WS26 – Gruppe 01';
CREATE CATALOG IF NOT EXISTS bis242_02 COMMENT 'BIS242 WS26 – Gruppe 02';
CREATE CATALOG IF NOT EXISTS bis242_03 COMMENT 'BIS242 WS26 – Gruppe 03';
CREATE CATALOG IF NOT EXISTS bis242_04 COMMENT 'BIS242 WS26 – Gruppe 04';
CREATE CATALOG IF NOT EXISTS bis242_05 COMMENT 'BIS242 WS26 – Gruppe 05';
CREATE CATALOG IF NOT EXISTS bis242_06 COMMENT 'BIS242 WS26 – Gruppe 06';
CREATE CATALOG IF NOT EXISTS bis242_07 COMMENT 'BIS242 WS26 – Gruppe 07';
CREATE CATALOG IF NOT EXISTS bis242_08 COMMENT 'BIS242 WS26 – Gruppe 08';
CREATE CATALOG IF NOT EXISTS bis242_09 COMMENT 'BIS242 WS26 – Gruppe 09';
CREATE CATALOG IF NOT EXISTS bis242_10 COMMENT 'BIS242 WS26 – Gruppe 10';

-- ────────────────────────────────────────────────────────────
-- 3. BERECHTIGUNGEN JE GRUPPENMITGLIED VERGEBEN
-- ────────────────────────────────────────────────────────────
-- Siehe Einschränkung oben: Grants gehen an einzelne User-E-Mails,
-- nicht an die SCIM-Gruppen.

GRANT ALL PRIVILEGES ON CATALOG bis242_02 TO `jonathan.jacob@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_02 TO `ethan.menzel@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_02 TO `bogdan.mosmann@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_03 TO `daniel.engel@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_04 TO `mohammad-javad.nuri@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_04 TO `aleksandr.trifonov@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_05 TO `umar.ruslanovic-humasev@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_06 TO `ky-duyen.doan@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_06 TO `bettina.habenicht@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_07 TO `tobias.kraemer@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_07 TO `fynn.nehmer@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_08 TO `bouchra.elbarji@stud.hs-hannover.de`;

GRANT ALL PRIVILEGES ON CATALOG bis242_09 TO `joyce-mirella.kuetche-dongue@stud.hs-hannover.de`;
GRANT ALL PRIVILEGES ON CATALOG bis242_09 TO `fotso-tuedom.solaine-christy@stud.hs-hannover.de`;

-- Gruppe 01 und 10 sind aktuell leer – keine Grants nötig.

-- ────────────────────────────────────────────────────────────
-- 4. KONTROLLE
-- ────────────────────────────────────────────────────────────

SHOW CATALOGS LIKE 'bis242_*';
SHOW GRANTS ON CATALOG bis242_02;

-- ────────────────────────────────────────────────────────────
-- 5. AUFRÄUMEN (bei Semesterende ausführen)
-- ────────────────────────────────────────────────────────────
-- Achtung: Löscht alle Daten unwiderruflich!
--
-- DROP CATALOG IF EXISTS bis242_01 CASCADE;
-- DROP CATALOG IF EXISTS bis242_02 CASCADE;
-- DROP CATALOG IF EXISTS bis242_03 CASCADE;
-- DROP CATALOG IF EXISTS bis242_04 CASCADE;
-- DROP CATALOG IF EXISTS bis242_05 CASCADE;
-- DROP CATALOG IF EXISTS bis242_06 CASCADE;
-- DROP CATALOG IF EXISTS bis242_07 CASCADE;
-- DROP CATALOG IF EXISTS bis242_08 CASCADE;
-- DROP CATALOG IF EXISTS bis242_09 CASCADE;
-- DROP CATALOG IF EXISTS bis242_10 CASCADE;

