# Guidelines for tables and figures - APA 7

This project configures automated numbering, title formatting, and the list of
tables and figures following the APA 7 standard. When generating the PDF, tables
and figures share a universal numerical sequence (Table 1, Table 2, and so on),
regardless of whether you write them in Markdown or LaTeX.

Every item automatically receives:

- The identifier in **bold** (for example, **Table 1**).
- A line break.
- The descriptive title in _italics_.
- Strict flush-left alignment without paragraph indentation.

The following sections explain when to use Markdown versus LaTeX, how to avoid
unwanted indentation, and how to write concise, human-authored titles and notes
compliant with APA 7.

---

## 1. Table format decision matrix

Choose the table format based on structural complexity and column count:

| Table type | Structural requirements | Required format | Rationale |
| :--- | :--- | :--- | :--- |
| **Standard table** | Normal rows and columns (up to 5 columns), no merged cells | **Markdown table** | Clean, portable, and automatically formatted with APA 7 rules by project Lua filters. |
| **Wide standard table** | Normal rows and columns with **more than 5 columns** | **LaTeX `longtable`** | Markdown hyphens struggle with wide layouts. LaTeX allows precise column widths (`p{2cm}`). |
| **Complex table** | Merged cells (`rowspan`, `colspan`), multi-tier headers, vertical rules | **LaTeX `longtable`** | Requires LaTeX capabilities (`\multirow`, `\thspan`) while supporting multipage splitting. |

<!-- prettier-ignore -->
> [!IMPORTANT]
> **Strict prohibition against floating tables:** Never use `\begin{table}` or
> standalone `\begin{tabularx}`. Floating environments cause unpredictable page
> jumps, break pagination on long tables, and cause title alignment issues.
> Always use pure Markdown for standard tables, and **only `longtable`** for
> LaTeX tables.

---

## 2. Standard tables (Markdown)

Use Markdown tables as the default for all standard data presentations (5 or
fewer columns without merged cells).

### 2.1. Automated styling and alignment

The project Lua filters (`pandoc/filters/table-headers-autocenter.lua` and
`pandoc/filters/table-row-lines.lua`) format Markdown tables automatically:

- **Automated bold and centered headers:** The engine centers headers and
  applies bold formatting automatically. You do not need `**...**` or
  `\centering`.
- **Independent body alignment:** The delimiter row (`:---`, `:---:`, `---:`)
  controls only the alignment of body data cells without affecting headers.
- **Horizontal dividing lines:** Each body row includes a horizontal dividing
  line with uniform thickness (`\lightrulewidth`).
- **Relative column widths:** The number of hyphens in the delimiter row
  determines the proportional width of each column (for example,
  `| :--- | :------------------- |`).

### 2.2. Standard table code

```markdown
| Evaluation metric | Target SLA | Measured latency | Status |
| :---------------- | :--------- | :--------------- | :----- |
| API Gateway       | < 50 ms    | 24 ms            | Passed |
| Database query    | < 10 ms    | 4 ms             | Passed |
| Background worker | < 200 ms   | 112 ms           | Passed |

: Summary of system latency metrics {#tbl:system-latency}

\noindent _Note._ SLA = service-level agreement. Metrics collected over 10,000 requests.
```

<!-- prettier-ignore -->
> [!NOTE]
> Do not add manual italics to the title in the caption line (`:`) or manual
> bolding to column headers. The export engine applies these automatically.

### 2.3. Referencing in text

```markdown
As presented in @tbl:system-latency, all endpoints met latency targets.
```

---

## 3. LaTeX tables (strictly `longtable`)

Pure LaTeX tables are permitted **only** for:

1. **Wide standard tables:** Tables with **more than 5 columns**, where explicit
   column widths (`p{...}`) are needed to prevent text overflow.
2. **Complex tables:** Tables requiring cell merging (`\multicolumn`,
   `\multirow`), subheadings, or vertical divider borders.

Every LaTeX table must use the `longtable` environment.

### 3.1. Why `longtable` is mandatory

- **Multipage breaks:** Tables split across page boundaries without clipping or
  overflowing margins.
- **Repeating headers:** Headers repeat on subsequent pages using
  `\endfirsthead` and `\endhead`.
