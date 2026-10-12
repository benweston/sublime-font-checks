# sublime-font-checks

> **A visual testbed and typography sandbox for evaluating monospace font rendering, glyph legibility, operator ligatures, and syntax color schemes in [Sublime Text](https://www.sublimetext.com/).**

---

## 🎯 Overview & Purpose

Selecting a monospace coding font and color scheme is often treated as a matter of brief aesthetic impression. However, everyday software engineering demands hours of dense reading where subtle typographic flaws cause cognitive friction:
- Easily confusable characters (`0` vs `O`, `1` vs `l` vs `I`, `;` vs `:`, `` ` `` vs `'` vs `"`) lead to undetected syntax bugs.
- Poorly spaced or oversized operator ligatures (`!=`, `===`, `=>`, `->`, `:=`) can obscure mathematical and structural intent.
- Inconsistent color scheme scopes cause identifiers, keywords, types, and strings to bleed together or wash out against dark, light, or OLED backgrounds.
- Indentation guides, block scalars, heredocs, and regex syntax frequently trigger edge-case rendering issues in editor grammars.

**`sublime-font-checks`** provides a curated, production-grade test suite of code files across multiple programming languages, infrastructure configurations, and markup formats. Each sample file is intentionally engineered to stress-test typography, OpenType font features, and syntax highlighting scopes directly within Sublime Text.

---

## 📁 Repository Test Suite

The repository contains six specialized sample files and a ready-to-open Sublime Text project:

| File | Language / Ecosystem | Typography & Highlight Highlights |
| :--- | :--- | :--- |
| [`sample.sh`](sample.sh) | **Bash / Shell Script** | Shebang, parameter expansions (`${var//a/b}`, `${var:-default}`), ANSI 256-color escape sequences, regex matching (`=~`), subshells, arithmetic expansions, traps/signals, and an extensive **Visual Disambiguation & Ligature Matrix**. |
| [`sample.py`](sample.py) | **Python 3.12+** | PEP 695 type parameter syntax, structural pattern matching (`match`/`case`), `@dataclass(slots=True)`, async generators and context managers, walrus operator (`:=`), matrix multiplication operator (`@`), multi-line f-strings with complex formatting expressions. |
| [`sample.go`](sample.go) | **Go (Golang)** | Generics with type constraints (`any`, `comparable`), nested struct tags (`json:"..." db:"..."`), `iota` bitmask enums, concurrency primitives (`chan`, `select`, `go`), pointer receivers, bit-clear operator (`&^`), numeric literals in hex/octal/binary/imaginary notations. |
| [`sample.tf`](sample.tf) | **Terraform (HCL)** | Provider, resource, and module blocks; dynamic blocks; splat operators (`[*]`); complex type constraints; ternary conditionals; `for` comprehensions; built-in functions; heredoc templates with embedded `${...}` and `%{...}` interpolations. |
| [`sample-k8s.yaml`](sample-k8s.yaml) | **Kubernetes YAML** | Multi-document manifests separated by `---`, YAML anchors (`&ref`) and aliases (`*ref`), literal/folded block scalars (`\|`, `\|-`, `>`), secrets, deep multi-level indentation stress-testing editor indentation guides. |
| [`sample.Dockerfile`](sample.Dockerfile) | **Dockerfile (BuildKit)** | Multi-stage build architecture, `# syntax` parser directives, BuildKit cache and secret mounts (`--mount=type=cache`), execution heredocs (`RUN <<-EOF`), OCI metadata labels, healthcheck commands, multi-architecture build arguments. |
| [`sublime-font-checks.sublime-project`](sublime-font-checks.sublime-project) | **Sublime Text Project** | Root project configuration for opening the workspace in Sublime Text with one click or command. |

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/benweston/sublime-font-checks.git
cd sublime-font-checks
```

### 2. Open in Sublime Text
Launch Sublime Text directly with the project file:
```bash
subl sublime-font-checks.sublime-project
```
*Or open Sublime Text and use **Project** > **Open Project...** to select `sublime-font-checks.sublime-project`.*

### 3. Open Multiple Tabs or Split View
Open several files side-by-side using Sublime Text's layout features:
- **Menu**: `View` > `Layout` > `Columns: 2` (or `Columns: 3`)
- **Keybinding**: <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd> (Linux/Windows) or <kbd>Super</kbd> + <kbd>Option</kbd> + <kbd>2</kbd> (macOS)

Place [`sample.sh`](sample.sh) or [`sample.py`](sample.py) alongside [`sample.go`](sample.go) and [`sample-k8s.yaml`](sample-k8s.yaml) to evaluate rendering across diverse syntaxes simultaneously.

---

## 🔬 What to Evaluate

### 1. Glyph Disambiguation & Punctuation Clarity
Examine the dedicated visual matrices in [`sample.sh`](sample.sh#L236-L253) and [`sample.py`](sample.py#L216-L220):

- **Zero vs. Letters**: `0` vs `O` vs `o` vs `Q` vs `D` vs `θ` (Is the zero slashed, dotted, or clearly distinct?).
- **Digit One vs. Letters & Bars**: `1` vs `l` (lowercase L) vs `I` (uppercase i) vs `|` (pipe) vs `!` (exclamation mark) vs `i` vs `j`.
- **Sub-string Lookalikes**: `rn` vs `m`, `cl` vs `d`, `vv` vs `w`, `fl` vs `fi`.
- **Punctuation Pairs**:
  - Colon `:` vs Semicolon `;` (crucial in C, Go, Python, and JavaScript).
  - Quotes: Backtick `` ` `` vs Single Quote `'` vs Double Quote `"`.
  - Commas and Periods: `,` vs `.` at sizes 10pt–13pt.
  - Hyphen `-` vs Underscore `_` vs En-dash `–` vs Em-dash `—`.
- **Brackets and Enclosures**: Nested `(parentheses)`, `[brackets]`, `{braces}`, `<angle brackets>`.

### 2. Operator Ligatures
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

### 3. Syntax Highlighting Scopes & Contrast
Evaluate how your current color scheme handles fine-grained scopes:

- **Keywords vs. Built-ins**: Are language keywords (`def`, `func`, `select`, `match`, `terraform`) clearly distinguishable from standard library functions and built-in types?
- **Comments & Annotations**: Are comments legible or overly dimmed? Do annotations (`TODO`, `FIXME`, `NOTE`, `WARN`, `BUG`) stand out with punchy contrast?
- **String Literals & Escapes**: Can you easily spot escape codes (`\n`, `\t`, `\e[0m`, `\x00`), interpolation tokens (`${var}`), and regex expressions?
- **Indentation & Alignment Guides**: Do the deep indentation trees in [`sample-k8s.yaml`](sample-k8s.yaml) line up cleanly with your font's character grid?
- **Numeric Literals**: Are hex prefixes (`0x`), binary prefixes (`0b`), octal prefixes (`0o`), and numeric separators (`1_000_000`) styled consistently?

---

## ⚙️ Sublime Text Configuration Guide

Adjust your font and rendering parameters in `Preferences.sublime-settings` (**Preferences** > **Settings...**).

### Recommended Base Configuration

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

### Enabling OpenType Font Features (Stylistic Sets & Variants)
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

### Inspecting Syntax Scopes
To inspect the precise syntax scope assigned to any token under your cursor:

| Platform | Shortcut |
| :--- | :--- |
| **Linux & Windows** | <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> |
| **macOS** | <kbd>Super</kbd> + <kbd>Option</kbd> + <kbd>P</kbd> |
| **Command Palette** | `Ctrl/Cmd + Shift + P` &rarr; `Developer: Show Scope Name` |

This displays the full selector chain (e.g., `source.go entity.name.function.go`, `source.python meta.function.parameters`, `source.terraform storage.type.hcl`), making it easy to identify scope gaps or write custom overrides in `.sublime-color-scheme` files.

---

## 🎨 Recommended Fonts & Color Schemes to Compare

### Popular Monospace Coding Fonts to Test
- **JetBrains Mono**: Clean, tall x-height, extensive coding ligatures and stylistic sets.
- **Berkeley Mono**: Crafted, artisanal grid alignment and high-contrast punctuation.
- **Fira Code**: The classic ligature-rich programming font with numerous stylistic sets.
- **Cascadia Code**: Microsoft's modern coding font with cursive italics and box-drawing precision.
- **Iosevka**: Highly customizable, compact proportions ideal for split-screen layouts.
- **Monaspace** (GitHub): Five distinct styles (Argon, Neon, Xenon, Radon, Krypton) with Texture Healing.
- **Intel One Mono**: Engineered specifically for maximum legibility and reduced eye strain.
- **Victor Mono**: Distinctive cursive italics paired with crisp monospace characters.
- **Hack**: Workhorse open-source font based on DejaVu Sans Mono / Bitstream Vera.
- **Source Code Pro**: Classic Adobe typography with exceptional horizontal rhythm.

### Color Schemes to Compare
- **Default Schemes**: Mariana, Monokai, Breakers, Celeste.
- **Community Schemes**: Monokai Pro, Catppuccin (Mocha/Macchiato/Frappé/Latte), One Dark Pro, Gruvbox, Tokyo Night, Nord, Solarized Dark/Light, Dracula, Ayu (Dark/Mirage/Light).

---

## 🤝 Contributing

Contributions to expand language coverage or sharpen typographic edge-cases are welcome!

When submitting additions or modifications:
1. **Preserve Visual Richness**: Do not strip complex regexes, unusual escape codes, nested brackets, or Unicode symbols. They are intentionally crafted to expose syntax highlighter and rendering boundaries.
2. **Ensure Syntactically Valid Code**: Sample files should be syntactically valid code so Sublime Text linters (e.g., SublimeLinter) and tree-sitter / YAML / Python parsers tokenize tokens cleanly without error fallback.
3. **Include a Disambiguation Section**: When introducing new language files (e.g., Rust, TypeScript, C++, Elixir, SQL), include a structured breakdown of language constructs and a dedicated ligature / glyph visual check.

---

## 📄 License

This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use and adapt it for your personal or team development environment setups.

