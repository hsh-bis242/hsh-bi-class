# BIS 242 – Business Intelligence (Hochschule Hannover)
## Klausur (Multiple Choice)

**Studiengang/Modul:** BIS 242 – Business Intelligence  
**Prüfungsform:** Multiple Choice (Single Choice + Multiple Response)  
**Bearbeitungszeit:** 90 Minuten  
**Hilfsmittel:** keine (sofern nicht anders angekündigt)  

---

## Hinweise zur Bearbeitung
- **Single Choice (SC):** Genau **eine** Antwort ist korrekt.
- **Multiple Response (MR):** **Eine oder mehrere** Antworten sind korrekt.
- Kreuzen Sie pro Aufgabe die zutreffenden Antworten an.
- Es gibt **keine Negativpunkte** (sofern nicht anders angekündigt).

## Bewertungsvorschlag
- **35 Aufgaben × 1 Punkt = 35 Punkte**
- **30 Punkte** = 1,0 (sehr gut)
- **27 Punkte** = 2,0 (gut)
- **24 Punkte** = 3,0 (befriedigend)
- **21 Punkte** = 4,0 (ausreichend)

(Dozierende können die Grenzen je Kohorte anpassen.)

---

# Aufgaben

### 1) (SC) Reporting – Zielsetzung
Was beschreibt das **Ziel** des betrieblichen Berichtswesens (Reporting) am treffendsten?
- A. Ein System zur Echtzeitsteuerung von Maschinen in der Fertigung
- B. Mitarbeiter ereignis- oder zeitgesteuert mit relevanten Informationen versorgen
- C. Eine Methode zur Datenverschlüsselung im Data Warehouse
- D. Ein Protokoll, um Datenbanken über Netzwerke zu replizieren

### 2) (SC) BI-Komponenten – Einordnung
Welche Aussage passt am besten zur **Einordnung** von Reporting im BI-Kontext?
- A. Reporting ist typischerweise Teil der Informationsbereitstellung an Fach- und Führungskräfte
- B. Reporting ist ein Synonym für OLTP
- C. Reporting ist ausschließlich ein Data-Mining-Verfahren
- D. Reporting ersetzt Datenmodellierung vollständig

### 3) (SC) Dashboards – Definition
Welche Aussage trifft die **Definition** eines Dashboards am besten?
- A. Ein Dashboard ist primär ein Backup-System für Datenbanken
- B. Ein Dashboard aggregiert Kennzahlen/Indikatoren und stellt sie zur schnellen Übersicht dar
- C. Ein Dashboard ist nur ein HTML-Export von Tabellen
- D. Ein Dashboard ist ausschließlich ein ETL-Tool

### 4) (SC) Dashboards – Klassifikation
Welche Dashboard-Kategorie ist typischerweise **hoch verdichtet**, mit **wenig Interaktion** und für **langfristige Ziele** gedacht?
- A. Operatives Dashboard
- B. Strategisches (Executive) Dashboard
- C. Taktisches Performance-Dashboard
- D. Debugging-Dashboard

### 5) (MR) Dashboards – Einsatz
Welche Aussagen passen typischerweise zu **operativen Dashboards**?
- A. Fokus auf Überwachung/Steuerung des Tagesgeschäfts
- B. Fokus auf langfristige Unternehmensziele
- C. Häufigere Aktualisierung als strategische Dashboards
- D. Ausschließlich für externe Stakeholder bestimmt

### 6) (SC) OLAP – Grundidee
Wofür steht OLAP im Kern?
- A. Für Transaktionsabwicklung mit maximaler Normalisierung
- B. Für interaktive, multidimensionale Analyse betriebswirtschaftlicher Kennzahlen
- C. Für reine Speicherung unstrukturierter Texte
- D. Für Netzwerk-Routing in Cloud-Plattformen

### 7) (SC) Fakten & Dimensionen
Welche Zuordnung ist korrekt?
- A. Dimension: Umsatz; Fakt: Kunde
- B. Dimension: Kunde; Fakt: Umsatz
- C. Dimension: Rabatt; Fakt: Region
- D. Dimension: Primärschlüssel; Fakt: Fremdschlüssel

### 8) (SC) OLAP-Navigation
Welche OLAP-Operation beschreibt das Wechseln von einer aggregierten Ebene (z. B. Jahr) zu einer feineren Ebene (z. B. Monat)?
- A. Roll-up
- B. Drill-down
- C. Pivot
- D. Materialize

### 9) (MR) OLAP – typische Operationen
Welche Begriffe gehören typischerweise zu OLAP-Navigationsoperationen?
- A. Slice
- B. Dice
- C. Roll-up
- D. Hash-Join

### 10) (SC) MOLAP vs. ROLAP
Welche Aussage trifft am ehesten zu?
- A. MOLAP speichert Daten typischerweise in relationalen Tabellen; ROLAP in multidimensionalen Cubes
- B. ROLAP nutzt typischerweise relationale Strukturen/SQL; MOLAP nutzt multidimensionale Speicherstrukturen
- C. MOLAP ist nur für unstrukturierte Daten geeignet
- D. ROLAP ist ein Versionsverwaltungssystem

