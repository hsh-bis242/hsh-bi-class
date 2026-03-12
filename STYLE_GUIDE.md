# BIS242 – Slide Style Guide

Dieses Dokument beschreibt die Design-Konventionen und CSS-Klassen für die Übungsfolien (U01–U08) im reveal.js-Format.

## Grundlagen

- **Framework:** reveal.js mit HSH-Theme (`dist/theme/hsh.css`)
- **Custom Styles:** `custom.css` (muss in jeder HTML-Datei eingebunden werden)
- **Sprache:** HTML-Attribut `lang="en"`, Inhalte auf Deutsch
- **Schrift:** Source Sans Pro (via HSH-Theme)
- **Primärfarbe:** `#dc3c05` (HSH-Orange)

### HTML-Boilerplate

```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>BIS242 – Übung XX – Titel</title>

    <link rel="stylesheet" href="dist/reset.css">
    <link rel="stylesheet" href="dist/reveal.css">
    <link rel="stylesheet" href="dist/theme/hsh.css">
    <link rel="stylesheet" href="custom.css">
    <link rel="stylesheet" href="plugin/highlight/monokai.css">
    <link rel="icon" type="image/png" sizes="96x96" href="static/favicon-96x96.png">
</head>
<body>
    <div class="reveal">
        <div class="slides">
            <!-- Folieninhalte -->
        </div>
    </div>

    <script src="dist/reveal.js"></script>
    <script src="plugin/notes/notes.js"></script>
    <script src="plugin/markdown/markdown.js"></script>
    <script src="plugin/highlight/highlight.js"></script>
    <script>
        Reveal.initialize({
            hash: true,
            plugins: [RevealMarkdown, RevealHighlight, RevealNotes]
        });
    </script>
</body>
</html>
```

---

## Folienstruktur

### Slide-Navigation

reveal.js nutzt verschachtelte `<section>`-Elemente:

- **Horizontal:** Jede Top-Level `<section>` ist eine horizontale Folie (← →)
- **Vertikal:** Verschachtelte `<section>` innerhalb einer äußeren `<section>` erzeugen einen vertikalen Stapel (↑ ↓)

```html
<!-- Horizontale Folie (standalone) -->
<section>
    <h1>Einzelfolie</h1>
</section>

<!-- Vertikaler Stapel -->
<section>
    <section>Folie 1 (↓)</section>
    <section>Folie 2 (↓)</section>
    <section>Folie 3</section>
</section>
```

### Typische Folienreihenfolge

1. **Title Slide** – Titelfolie der Übung
2. **Ziele** – Lernziele als nummerierte Schritte
3. **Themenabschnitte** – Jeweils mit Section-Divider + Inhaltsfolien als vertikaler Stapel
4. **Result Slide** – Ergebniszusammenfassung mit Prüfhinweis

---

## CSS-Klassen

### Title Slide

```html
<section class="title-slide">
    <h1>Übung Business Intelligence</h1>
    <h2>Titel der Übung</h2>
    <p class="subtitle">Übung XX · BIS242</p>
</section>
```

- Zentrierter Text
- `h2` in HSH-Orange, ohne Großschreibung
- `.subtitle` in Grau, kleiner

### Section Divider

Leitet einen neuen Themenabschnitt ein. Immer als **erste vertikale Folie** im Stapel:

```html
<section>
    <section class="section-divider">
        <h1>Abschnittstitel</h1>
        <h2>Untertitel</h2>
    </section>
    <section>
        <!-- Erste Inhaltsfolie -->
    </section>
</section>
```

- Zentrierter Text
- `h2` in Grau, leichtere Schrift
- **Nicht** als eigenständige horizontale Folie verwenden!

### Result Slide

Letzte Folie jeder Übung mit Ergebnis-Checkliste:

```html
<section class="result-slide">
    <h1>Ergebnis der Übung</h1>
    <ul>
        <li>✅ Aufgabe 1 erledigt</li>
        <li>✅ Aufgabe 2 erledigt</li>
    </ul>
    <div class="pruefbar">
        <b>Prüfbar durch Dozenten:</b> Beschreibung, wo/wie geprüft wird.
    </div>
</section>
```

- Grauer Hintergrund
- `h1` in Grün
- Liste ohne Standard-Listenpunkte (Emojis stattdessen)
- `.pruefbar`-Box mit blauem linken Rand

---

### Callout Boxes

Hervorgehobene Infoboxen mit farbigem linken Rand:

```html
<div class="callout">Standard (orange)</div>
<div class="callout callout-blue">Info / Links</div>
<div class="callout callout-green">Erfolg</div>
<div class="callout callout-yellow">Hinweis / Warnung</div>
<div class="callout callout-gray">Neutral</div>
```

Callouts können optional einen `<h4>`-Titel enthalten:

```html
<div class="callout callout-yellow">
    <h4>Hinweis</h4>
    <p>Beschreibungstext</p>
</div>
```

### Task Box

Aufgabenstellung mit orangem Akzent:

```html
<div class="task-box">
    <h4>Aufgabe</h4>
    <p>Aufgabenbeschreibung</p>
</div>
```

- Grauer Hintergrund, grauer Rand, oranger linker Rand
- `h4` in Orange

### Hint / Warning