- **Zero floating errors:** Tables stay exactly where placed in the text,
  preventing random page jumps.
- **Native APA 7 alignment:** Fully configured in `pandoc/report.yaml` with
  `\captionsetup[longtable]` and `\setlength{\LTleft}{0pt}` for flush-left
  titles without margin displacement.

### 3.2. Header optimization macros

To eliminate verbose manual formatting, use the project macros defined in
`pandoc/report.yaml`:

- **`\thfirst{Title}`**: First column header. Applies horizontal centering and
  bold formatting, preserving vertical borders (`|c|`).
- **`\thcell{Title}`**: Subsequent column headers. Applies horizontal centering
  and bold formatting, preserving the right border (`c|`).
- **`\thc{Title}`**: Table headers without vertical borders (`c`).
- **`\thspan{N}{Title}`**: Subheadings spanning $N$ columns (`colspan`). Applies
  centering and bold formatting with a right border (`c|`).
- **`\thspanfirst{N}{Title}`**: Subheadings spanning $N$ columns starting at
  column 1 (`|c|`).

<!-- prettier-ignore -->
> [!NOTE]
> Never write `\textbf{...}` inside `\thfirst`, `\thcell`, `\thc`, or `\thspan`.
> Pass plain text only; the macro applies bold and centering automatically.

### 3.3. Wide table example (more than 5 columns)

```latex
\begin{longtable}{|p{2.2cm}|p{2cm}|p{2cm}|p{2cm}|p{2.5cm}|p{2.2cm}|}
\caption{Cross-platform Benchmark Results across Tested Environments}\label{tbl:benchmark-results} \\
\hline
\thfirst{Environment} & \thcell{CPU Usage} & \thcell{RAM (MB)} & \thcell{I/O Wait} & \thcell{Throughput (RPS)} & \thcell{Status} \\
\hline
\endfirsthead

\hline
\thfirst{Environment} & \thcell{CPU Usage} & \thcell{RAM (MB)} & \thcell{I/O Wait} & \thcell{Throughput (RPS)} & \thcell{Status} \\
\hline
\endhead

Bare Metal & 12.4\% & 1,024 & 0.2\% & 8,450 & Optimal \\
\hline
Docker Container & 14.1\% & 1,180 & 0.4\% & 8,210 & Optimal \\
\hline
Kubernetes Pod & 15.8\% & 1,240 & 0.5\% & 8,050 & Optimal \\
\hline
Virtual Machine & 21.2\% & 1,510 & 1.1\% & 7,120 & Acceptable \\
\hline
Serverless Function & 8.5\% & 512 & 0.8\% & 4,300 & Constrained \\
\hline
Edge Gateway & 18.0\% & 890 & 0.6\% & 6,100 & Acceptable \\
\hline
\end{longtable}

\noindent *Note.* RPS = requests per second. Measurements represent 60-minute steady-state load tests.
```

### 3.4. Complex table example (merged cells and subheadings)

```latex
\begin{longtable}{|p{3cm}|p{5cm}|p{6.5cm}|}
\caption{Team Responsibilities and Architecture Ownership Matrix}\label{tbl:team-responsibilities} \\
\hline
\thfirst{Component} & \thcell{Primary Role} & \thcell{Deliverables} \\
\hline
\endfirsthead

\hline
\thfirst{Component} & \thcell{Primary Role} & \thcell{Deliverables} \\
\hline
\endhead

\multirow{2}{3cm}{Backend Core}
& API Architect & RESTful contracts and domain services \\
\cline{2-3}
& Database Engineer & Migration scripts and query optimization \\
\hline
\thspanfirst{3}{Infrastructure and Deployment Operations} \\
\hline
\multirow{2}{3cm}{Cloud Platform}
& DevOps Specialist & CI/CD deployment pipelines and Helm charts \\
\cline{2-3}
& Security Auditor & Vulnerability scans and IAM role definitions \\
\hline
\end{longtable}

\noindent *Note.* IAM = identity and access management; CI/CD = continuous integration and continuous delivery.
```

### 3.5. Referencing in text

```markdown
The architectural allocation is summarized in Table \ref{tbl:team-responsibilities}.
```

---

## 4. Preventing indentation on titles, numbers, and notes

