# sublime-font-checks

> **Directory Purpose**: Visual testbed and typography sandbox for evaluating font rendering, legibility, and color scheme punch & clarity in **Sublime Text**.

---

## 🎯 Context & Objective

The files in this repository exist to be opened directly in Sublime Text to test, tune, and compare:

1. **Monospace Fonts**:
   - Glyph clarity at small and large sizes (`pt 10` through `pt 16`).
   - Disambiguation of easily confused characters:
     - Number zero `0`, uppercase `O`, lowercase `o`, Greek theta `θ`
     - Digit one `1`, lowercase `l`, uppercase `I`, pipe `|`, exclamation mark `!`
     - Semicolon `;` vs colon `:`
     - Backtick `` ` `` vs single quote `'` vs double quote `"`
     - Substring lookalikes (e.g., `rn` vs `m`, `cl` vs `d`, `vv` vs `w`)
   - Operator ligatures (e.g., `!=`, `==`, `===`, `<=`, `>=`, `=>`, `->`, `<-`, `:=`, `&&`, `||`, `/*`, `*/`, `<!--`, `-->`, `..=`, `::`).
   - Line-height, character spacing, bold/italic rendering, and powerline/Unicode symbol alignment.

2. **Color Schemes**:
   - Contrast ratio and readability against dark, light, or OLED backgrounds.
   - Distinct scope differentiation (keywords vs builtins vs identifiers vs types vs strings vs comments).
   - Comment styling: is it legible or washed out? Do annotations (`TODO`, `FIXME`, `NOTE`, `BUG`) stand out?
   - Delimiter and bracket clarity (nested parentheses, braces, quotes).
   - Embedded languages and raw formats (regex patterns, heredocs, struct tags, YAML anchors, template interpolation).

---

## 📁 Repository Contents

| File | Language / Format | Highlighted Features & Scopes |
| :--- | :--- | :--- |
| [`sample.sh`](file:///home/benweston/Documents/sublime-font-checks/sample.sh) | **Bash / Shell** | Shebang, parameter expansions (`${var//a/b}`), regex matching, command substitutions, heredocs, ANSI escape codes, arithmetic expansions, signals, traps, ligatures. |
| [`sample.tf`](file:///home/benweston/Documents/sublime-font-checks/sample.tf) | **Terraform (HCL)** | Provider/resource/module blocks, heredoc templates, dynamic blocks, splat operators (`[*]`), complex types, ternary expressions, `for` comprehensions, built-in functions. |
| [`sample-k8s.yaml`](file:///home/benweston/Documents/sublime-font-checks/sample-k8s.yaml) | **Kubernetes YAML** | Multi-document manifests (`---`), YAML anchors (`&ref`) & aliases (`*ref`), literal/folded block scalars (`\|`, `>`), secrets, probes, deep nesting, indentation guide stress-test. |
| [`sample.go`](file:///home/benweston/Documents/sublime-font-checks/sample.go) | **Go (Golang)** | Generics, struct tags (nested syntax), `iota` enums, concurrency (`go`, `chan`, `select`), pointer receivers, raw strings, numeric literals (hex/binary/float), rune literals. |
| [`sample.py`](file:///home/benweston/Documents/sublime-font-checks/sample.py) | **Python** | PEP 695 type parameters, `@dataclass(slots=True)`, structural pattern matching (`match`/`case`), async generators/context managers, walrus operator (`:=`), matrix multiply (`@`), complex f-strings. |
| [`sample.Dockerfile`](file:///home/benweston/Documents/sublime-font-checks/sample.Dockerfile) | **Dockerfile** | Multi-stage architecture, BuildKit directives (`# syntax`), cache & secret mounts, execution heredocs (`RUN <<-EOF`), OCI metadata labels, healthcheck, multi-architecture build args. |

---

## 🔍 Sublime Text Inspection Tips

### Inspecting Syntax Scopes
To inspect the exact syntax scope assigned to any token under the cursor:
- **Linux / Windows**: Press <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>
- **macOS**: Press <kbd>Super</kbd> + <kbd>Option</kbd> + <kbd>P</kbd>
- Or via the Command Palette: `Developer: Show Scope Name`

This reveals the token selector (e.g. `source.go entity.name.function.go`, `source.terraform storage.type.hcl`) so you can customize `.sublime-color-scheme` rules.

### Testing Font Options in `Preferences.sublime-settings`
Key font settings to toggle when testing:
```json
{
  "font_face": "JetBrains Mono",
  "font_size": 13,
  "font_options": [
    "subpixel_antialias",
    // "no_liga",              // Uncomment to disable standard ligatures
    // "no_calt",              // Uncomment to disable contextual alternates
    // "dlig",                 // Enable discretionary ligatures (font-dependent)
    // "ss01", "ss02", "cv01"  // Stylistic sets / character variants (font-dependent)
  ],
  "line_padding_top": 2,
  "line_padding_bottom": 2,
  "caret_extra_top": 1,
  "caret_extra_bottom": 1
}
```

---

## 🤖 Instructions for AI Agents

1. **Preserve Visual Richness**:
   - When editing or adding files, do **not** strip unusual syntax constructs, complex regexes, nested brackets, or Unicode glyphs. They are intentionally present to test syntax highlighter edge-cases.
2. **Valid Syntax Preferred**:
   - Files should ideally be syntactically valid code so that Sublime Text's linters (SublimeLinter) and grammar engines parse every node correctly without error-fallback coloring.
3. **Consistency**:
   - When adding new test files for other languages (e.g., Rust, Python, TypeScript, Dockerfile), maintain the structured breakdown of language features and include a typography/ligature test section.
