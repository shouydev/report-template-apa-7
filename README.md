# Academic report template - APA 7

<!-- prettier-ignore -->
> [!NOTE]
> **Language / Idioma:** English | [Español](README.es.md)

A professional, modular template for authoring thesis reports, engineering
dissertations, and academic papers under the **APA 7 (7th edition)** standard,
following **Docs as Code** best practices. The project integrates a
containerized environment powered by **Docker**, **Pandoc**, **LuaLaTeX**,
custom Lua filters, and **Diagrams as Code** tooling (Structurizr C4 DSL and
PlantUML).

---

## Table of contents

- [Key features](#key-features)
- [Prerequisites](#prerequisites)
- [Docs as code conventions (numbering structure)](#docs-as-code-conventions-numbering-structure)
- [Repository structure](#repository-structure)
- [Multilingual support and compilation](#multilingual-support-and-compilation)
  - [Compiling the complete report](#compiling-the-complete-report)
  - [Single file preview (`make single`)](#single-file-preview-make-single-make-single-es-make-single-en)
  - [Supported languages scope](#supported-languages-scope)
- [Makefile commands](#makefile-commands)
- [APA 7 writing guide](#apa-7-writing-guide)
  - [1. APA 7 tables](#1-apa-7-tables)
  - [2. Figures](#2-figures)
  - [3. Citations and bibliography](#3-citations-and-bibliography)
- [Diagrams as code](#diagrams-as-code)
- [Additional documentation](#additional-documentation)
- [License](#license)
- [Annex: Spanish documentation](#annex-spanish-documentation)

---

## Key features

- **Strict APA 7 compliance:**
  - Automated bold label, line break, and italic descriptive title for tables
    and figures.
  - 0.5-inch paragraph first-line indent, hanging indent for references,
    1.5 line spacing, 1-inch margins, and top-right page numbering.
- **Docs as code workflow:**
  - Modular Markdown files versioned with Git.
  - Strict decade-based numbering scheme that guarantees deterministic
    compilation order across all platforms.
- **Built-in multilingual support:**
  - First-class support for **Standard Spanish (`es`)** and **US English (`en`)**.
  - Automatic localization of cross-references (`pandoc-crossref`), hyphenation
    patterns (LaTeX Babel), and bibliographic citations (`citeproc`).
- **Advanced table rendering:**
  - Standard Markdown tables formatted via Lua filters for bold centered headers
    and uniform horizontal rules (`\lightrulewidth`).
  - Pre-packaged global LaTeX macros for complex layout tables (`\thfirst`,
    `\thcell`, `\thc`, `\thspan`).
- **Diagrams as code:**
  - Software architecture diagrams modeled in Structurizr C4 DSL
    (`workspace.dsl`).
  - Class and entity-relationship database diagrams modeled in PlantUML
    (`.puml`).
- **Zero local dependencies (fully containerized):**
  - Runs entirely inside official Docker containers (`pandoc/extra:3.8.3`,
    `plantuml`, `structurizr`). You don't need to install TeX Live or Pandoc
    on your host machine.
- **Native cross-platform support:**
  - Fully compatible with **Linux**, **macOS** (both Apple Silicon M1/M2/M3/M4
    and Intel processors), and **Windows** (via Docker Desktop and adapted
    `Makefile` commands).

---

## Prerequisites

You only need the following tools installed on your host machine:

1. **[Docker](https://www.docker.com/):**
   - **Linux:** Docker Engine with active daemon.
   - **macOS:** Docker Desktop (native support for Apple Silicon M1/M2/M3/M4
     and Intel x86_64 architectures).
   - **Windows:** Docker Desktop with WSL2 backend.
2. **[GNU Make](https://www.gnu.org/software/make/):**
   - **Linux:** Pre-installed on most distributions.
   - **macOS:** Available through Xcode Command Line Tools (`xcode-select --install`)
     or Homebrew (`brew install make`).
   - **Windows:** Available through Chocolatey (`choco install make`), Scoop
     (`scoop install make`), or environments like Git Bash / MSYS2.

---

## Docs as code conventions (numbering structure)

To ensure deterministic, unambiguous file concatenation through `$(sort ...)`,
the repository follows a standardized numbering range:

```text
report/
├── front-matter/              # Range 01 - 09: Preliminary pages
│   ├── 01-cover.md
│   ├── 02-dedication.md
│   └── 03-abstract.md
├── chapters/                  # Range 10 - 89: Main content chapters
│   ├── 10-presentation/       # Chapter 1 (folder 10-*, content from 11 to 19)
│   │   ├── 11-context.md
│   │   ├── 12-problem-statement.md
│   │   └── 13-objectives.md
│   ├── 20-literature-review/  # Chapter 2 (folder 20-*, content from 21 to 29)
│   │   ├── 21-state-of-the-art.md
│   │   └── 22-technologies.md
│   ├── 30-architecture/       # Chapter 3 (folder 30-*, content from 31 to 39)
│   │   ├── 31-c4-design.md
│   │   └── 32-class-diagrams.md
│   └── ...                    # Subsequent chapters (40-*, 50-*, etc.) up to 89-*
├── back-matter/               # Range 90 - 99: Final sections and conclusions
│   ├── 90-conclusions.md
│   ├── 91-recommendations.md
│   └── 99-references.md
└── annexes/                   # Supplementary annexes and appendices
```

### Numbering rules:

1. **Front matter (`01` to `09`):** Contains preliminary pages preceding the
   main text (cover page, dedication, acknowledgments, abstract).
2. **Chapters (`10` to `89`):** Each chapter resides in its own folder named
   after the corresponding decade (`10-name`, `20-name`, `30-name`, and so on).
   - Chapter 1 files are numbered from **`11` to `19`**.
   - Chapter 2 files are numbered from **`21` to `29`**.
   - Chapter 3 files are numbered from **`31` to `39`**, and so on.
3. **Back matter (`90` to `99`):** Contains closing material: conclusions,
   lessons learned, recommendations, and the references section.

---

## Repository structure

```text
.
├── Makefile                           # Build automation and export recipes
├── README.md                          # Primary project documentation (English)
├── README.es.md                       # Spanish documentation (Anexo en español)
├── LICENSE                            # MIT open-source license
├── docs/                              # Supplementary technical documentation
│   ├── guidelines_tables_figures_apa7.md  # Detailed APA 7 tables and figures guide
│   └── project-statement.md           # Project statement document
├── pandoc/                            # Pandoc and LaTeX generation engine
│   ├── csl/
│   │   └── apa-7.csl                 # APA 7 citation style sheet
│   ├── filters/                      # Custom Lua filters
│   │   ├── table-headers-autocenter.lua  # Header centering and bold formatting
│   │   └── table-row-lines.lua       # Uniform table horizontal rules
│   ├── lang/                         # Localization metadata (i18n)
│   │   ├── en-US.yaml                # US English configuration
│   │   ├── en.yaml                   # Alias for English
│   │   ├── es-ES.yaml                # Standard Spanish configuration
│   │   └── es.yaml                   # Alias for Spanish
│   ├── report.yaml                   # Master default Pandoc configuration
│   └── template/
│       └── eisvogel.tex              # Eisvogel LaTeX template adapted for APA 7
└── report/                            # Modular report source files
    ├── front-matter/                 # Preliminary files (01 - 09)
    ├── chapters/                     # Chapters organized by decades (10 - 89)
    ├── back-matter/                  # Conclusions and references (90 - 99)
    ├── annexes/                      # Supplementary annexes
    ├── assets/                       # Generated images and diagrams
    │   └── diagram-sources/          # Diagram source files
    │       ├── c4-diagrams/          # Architecture in Structurizr DSL
    │       ├── class-diagrams/       # PlantUML class diagrams (.puml)
    │       └── database-diagrams/    # PlantUML ER database diagrams (.puml)
    └── bibliography/
        └── references.bib            # BibTeX bibliographic database
```

---

## Multilingual support and compilation

This template natively supports generating documents in both Spanish and US
English with straightforward workflows:

### Compiling the complete report

1. **`make pdf` (Default language):**  
   Compiles the complete report using the settings defined in
   `pandoc/report.yaml`. By default, it loads Spanish, but you can edit
   `pandoc/report.yaml` to set whichever default language you prefer.

2. **`make pdf-es` (Explicit Spanish):**  
   Compiles the complete report forcing **Spanish** localization
   (`pandoc/lang/es-ES.yaml`).

3. **`make pdf-en` (Explicit US English):**  
   Compiles the complete report forcing **US English** localization
   (`pandoc/lang/en-US.yaml`).

### Single file preview (`make single`, `make single-es`, `make single-en`)

When writing an individual section and needing rapid feedback without
rebuilding the entire report:

```bash
# Preview using the default settings in pandoc/report.yaml:
make single SRC=report/chapters/10-presentation/11-context.md

# Preview forcing Spanish localization:
make single-es SRC=report/chapters/10-presentation/11-context.md

# Preview forcing US English localization:
make single-en SRC=report/chapters/10-presentation/11-context.md
```

Output is generated at `build/single-output.pdf`.

### Supported languages scope

- **Spanish (`es` / `es-ES`):**  
  Designed as a **standard, neutral Spanish** valid across **Spain** and all
  of Spanish-speaking **Latin America**. Sets automated labels to **Tabla**,
  **Figura**, and **Índice de tablas**, configures Spanish hyphenation in
  Babel, and localizes citation conjunctions (for example, "y", "págs.",
  "2.ª ed.").
- **English (`en` / `en-US`):**  
  Follows standard **US English**, the native language and direct origin of the
  official **APA 7 manual** published by the *American Psychological
  Association*. Configures labels to **Table**, **Figure**, and **List of
  Tables**, serial Oxford commas, American hyphenation, and citation
  conjunctions (for example, "&", "pp.", "2nd ed.").

---

## Makefile commands

| Command | Description |
| :--- | :--- |
| `make pdf` | Compiles the full report using default settings from `pandoc/report.yaml`. |
| `make pdf-es` | Compiles the full report forcing Spanish localization (`es-ES`). |
| `make pdf-en` | Compiles the full report forcing US English localization (`en-US`). |
| `make single SRC=<path>` | Previews a single Markdown file at `build/single-output.pdf` using `report.yaml`. |
| `make single-es SRC=<path>` | Previews a single Markdown file forcing Spanish localization (`es-ES`). |
| `make single-en SRC=<path>` | Previews a single Markdown file forcing US English localization (`en-US`). |
| `make diagrams` | Generates PNG images from PlantUML class diagrams. |
| `make db-diagrams` | Generates PNG images from PlantUML database diagrams. |
| `make c4` | Exports the Structurizr C4 DSL model to PlantUML and renders PNG diagrams. |
| `make all` | Builds all diagrams and compiles the complete report PDF. |
| `make clean` | Removes the `build/` output directory and transient build artifacts. |

<!-- prettier-ignore -->
> [!TIP]
> You can customize the output PDF filename by overriding `PROJECT_NAME`:
> ```bash
> make pdf PROJECT_NAME=final-thesis-report
> ```

---

## APA 7 writing guide

### 1. APA 7 tables

The engine automatically formats the table label in bold and the title in
italics.

#### Simple tables (Markdown)

Use Markdown tables for straightforward data presentations. To ensure the table
spans the full text width (`\textwidth`), provide representative divider line
lengths:

```markdown
| Evaluation metric            | Score      | Status       |
| :--------------------------- | :--------: | -----------: |
| Latency                      |    98%     | Passed       |
| Security compliance          |   100%     | Optimal      |

: Summary of quality evaluation metrics {#tbl:quality-evaluation}

_Note._ Data collected during load and stress testing phases.
```

Reference the table in your text with:

```markdown
As presented in @tbl:quality-evaluation, the results indicate...
```

#### Complex tables (pure LaTeX)

For tables requiring merged cells (`colspan` / `rowspan`), vertical rules, or
fixed column widths, use `tabularx` with the global macros provided by the
project:

```latex
\begin{table}[htpb]
\centering
\caption{Team Member Profiles Matrix}
\label{tbl:team-profiles}
\renewcommand{\arraystretch}{1.4}
\begin{tabularx}{\textwidth}{| m{2.5cm} | X | m{4.5cm} |}
\hline
\thfirst{Photo} & \thcell{Name} & \thcell{Role} \\
\hline
\multirow{2}{2.5cm}{\centering [Photo]}
& John Doe & Lead Software Architect \\
\cline{2-3}
& \thspan{2}{Responsible for backend architecture and observability.} \\
\hline
\end{tabularx}
\end{table}

*Note.* Created by the project team.
```

<!-- prettier-ignore -->
> [!NOTE]
> For the complete list of macros (`\thfirst`, `\thcell`, `\thc`, `\thspan`)
> and prompting instructions for AI assistants, see
> [docs/guidelines_tables_figures_apa7.md](docs/guidelines_tables_figures_apa7.md).

---

### 2. Figures

Markdown images are centered automatically and receive APA 7 caption formatting:

```markdown
![System Containers Diagram](report/assets/c4-diagrams/container-diagram.png){#fig:containers}

_Note._ Adapted from the solution architecture C4 model.
```

Reference the figure in your text with:

```markdown
The container topology is illustrated in @fig:containers.
```

---

### 3. Citations and bibliography

Store your bibliographic sources in `report/bibliography/references.bib` in
standard BibTeX format:

```bibtex
@book{evans2003ddd,
  author    = {Eric Evans},
  title     = {Domain-Driven Design: Tackling Complexity in the Heart of Software},
  year      = {2003},
  publisher = {Addison-Wesley Professional}
}
```

Reference citations within Markdown using the bib key:

- **Parenthetical citation:** `[@evans2003ddd]` $\rightarrow$ *(Evans, 2003)*.
- **Narrative citation:** `@evans2003ddd` $\rightarrow$ *Evans (2003)*.
- **With page number:** `[@evans2003ddd, p. 45]` $\rightarrow$ *(Evans, 2003, p. 45)*.

The references section is automatically generated at the end of the document
with APA 7 hanging indent and alphabetical ordering.

---

## Diagrams as code

The repository maintains architectural and database designs synchronized with
code:

1. **C4 Model with Structurizr:** Model your architecture in
   `report/assets/diagram-sources/c4-diagrams/workspace.dsl`. Run `make c4` to
   export to PlantUML and render PNGs in `report/assets/c4-diagrams/`.
2. **Class diagrams:** Place `.puml` files in
   `report/assets/diagram-sources/class-diagrams/` and run `make diagrams`.
3. **Database diagrams:** Place `.puml` files in
   `report/assets/diagram-sources/database-diagrams/` and run `make db-diagrams`.

For live interactive preview in your browser using Structurizr Lite, see
[report/assets/diagram-sources/c4-diagrams/c4-guidelines.md](report/assets/diagram-sources/c4-diagrams/c4-guidelines.md).

---

## Additional documentation

- [APA 7 tables and figures guide](docs/guidelines_tables_figures_apa7.md):
  Technical specification for Markdown tables, complex LaTeX tables, and figures.
- [C4 architecture guide](report/assets/diagram-sources/c4-diagrams/c4-guidelines.md):
  Modular DSL file structure and local Docker preview server.

---

## License

This project is licensed under the [MIT License](LICENSE).

You are free to clone this repository, modify its structure, add support for
additional languages or locales, and customize the template to match your
institution's specific academic guidelines.

---

## Annex: Spanish documentation

For the complete version of this documentation in Spanish, see
[README.es.md](README.es.md).