In APA 7, table and figure numbers (**Table 1**), titles (*Title*), and notes
(*Note.*) must be **flush-left** with zero indentation.

### 4.1. Causes of unwanted indentation and their solutions

1. **Whitespace before caption syntax in Markdown:**
   - *Problem:* Writing spaces or tabs before `: Title {#tbl:...}` causes
     Markdown to treat the caption as an indented block.
   - *Fix:* Ensure the colon `:` starts at column 1 (flush against the left
     margin).
2. **Embedding tables inside blockquotes or lists:**
   - *Problem:* Placing tables inside list items (`- `) or blockquotes (`> `)
     causes the caption to inherit the parent margin.
   - *Fix:* Place tables at root document level, separated by blank lines.
3. **Centering environments in LaTeX:**
   - *Problem:* Putting `\centering` inside `\begin{table}` shifts captions
     relative to text margins.
   - *Fix:* Use `longtable` exclusively. The template sets
     `\setlength{\LTleft}{0pt}` and `\captionsetup[longtable]{width=\textwidth}`
     to enforce flush-left alignment automatically.
4. **Paragraph indentation on notes:**
   - *Problem:* The report template applies a 0.5-inch first-line indent
     (`\parindent = 0.5in`) to all standard paragraphs for APA 7 narrative text.
     Because notes are written as regular paragraphs below tables, LaTeX applies
     this half-inch indent by default.
   - *Fix:* Always prefix table and figure notes with `\noindent`:
     ```markdown
     \noindent _Note._ Clear and concise note text.
     ```
   - *Project automation:* The project Lua filter
     (`pandoc/filters/table-row-lines.lua`) automatically injects `\noindent`
     for paragraphs starting with `_Note._`, `_Nota._`, `*Note.*`, or `*Nota.*`,
     providing fallback protection even if `\noindent` is omitted.

---

## 5. APA 7 Editorial standards for titles and notes

AI models frequently produce bloated, circular, and pompous text filled with
unnecessary filler phrases. Follow these rules to ensure human-grade, concise
academic writing compliant with APA 7.

### 5.1. Table and figure titles (APA 7 Sections 7.11 and 7.25)

- **Structure:** The number appears in **bold** on the first line, followed by
  the descriptive title in _italics_ on the second line (automated by Pandoc).
- **Length:** Brief, direct, and explanatory (typically 3 to 8 words).
- **Focus:** State what the table or figure contains (variables, scope, or
  population). Avoid full sentences or narrative explanations.
- **Prohibited AI filler phrases:**
  - ❌ *"Table illustrating a comprehensive and detailed overview of..."*
  - ❌ *"Tabla que muestra de manera exhaustiva y detallada la comparativa..."*
  - ❌ *"A continuación se presenta la matriz representativa de..."*
  - ❌ *"Figure showing the complete architecture diagram of the system..."*

#### Title comparison

| Context | ❌ Avoid (AI filler) | ✔️ Correct APA 7 (Concise) |
| :--- | :--- | :--- |
| **Technology selection** | *Tabla que muestra de manera exhaustiva la comparativa integral entre las tecnologías evaluadas para el desarrollo del backend* | *Comparación de tecnologías de backend* |
| **Performance testing** | *Detailed comprehensive evaluation metrics table demonstrating performance under various load testing scenarios* | *Stress testing performance metrics* |
| **User stories** | *A continuación se presenta la tabla que describe minuciosamente todas las historias de usuario priorizadas del Sprint 1* | *Historias de usuario del Sprint 1* |
| **System architecture** | *Figure illustrating the complete structural diagram of all container microservices and network connections* | *System container architecture* |

### 5.2. Table and figure notes (APA 7 Sections 7.14 and 7.28)

- **Position and format:** Directly below the table or figure, flush-left
  (`\noindent`), starting with the label `_Note._` (English) or `_Nota._`
  (Spanish) in italics, followed by a period and a space.
- **Purpose:** Provide essential context that cannot be understood from the
  title alone, define non-standard abbreviations, and cite sources.