Kompakte Inline-Hinweise:

```html
<div class="hint">
    <b>Tipp:</b> Hilfreicher Hinweis
</div>

<div class="warning">
    <b>⚠️ Wichtig:</b> Warnhinweis
</div>
```

- `.hint`: gelber Hintergrund, gelber Rand
- `.warning`: roter Hintergrund, oranger Rand

---

### Step List

Nummerierte Schritte mit orangem Kreis-Zähler:

```html
<ol class="steps">
    <li>Erster Schritt</li>
    <li>Zweiter Schritt</li>
    <li>Dritter Schritt</li>
</ol>
```

- Automatische Nummerierung mit CSS-Counter
- Oranges Kreis-Badge vor jeder Nummer

### Grid Layouts

```html
<div class="grid-2">   <!-- 2 gleiche Spalten -->
<div class="grid-3">   <!-- 3 gleiche Spalten -->
<div class="grid-2-1"> <!-- 2:1 Verhältnis -->
<div class="grid-1-2"> <!-- 1:2 Verhältnis -->
```

Typische Verwendung: Text links, Bild rechts:

```html
<div class="grid-2">
    <div>
        <p>Beschreibungstext</p>
    </div>
    <div class="text-center">
        <img data-src="static/UXX/bild.png" height="300">
    </div>
</div>
```

### Info Card

Kompakte Kennzahlen-Karten (gut mit `grid-3`):

```html
<div class="grid-3">
    <div class="info-card">
        <p class="number">7</p>
        <p>Seeds</p>
    </div>
    <div class="info-card">
        <p class="number">6</p>
        <p>PSA-Views</p>
    </div>
    <div class="info-card">
        <p class="number">19</p>
        <p>DV-Modelle</p>
    </div>
</div>
```

### OS Tabs

Nebeneinander dargestellte Tabs für verschiedene Betriebssysteme:

```html
<div class="os-tabs">
    <div class="os-tab">
        <h4>🪟 Windows (PowerShell)</h4>
        <pre><code class="language-powershell" data-trim>
Befehl für Windows
        </code></pre>
    </div>
    <div class="os-tab">
        <h4>🍎 macOS / Linux</h4>
        <pre><code class="language-bash" data-trim>
Befehl für macOS
        </code></pre>
    </div>
</div>
```

---

### Utility-Klassen

| Klasse | Wirkung |
|---|---|
| `.text-small` | Kleinere Schrift (0.75em) |
| `.text-muted` | Graue Schriftfarbe |
| `.text-center` | Zentrierter Text (überschreibt links-Ausrichtung) |
| `.mt-0`, `.mb-0` | Kein Margin oben/unten |
| `.mt-1`, `.mb-1` | 10px Margin oben/unten |

---

## CSS-Variablen

In `custom.css` definierte Variablen:

| Variable | Wert | Verwendung |
|---|---|---|
| `--hsh-orange` | `#dc3c05` | Primärfarbe, Akzente |
| `--hsh-orange-light` | `#fff3ef` | Callout-Hintergrund |
| `--hsh-dark` | `#2c2c2c` | Dunkle Texte |
| `--hsh-gray` | `#5a5a5a` | Sekundärtext |
| `--hsh-gray-light` | `#f5f5f5` | Hintergründe |
| `--hsh-gray-border` | `#ddd` | Ränder |
| `--hsh-blue` | `#2e6da4` | Info-Callouts, Prüfbar-Box |
| `--hsh-blue-light` | `#eef4fa` | Info-Hintergrund |
| `--hsh-green` | `#3a7d44` | Erfolg, Result-Slide |
| `--hsh-green-light` | `#eef8ef` | Erfolg-Hintergrund |
| `--hsh-yellow` | `#b8860b` | Hinweise, Hints |
| `--hsh-yellow-light` | `#fef9ec` | Hint-Hintergrund |

---

## Konventionen

### Bilder

- Assets unter `static/UXX/` ablegen (z. B. `static/U01/logo-github.png`)
- Lazy Loading mit `data-src` statt `src` (reveal.js-Konvention)
- Höhe über `height`-Attribut begrenzen, nicht `width`

### Code-Blöcke

```html
<pre><code class="language-sql" data-trim>
SELECT * FROM table;
</code></pre>
```

- `data-trim` entfernt führende/abschließende Leerzeichen
- Sprache über `class="language-xxx"` setzen (sql, bash, yaml, powershell, python)
- Inline-Code: `<code>name</code>` (automatisch grau hinterlegt)

### Keine fertigen Lösungen

In den Übungsfolien werden **keine vollständigen SQL-Lösungen** gezeigt. Stattdessen:
- `???`-Platzhalter für zu ergänzende Teile
- Hinweise auf relevante Tabellen, Spalten und Syntax
- Fertige Lösungen liegen in `loesungen/` (nur für Dozenten)

### Abschnittskommentare

Jeder Themenabschnitt wird mit einem HTML-Kommentar eingeleitet:

```html
<!-- ==================== ABSCHNITTSNAME ==================== -->
```

### Indentation

- Tabs (nicht Leerzeichen)
- 3 Tabs für Top-Level `<section>` (innerhalb `.slides`)
- +1 Tab pro Verschachtelungsebene
