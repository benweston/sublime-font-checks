<a href="https://github.com/benweston/sublime-font-checks">
    <img
        src="/assets/banners/main-banner.png"
        alt="Ben Weston - Cloud & Software Engineering"
        width="1100"
        height="150"
        loading="lazy"
    />
</a>

# Sublime Font Checks

<div align="justify">

> **A visual testbed and typography sandbox for evaluating monospace font rendering, glyph legibility, operator ligatures, and syntax colour schemes in [Sublime Text](https://www.sublimetext.com/).**   

</div>

## 🎯 Overview & Purpose

<div align="justify">

Selecting a monospace coding font and colour scheme is often treated as a matter of brief aesthetic impression. However, everyday software engineering demands hours of dense reading where subtle typographic flaws cause cognitive friction:   
- Easily confusable characters (`0` vs `O`, `1` vs `l` vs `I`, `;` vs `:`, `` ` `` vs `'` vs `"`) lead to undetected syntax bugs.   
- Poorly spaced or oversized operator ligatures (`!=`, `===`, `=>`, `->`, `:=`) can obscure mathematical and structural intent.   
- Inconsistent colour scheme scopes cause identifiers, keywords, types, and strings to bleed together or wash out against dark, light, or OLED backgrounds.   
- Indentation guides, block scalars, heredocs, and regex syntax frequently trigger edge-case rendering issues in editor grammars.   

**`sublime-font-checks`** provides a curated, production-grade test suite of code files across multiple programming languages, infrastructure configurations, and markup formats. Each sample file is intentionally engineered to stress-test typography, OpenType font features, and syntax highlighting scopes directly within Sublime Text.   

</div>

## 📁 Repository Test Suite

<div align="justify">

The repository contains six specialised sample files and a ready-to-open Sublime Text project:   

| File | Language / Ecosystem | Typography & Highlight Highlights |
| :--- | :--- | :--- |
| [`sample.sh`](sample.sh) | **Bash / Shell Script** | Shebang, parameter expansions (`${var//a/b}`, `${var:-default}`), ANSI 256-colour escape sequences, regex matching (`=~`), subshells, arithmetic expansions, traps/signals, and an extensive **Visual Disambiguation & Ligature Matrix**. |
| [`sample.py`](sample.py) | **Python 3.12+** | PEP 695 type parameter syntax, structural pattern matching (`match`/`case`), `@dataclass(slots=True)`, async generators and context managers, walrus operator (`:=`), matrix multiplication operator (`@`), multi-line f-strings with complex formatting expressions. |
| [`sample.go`](sample.go) | **Go (Golang)** | Generics with type constraints (`any`, `comparable`), nested struct tags (`json:"..." db:"..."`), `iota` bitmask enums, concurrency primitives (`chan`, `select`, `go`), pointer receivers, bit-clear operator (`&^`), numeric literals in hex/octal/binary/imaginary notations. |
| [`sample.tf`](sample.tf) | **Terraform (HCL)** | Provider, resource, and module blocks; dynamic blocks; splat operators (`[*]`); complex type constraints; ternary conditionals; `for` comprehensions; built-in functions; heredoc templates with embedded `${...}` and `%{...}` interpolations. |
| [`sample-k8s.yaml`](sample-k8s.yaml) | **Kubernetes YAML** | Multi-document manifests separated by `---`, YAML anchors (`&ref`) and aliases (`*ref`), literal/folded block scalars (`\|`, `\|-`, `>`), secrets, deep multi-level indentation stress-testing editor indentation guides. |
| [`sample.Dockerfile`](sample.Dockerfile) | **Dockerfile (BuildKit)** | Multi-stage build architecture, `# syntax` parser directives, BuildKit cache and secret mounts (`--mount=type=cache`), execution heredocs (`RUN <<-EOF`), OCI metadata labels, healthcheck commands, multi-architecture build arguments. |
| [`sublime-font-checks.sublime-project`](sublime-font-checks.sublime-project) | **Sublime Text Project** | Root project configuration for opening the workspace in Sublime Text with one click or command. |

</div>

## 🚀 Quick Start

### 1. Clone the Repository

<div align="justify">

```bash
git clone https://github.com/benweston/sublime-font-checks.git
cd sublime-font-checks
```

</div>

### 2. Open in Sublime Text

<div align="justify">

Launch Sublime Text directly with the project file:   
```bash
subl sublime-font-checks.sublime-project
```
*Or open Sublime Text and use **Project** > **Open Project...** to select `sublime-font-checks.sublime-project`.*   

</div>

### 3. Open Multiple Tabs or Split View

<div align="justify">

Open several files side-by-side using Sublime Text's layout features:   
- **Menu**: `View` > `Layout` > `Columns: 2` (or `Columns: 3`)   
- **Keybinding**: <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd> (Linux/Windows) or <kbd>Super</kbd> + <kbd>Option</kbd> + <kbd>2</kbd> (macOS)   

Place [`sample.sh`](sample.sh) or [`sample.py`](sample.py) alongside [`sample.go`](sample.go) and [`sample-k8s.yaml`](sample-k8s.yaml) to evaluate rendering across diverse syntaxes simultaneously.   

</div>

## 🔬 What to Evaluate

### 1. Glyph Disambiguation & Punctuation Clarity

<div align="justify">

Examine the dedicated visual matrices in [`sample.sh`](sample.sh#L236-L253) and [`sample.py`](sample.py#L216-L220):   

- **Zero vs. Letters**: `0` vs `O` vs `o` vs `Q` vs `D` vs `θ` (Is the zero slashed, dotted, or clearly distinct?).   
- **Digit One vs. Letters & Bars**: `1` vs `l` (lowercase L) vs `I` (uppercase i) vs `|` (pipe) vs `!` (exclamation mark) vs `i` vs `j`.   
- **Sub-string Lookalikes**: `rn` vs `m`, `cl` vs `d`, `vv` vs `w`, `fl` vs `fi`.   
- **Punctuation Pairs**:   
  - Colon `:` vs Semicolon `;` (crucial in C, Go, Python, and JavaScript).   
  - Quotes: Backtick `` ` `` vs Single Quote `'` vs Double Quote `"`.   
  - Commas and Full Stops: `,` vs `.` at sizes 10pt–13pt.   
  - Hyphen `-` vs Underscore `_` vs En-dash `–` vs Em-dash `—`.   
- **Brackets and Enclosures**: Nested `(parentheses)`, `[brackets]`, `{braces}`, `<angle brackets>`.   

</div>

### 2. Operator Ligatures

<div align="justify">

Observe how your font renders operator sequences across code blocks:   

| Category | Operators to Check |
| :--- | :--- |
| **Equality & Identity** | `==`, `===`, `!=`, `!==`, `~=`, `=~` |
| **Comparisons** | `<=`, `>=`, `<`, `>`, `<=>`, `<<`, `>>`, `<<<`, `>>>` |
| **Pointers & Arrows** | `->`, `<-`, `-->`, `<--`, `=>`, `==>`, `<->`, `<=>`, `~>` |
| **Assignment & Types** | `:=`, `::`, `+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=` |
| **Logical & Bitwise** | `&&`, `\|\|`, `??`, `?.`, `!!`, `&^` (Go AND NOT), `\|>` (pipeline) |
| **Comments & Markup** | `/*`, `*/`, `/**`, `///`, `<!--`, `-->`, `###` |
| **Ranges & Dots** | `..`, `...`, `..<`, `..=`, `::=` |

> [!TIP]   
> Some ligatures can reduce readability for certain developers (for instance, rendering `!=` as `≠` or `===` as three merged bars). Use the configuration guide below to selectively disable ligatures or contextual alternates if desired.   

</div>

### 3. Syntax Highlighting Scopes & Contrast

<div align="justify">

Evaluate how your current colour scheme handles fine-grained scopes:   

- **Keywords vs. Built-ins**: Are language keywords (`def`, `func`, `select`, `match`, `terraform`) clearly distinguishable from standard library functions and built-in types?   
- **Comments & Annotations**: Are comments legible or overly dimmed? Do annotations (`TODO`, `FIXME`, `NOTE`, `WARN`, `BUG`) stand out with punchy contrast?   
- **String Literals & Escapes**: Can you easily spot escape codes (`\n`, `\t`, `\e[0m`, `\x00`), interpolation tokens (`${var}`), and regex expressions?   
- **Indentation & Alignment Guides**: Do the deep indentation trees in [`sample-k8s.yaml`](sample-k8s.yaml) line up cleanly with your font's character grid?   
- **Numeric Literals**: Are hex prefixes (`0x`), binary prefixes (`0b`), octal prefixes (`0o`), and numeric separators (`1_000_000`) styled consistently?   

</div>

## ⚙️ Sublime Text Configuration Guide

<div align="justify">

Adjust your font and rendering parameters in `Preferences.sublime-settings` (**Preferences** > **Settings...**).   

</div>

### Recommended Base Configuration

<div align="justify">

```json
{
  // Primary Monospace Font Face
  "font_face": "JetBrains Mono",

  // Font Size (test from 10 to 16)
  "font_size": 13,

  // Font Rendering Options & OpenType Features
  "font_options": [
    "subpixel_antialias"
    // "no_liga",              // Disable standard ligatures
    // "no_calt",              // Disable contextual alternates
    // "dlig",                 // Enable discretionary ligatures (font-dependent)
    // "ss01", "ss02", "cv01"  // OpenType Stylistic Sets & Character Variants
  ],

  // Line Height and Caret Padding (tuning vertical rhythm)
  "line_padding_top": 2,
  "line_padding_bottom": 2,
  "caret_extra_top": 1,
  "caret_extra_bottom": 1,

  // Indentation Guides & White Space
  "indent_guide_options": ["draw_normal", "draw_active"],
  "draw_white_space": ["selection"],
  "match_brackets": true,
  "match_brackets_angle": true
}
```

</div>

### Enabling OpenType Font Features (Stylistic Sets & Variants)

<div align="justify">

Modern monospace fonts often feature configurable OpenType alternates (e.g. slashed zeros, cursive italics, alternative asterisks, or tailored ampersands). You can pass stylistic sets (`ss01`–`ss20`) or character variants (`cv01`–`cv99`) directly into `"font_options"`:   

```json
{
  "font_options": [
    "subpixel_antialias",
    "cv01", // e.g. JetBrains Mono alternate zero
    "cv08", // e.g. alternate lowercase l
    "ss02"  // e.g. Fira Code alternate ampersand
  ]
}
```

</div>

### Inspecting Syntax Scopes

<div align="justify">

To inspect the precise syntax scope assigned to any token under your cursor:   

| Platform | Shortcut |
| :--- | :--- |
| **Linux & Windows** | <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> |
| **macOS** | <kbd>Super</kbd> + <kbd>Option</kbd> + <kbd>P</kbd> |
| **Command Palette** | `Ctrl/Cmd + Shift + P` &rarr; `Developer: Show Scope Name` |

This displays the full selector chain (e.g., `source.go entity.name.function.go`, `source.python meta.function.parameters`, `source.terraform storage.type.hcl`), making it easy to identify scope gaps or write custom overrides in `.sublime-color-scheme` files.   

</div>

## 🎨 Recommended Fonts & Colour Schemes to Compare

### Popular Monospace Coding Fonts to Test

<div align="justify">

- **JetBrains Mono**: Clean, tall x-height, extensive coding ligatures and stylistic sets.   
- **Berkeley Mono**: Crafted, artisanal grid alignment and high-contrast punctuation.   
- **Fira Code**: The classic ligature-rich programming font with numerous stylistic sets.   
- **Cascadia Code**: Microsoft's modern coding font with cursive italics and box-drawing precision.   
- **Iosevka**: Highly customisable, compact proportions ideal for split-screen layouts.   
- **Monaspace** (GitHub): Five distinct styles (Argon, Neon, Xenon, Radon, Krypton) with Texture Healing.   
- **Intel One Mono**: Engineered specifically for maximum legibility and reduced eye strain.   
- **Victor Mono**: Distinctive cursive italics paired with crisp monospace characters.   
- **Hack**: Workhorse open-source font based on DejaVu Sans Mono / Bitstream Vera.   
- **Source Code Pro**: Classic Adobe typography with exceptional horizontal rhythm.   

</div>

### Colour Schemes to Compare

<div align="justify">

- **Default Schemes**: Mariana, Monokai, Breakers, Celeste.   
- **Community Schemes**: Monokai Pro, Catppuccin (Mocha/Macchiato/Frappé/Latte), One Dark Pro, Gruvbox, Tokyo Night, Nord, Solarized Dark/Light, Dracula, Ayu (Dark/Mirage/Light).   

</div>

## 📄 Licence

<div align="justify">

The `sublime-font-checks` repository is open source and provided under the [MIT Licence](https://github.com/benweston/sublime-font-checks/blob/main/LICENSE).   
Banner image taken from photo by [Andrey Soldatov](https://unsplash.com/@andrilliardbond) on [Unsplash](https://unsplash.com/photos/abstract-glowing-crosses-against-dark-background-_uAlo5JK6Yc) via the [Unsplash License](https://unsplash.com/license).   

</div>