- **Three note categories:**
  1. **General note:** Explains the overall table, credits sources, or lists
     acronyms (for example, `\noindent _Note._ Adapted from Perez (2023).`).
  2. **Specific note:** Explains a specific column or cell using superscript
     lowercase letters ($^a$, $^b$).
  3. **Probability note:** Explains statistical significance levels
     ($*p < .05$, $**p < .01$).
- **Prohibited AI filler phrases:**
  - ❌ *"Nota. La presente tabla ha sido elaborada minuciosamente por los autores del proyecto con el propósito fundamental de exponer los resultados..."*
  - ❌ *"Note. This comprehensive table was carefully crafted by the project team to provide actionable insights into the underlying operational data..."*

#### Note comparison

| Context | ❌ Avoid (AI filler) | ✔️ Correct APA 7 (Concise) |
| :--- | :--- | :--- |
| **Author attribution** | `\noindent _Nota._ Tabla elaborada detalladamente por los autores del presente proyecto a partir de la recolección de datos realizada durante la investigación.` | `\noindent _Nota._ Elaboración propia a partir de métricas de Prometheus.` |
| **Acronym definitions** | `\noindent _Note._ It is important to note that the abbreviations SLA and RPS refer respectively to service-level agreement and requests per second.` | `\noindent _Note._ SLA = service-level agreement; RPS = requests per second.` |
| **Adapted source** | `\noindent _Nota._ Esta información fue extraída y minuciosamente adaptada del artículo publicado por Gómez en el año 2024 para fines comparativos.` | `\noindent _Nota._ Adaptado de Gómez (2024).` |
| **Measurement scope** | `\noindent _Note._ The values depicted across all rows represent numerical response times that were captured across experimental conditions.` | `\noindent _Note._ Response latency in milliseconds ($N = 1,000$).` |

---

## 6. Figures

Markdown figures are centered automatically and receive APA 7 caption formatting
(bold number, line break, and italic descriptive title above the image).

### 6.1. Markdown syntax

```markdown
![System Containers Architecture](report/assets/c4-diagrams/container-diagram.png){#fig:container-diagram}

\noindent _Note._ Adapted from the solution architecture C4 model.
```

### 6.2. Referencing in text

```markdown
The microservice topology is illustrated in @fig:container-diagram.
```

---

## 7. AI prompting instructions

When asking AI models (Antigravity, Claude, ChatGPT, Gemini) to generate tables
for this repository, copy and paste one of the following instructions:

### English prompt

> "Generate the table for the report adhering to the following rules:
> 1. Use a Markdown table if it is a standard table with up to 5 columns.
> 2. Use a LaTeX table ONLY if the table has more than 5 columns or requires
>    merged cells (`\multirow`, `\multicolumn`).
> 3. For LaTeX tables, use ONLY `longtable`. Do NOT use `\begin{table}` or
>    `tabularx`. Use `\thfirst{...}` for column 1, `\thcell{...}` for other
>    columns, and `\thspan{N}{...}` for subheadings (never add `\textbf{}`
>    inside macros).
> 4. Keep titles brief, direct, and academic (3 to 8 words). Never write
>    'Table showing...' or 'Comprehensive overview...'.
> 5. Prefix the note with `\noindent _Note._`. Keep notes functional: define
>    abbreviations and state data sources without verbose filler phrases."

### Spanish prompt

> "Genera la tabla para el informe siguiendo estas directrices estrictas:
> 1. Usa una tabla Markdown si es una tabla estándar de hasta 5 columnas.
> 2. Usa una tabla LaTeX ÚNICAMENTE si la tabla tiene más de 5 columnas o si
>    requiere celdas combinadas (`\multirow`, `\multicolumn`).
> 3. Para tablas LaTeX, usa EXCLUSIVAMENTE `longtable`. NO uses `\begin{table}`
>    ni `tabularx`. Usa las macros `\thfirst{...}` para la primera columna,
>    `\thcell{...}` para las siguientes y `\thspan{N}{...}` para subtítulos
>    combinados (sin `\textbf{}` dentro de las macros).
> 4. Mantén títulos breves, directos y académicos (3 a 8 palabras). No uses
>    'Tabla que muestra...' ni 'A continuación se presenta...'.
> 5. Comienza la nota con `\noindent _Nota._`. Mantén las notas funcionales:
>    define abreviaturas y cita fuentes sin texto de relleno estilo IA."