### 11) (SC) Star Schema – Grundprinzip
Wodurch zeichnet sich ein Sternschema typischerweise aus?
- A. Es besteht aus einer Faktentabelle, die mit mehreren Dimensionstabellen verbunden ist
- B. Es besteht aus ausschließlich normalisierten Tabellen (3NF)
- C. Es nutzt ausschließlich Key-Value-Stores
- D. Es enthält nur eine einzige Tabelle

### 12) (SC) Faktentabelle – Grain
Was beschreibt der Begriff **Grain** (Granularität) einer Faktentabelle?
- A. Die Anzahl der Indizes in einer Tabelle
- B. Die fachliche Detailstufe, die eine Zeile der Faktentabelle repräsentiert
- C. Die Kompressionsrate des Storage
- D. Die Anzahl der Spalten in einer Dimension

### 13) (MR) Fakten – Additivität
Welche Aussagen zu Kennzahlen/Fakten sind korrekt?
- A. Additive Fakten können über alle Dimensionen hinweg sinnvoll summiert werden (z. B. Umsatz)
- B. Semi-additive Fakten sind über manche Dimensionen additiv, über andere nicht (z. B. Kontostand über Zeit)
- C. Nicht-additive Fakten sind immer ungeeignet für OLAP
- D. Additivität ist unabhängig von der Dimension „Zeit“

### 14) (SC) Slowly Changing Dimensions (SCD)
Was ist ein typischer Grund für Slowly Changing Dimensions?
- A. Dimensionen ändern sich fachlich (z. B. Kunde zieht um), Historie soll ggf. nachverfolgt werden
- B. Fakten ändern sich nie und müssen daher versioniert werden
- C. Primärschlüssel dürfen nicht gespeichert werden
- D. SCD betrifft nur Logdateien

### 15) (SC) Data Vault – Grundbausteine
Welche Objekte gehören klassisch zum Data Vault Modell?
- A. Hubs, Links, Satellites
- B. Cubes, Measures, Slices
- C. Views, Triggers, Stored Procedures
- D. Buckets, Streams, Topics

### 16) (SC) dbt – Modellkonzept
Was ist ein dbt-„Model“ typischerweise?
- A. Ein Python-Skript, das Daten aus APIs lädt
- B. Eine SQL-Select-Definition, die dbt materialisiert (z. B. als View oder Tabelle)
- C. Ein Docker-Image
- D. Ein Git-Branch

### 17) (SC) dbt – Materialisierung
Welche Materialisierung bedeutet in dbt typischerweise, dass ein Model als **persistente Tabelle** erzeugt wird?
- A. ephemeral
- B. table
- C. macro
- D. seed

### 18) (MR) dbt – Tests
Welche Aussagen zu dbt-Tests sind korrekt?
- A. Generic Tests (z. B. `not_null`, `unique`) werden häufig in YAML definiert
- B. Tests können im CI/CD laufen und Datenqualität absichern
- C. Tests ersetzen die fachliche Modellierung vollständig
- D. Tests sind ausschließlich UI-Tests

### 19) (SC) dbt – Macros
Wofür werden dbt-Macros typischerweise verwendet?
- A. Für wiederverwendbare SQL-/Jinja-Logik (Templating), z. B. zur Generierung ähnlicher Modelle
- B. Für das Ersetzen von Git
- C. Für das Verschlüsseln von Tabellen
- D. Für das Rendern von PowerPoint-Folien

### 20) (SC) dbt – compile
Wozu dient `dbt compile` am sinnvollsten?
- A. Es lädt Rohdaten aus externen Systemen
- B. Es generiert die „gerenderte“ SQL-Ausgabe (Jinja/Ref-Auflösung) ohne Ausführung
- C. Es löscht das Data Warehouse
- D. Es erstellt automatisch Git-Tags

### 21) (SC) Datenqualität – not_null
Was prüft ein `not_null`-Test typischerweise?
- A. Dass eine Spalte keine NULL-Werte enthält
- B. Dass eine Spalte nur Zahlen enthält
- C. Dass eine Tabelle nicht existiert
- D. Dass eine Spalte eindeutig ist

### 22) (SC) Self-Service BI
Welche Aussage beschreibt Self-Service BI am besten?
- A. Fachanwender können Analysen/Reports in gewissem Rahmen selbst erstellen, ohne ständig IT-Tickets
- B. Self-Service BI bedeutet, dass keine Governance nötig ist
- C. Self-Service BI ist nur für OLTP-Systeme geeignet
- D. Self-Service BI ist ein Cloud-Deployment-Modell

### 23) (MR) Big Data – Merkmale
Welche Merkmale werden häufig mit Big Data in Verbindung gebracht ("V's")?
- A. Volume
- B. Velocity
- C. Variety
- D. Volatility (als Standard-V in jeder Definition)

