-- ============================================================
-- Databricks Community Edition – Workspace-Setup BIS242 SS26
-- ============================================================
-- Dieses Skript legt die Datenbanken (Schemas) für alle
-- Gruppen im Sommersemester 2026 an.
--
-- Zielumgebung: Databricks Community Edition (Free Workspace)
--               → kein Unity Catalog, kein SQL-basiertes
--                 User-/Gruppenmanagement
--
-- Ausführung: Als Workspace-Admin in einem Databricks Notebook
--             ausführen (eine Zelle pro Abschnitt).
--
-- Datenbank-Namenskonvention:  bis242_XX  (XX = Gruppennummer)
-- Dozenten-Datenbank:          bis242_00  (bleibt unverändert)
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. USER EINLADEN (manuell über die Workspace-UI)
-- ────────────────────────────────────────────────────────────
-- Im Free Workspace können User NICHT per SQL angelegt werden.
-- Stattdessen: Settings → Admin Settings → Users → Invite User
--
-- Gruppe 01:
--   selman.dogtas@stud.hs-hannover.de
--   aaron.koch@stud.hs-hannover.de
--   rida.noureddine@stud.hs-hannover.de
--
-- Gruppe 02:
--   swastika.bhusal@stud.hs-hannover.de
--   walaa.darwish@stud.hs-hannover.de
--   katrin-omar.mohammad@stud.hs-hannover.de
--
-- Gruppe 03: (leer)
--
-- Gruppe 04:
--   sebastian.brand@stud.hs-hannover.de
--   jan-henrik.weinhold@stud.hs-hannover.de
--
-- Gruppe 05:
--   daniel.keller@stud.hs-hannover.de
--   wendenburg.ludwig@stud.hs-hannover.de
--
-- Gruppe 06:
--   ayfer.celik@stud.hs-hannover.de
--   hai-anh.nguyen@stud.hs-hannover.de
--   finn-niklas.wermter@stud.hs-hannover.de
--
-- Gruppe 07:
--   ivan.chinskyi@stud.hs-hannover.de
--   vladyslav.velychko@stud.hs-hannover.de
--
-- Gruppe 08: (leer)
-- Gruppe 09: (leer)
-- Gruppe 10: (leer)
--
-- Ohne Gruppe:
--   andres-gabriel.castro-gonzales@stud.hs-hannover.de

-- ────────────────────────────────────────────────────────────
-- 2. DATENBANKEN (SCHEMAS) FÜR JEDE GRUPPE ANLEGEN
-- ────────────────────────────────────────────────────────────
-- Im Community Edition liegen alle Datenbanken im
-- hive_metastore. Jede Gruppe arbeitet in ihrer eigenen
-- Datenbank. Die Studierenden setzen in ihrer profiles.yml:
--   database: bis242_XX
--
-- Die Dozenten-Datenbank bis242_00 wird hier NICHT angefasst.

CREATE DATABASE IF NOT EXISTS bis242_01 COMMENT 'BIS242 SS26 – Gruppe 01';
CREATE DATABASE IF NOT EXISTS bis242_02 COMMENT 'BIS242 SS26 – Gruppe 02';
CREATE DATABASE IF NOT EXISTS bis242_03 COMMENT 'BIS242 SS26 – Gruppe 03';
CREATE DATABASE IF NOT EXISTS bis242_04 COMMENT 'BIS242 SS26 – Gruppe 04';
CREATE DATABASE IF NOT EXISTS bis242_05 COMMENT 'BIS242 SS26 – Gruppe 05';
CREATE DATABASE IF NOT EXISTS bis242_06 COMMENT 'BIS242 SS26 – Gruppe 06';
CREATE DATABASE IF NOT EXISTS bis242_07 COMMENT 'BIS242 SS26 – Gruppe 07';
CREATE DATABASE IF NOT EXISTS bis242_08 COMMENT 'BIS242 SS26 – Gruppe 08';
CREATE DATABASE IF NOT EXISTS bis242_09 COMMENT 'BIS242 SS26 – Gruppe 09';
CREATE DATABASE IF NOT EXISTS bis242_10 COMMENT 'BIS242 SS26 – Gruppe 10';

-- ────────────────────────────────────────────────────────────
-- 3. KONTROLLE
-- ────────────────────────────────────────────────────────────

SHOW DATABASES LIKE 'bis242_*';

-- ────────────────────────────────────────────────────────────
-- 4. AUFRÄUMEN (bei Semesterende ausführen)
-- ────────────────────────────────────────────────────────────
-- Achtung: Löscht alle Daten unwiderruflich!
--
-- DROP DATABASE IF EXISTS bis242_01 CASCADE;
-- DROP DATABASE IF EXISTS bis242_02 CASCADE;
-- DROP DATABASE IF EXISTS bis242_03 CASCADE;
-- DROP DATABASE IF EXISTS bis242_04 CASCADE;
-- DROP DATABASE IF EXISTS bis242_05 CASCADE;
-- DROP DATABASE IF EXISTS bis242_06 CASCADE;
-- DROP DATABASE IF EXISTS bis242_07 CASCADE;
-- DROP DATABASE IF EXISTS bis242_08 CASCADE;
-- DROP DATABASE IF EXISTS bis242_09 CASCADE;
-- DROP DATABASE IF EXISTS bis242_10 CASCADE;