### 24) (SC) Big Data – Definition
Welche Definition passt am ehesten zu Big Data (vereinfacht)?
- A. Daten, die so klein sind, dass sie nur in CSV gespeichert werden
- B. Datenbestände, deren Größe/Komplexität typische DB-Werkzeuge an Grenzen bringt und neue Verarbeitung erfordert
- C. Nur Daten, die in Echtzeit entstehen
- D. Nur Bilder und Videos

### 25) (SC) Open Data
Was ist ein typisches Ziel von Open-Data-Initiativen im öffentlichen Sektor?
- A. Daten exklusiv nur intern verfügbar machen
- B. Staatliche Daten transparent und nachnutzbar bereitstellen
- C. OLAP-Cubes verpflichtend einführen
- D. Alle Daten nur in PDF veröffentlichen

### 26) (SC) Cloud – NIST Definition
Welche Aussage gehört zu den **essenziellen Charakteristika** von Cloud Computing (NIST)?
- A. On-demand self-service
- B. Manuelle Ticketpflicht für jede Ressource
- C. Physische Übergabe von Festplatten als Standard
- D. Keine Messbarkeit von Verbräuchen

### 27) (MR) Cloud – Charakteristika
Welche sind NIST-Charakteristika von Cloud Computing?
- A. Broad network access
- B. Resource pooling
- C. Rapid elasticity
- D. Measured service

### 28) (SC) Cloud – Service Modelle
Welche Zuordnung ist korrekt?
- A. IaaS: Fertige Anwendung, keine Kontrolle über OS
- B. SaaS: Fertige Anwendung wird als Service genutzt
- C. PaaS: Hardware wird „bare metal“ geliefert
- D. SaaS: Nur für private Clouds

### 29) (SC) Cloud – Deployment Modelle
Welche Aussage trifft zu?
- A. Public Cloud ist exklusiv für eine Organisation reserviert
- B. Private Cloud ist eine exklusive Infrastruktur für eine Organisation
- C. Hybrid Cloud bedeutet „nur On-Prem“
- D. Community Cloud ist nur für Privatpersonen

### 30) (SC) Infrastructure as Code (IaC)
Was ist ein zentraler Vorteil von Infrastructure as Code?
- A. Infrastruktur-Konfiguration ist versionierbar (z. B. in Git) und reproduzierbar
- B. Infrastruktur kann nur noch per GUI verändert werden
- C. IaC verhindert jede Art von Update
- D. IaC ist nur für OLAP-Systeme relevant

### 31) (SC) Microservices
Welche Aussage passt am besten zu Microservices?
- A. Eine große Anwendung als ein untrennbarer Monolith
- B. Viele kleine, autonome Services mit klaren Schnittstellen
- C. Ein einzelner SQL-Server mit vielen Tabellen
- D. Ein Format zum Speichern von Dimensionsdaten

### 32) (SC) Git – verteilt
Was bedeutet „verteiltes Versionsverwaltungssystem“ bei Git?
- A. Es gibt nur ein zentrales Repository ohne lokale Historie
- B. Jede Arbeitskopie enthält typischerweise die vollständige Repository-Historie
- C. Man kann nur online committen
- D. Branching ist nicht möglich

### 33) (SC) Git – Dateizustände
Welche Reihenfolge beschreibt den typischen Weg einer Änderung bis zum Commit?
- A. committed → staged → modified
- B. modified → staged → committed
- C. staged → modified → committed
- D. modified → committed → staged

### 34) (MR) Git – Aufgaben eines VCS
Welche Aufgaben gehören typischerweise zu Versionsverwaltungssystemen?
- A. Protokollieren, wer wann was geändert hat
- B. Wiederherstellen alter Stände (Rollback)
- C. Koordinieren paralleler Arbeit (z. B. Branches/Merges)
- D. Automatisches Verschlüsseln aller Dateien als Pflichtfunktion

### 35) (SC) Geointelligence – Anwendungsfälle
Welche Aufgabe ist ein typischer Geointelligence-Anwendungsfall?
- A. Berechnung von Distanzen und räumlichen Zusammenhängen
- B. Normalisierung von Tabellen auf 5NF
- C. Kompilieren von dbt-Macros in Bytecode
- D. Ersetzen von Git durch Datenbanken

---

# Antwortbogen (zum Ankreuzen)

Tragen Sie hier Ihre Antworten ein (Beispiel: „1B, 2A, 3B …“). Bei MR-Aufgaben mehrere Buchstaben.

- 1: ____   2: ____   3: ____   4: ____   5: ____
- 6: ____   7: ____   8: ____   9: ____   10: ____
- 11: ____  12: ____  13: ____  14: ____  15: ____
- 16: ____  17: ____  18: ____  19: ____  20: ____
- 21: ____  22: ____  23: ____  24: ____  25: ____
- 26: ____  27: ____  28: ____  29: ____  30: ____
- 31: ____  32: ____  33: ____  34: ____  35: ____
