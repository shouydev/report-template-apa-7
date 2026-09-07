# Guidelines for tables and figures - APA 7

This project is configured to automate numbering, title formatting, and the list
of tables and figures following the APA 7 standard. When generating the PDF,
tables and figures share a universal numerical sequence (Table 1, Table 2, and
so on), regardless of whether you write them in Markdown or LaTeX.

Every item automatically receives:

- The identifier in **bold** (for example, **Table 1**).
- A line break.
- The descriptive title in _italics_.

The following sections explain how to insert and reference each element in your
chapter Markdown files.

---

## 1. Simple tables (Markdown)

Use Markdown tables for straightforward data presentations. They comply strictly
with APA 7 requirements (text alignment and the absence of internal vertical
lines, which the export engine manages automatically).

### 1.1. Automated headers and horizontal lines

The project Lua filters (`pandoc/filters/table-headers-autocenter.lua` and
`pandoc/filters/table-row-lines.lua`) provide automated formatting:

- **Automated bold and centered headers:** You don't need to write `**...**` or
  `\centering` in column titles. The engine centers them and applies bold
  formatting automatically.
- **Independent body alignment:** The delimiter row (`:---`, `:---:`, `---:`)
  controls only the alignment of body data cells without affecting header
  centering.
- **Consistent horizontal rules:** Each body row includes a horizontal dividing
  line with uniform thickness (`\lightrulewidth`).

**Code:**

```markdown
| Column 1 | Column 2 | Column 3 |
| :------- | :------: | -------: |
| Left     | Centered |    Right |
| Data     |   Data   |     Data |

: Brief yet descriptive table title {#tbl:my-simple-table}

_Note._ Use notes to describe table contents that cannot be understood from the
title alone.
```

*(Don't add italic formatting to the title in the caption line or manual bold
formatting to column headers; the system formats them automatically).*

**Referencing in text:**

> As shown in `@tbl:my-simple-table`, the data demonstrate that...

## 2. Complex tables (pure LaTeX)

Use pure LaTeX tables for structures such as competitor matrices, role
matrices, sprint backlogs, or layouts that require merged cells (rowspan or
colspan), vertical borders, and fixed column widths (`p{...}`, `m{...}`, `X`).
Due to their structural complexity, their internal cell design is exempt from
strict APA 7 rules; however, their outer captions and numbering follow the
standard automatically.

### 2.1. Header optimization (`\thfirst`, `\thcell`, `\thc`, `\thspan`)

In paragraph-type or automatic columns (`p{...}`, `m{...}`, or `X`), LaTeX
aligns text to the left by default. To avoid writing verbose commands like
`\multicolumn{1}{|c|}{\textbf{...}}` in every header cell or merged subheading,
the project provides global macros in `pandoc/report.yaml`:

- **`\thfirst{Title}`**: First column of the header row. Applies **horizontal
  centering and automated bold formatting**, preserving the left and right
  vertical borders (`|c|`).
- **`\thcell{Title}`**: Subsequent columns (second column onward). Applies
  **horizontal centering and automated bold formatting**, preserving the right
  dividing border (`c|`).
- **`\thc{Title}`**: Tables without vertical borders. Applies **horizontal
  centering and automated bold formatting** without vertical lines (`c`).
- **`\thspan{N}{Title}`**: Subheadings or intermediate headers spanning $N$
  columns (colspan, such as "Description"). Applies **horizontal centering and
  automated bold formatting**, preserving the right vertical border (`c|`).
- **`\thspanfirst{N}{Title}`**: Same as `\thspan`, but starting from the first
  column (includes the left vertical border `|c|`).

<!-- prettier-ignore -->
> [!NOTE]
> Bold formatting is 100% automated: don't write `\textbf{...}` inside
> `\thfirst{...}`, `\thcell{...}`, `\thc{...}`, or `\thspan{...}`. Pass only the
> title text, and the macro formats it in bold and centers it.

**Example code (with vertical borders and a merged subheading):**

```latex
\begin{table}[htpb]
\centering
\caption{Team Member Profiles Matrix}
\label{tbl:team-profiles-matrix}
\renewcommand{\arraystretch}{1.4}
\begin{tabularx}{\textwidth}{| m{2.5cm} | X | m{4.5cm} |}
\hline
\thfirst{Photo} & \thcell{Name} & \thcell{Major} \\
\hline
\multirow{4}{2.5cm}{\centering [Photo]}
& Team Member Name & Software Engineering \\
\cline{2-3}
& \thspan{2}{Description} \\
\cline{2-3}
& \multicolumn{2}{p{\dimexpr\textwidth-2.5cm-4\tabcolsep-3\arrayrulewidth\relax}|}{%
    Detailed description of the member's professional profile...
} \\
\hline
\end{tabularx}
\end{table}

*Note.* Matrix prepared by the team for the project report.
```

**Example code in `longtable` (multipage):**

```latex
\begin{longtable}{|p{4.5cm}|p{6cm}|p{4.5cm}|}
\hline
\thfirst{Specific Criterion} & \thcell{Actions Taken} & \thcell{Conclusions} \\
\hline
\endfirsthead

\hline
\thfirst{Specific Criterion} & \thcell{Actions Taken} & \thcell{Conclusions} \\
\hline
\endhead

... content rows ...
\hline
\end{longtable}
```

### 2.2. Guidelines for requesting tables

This document serves as a technical specification for requesting LaTeX tables
from AI models (Antigravity, ChatGPT, Claude, and others). When you prompt an AI
model to generate a LaTeX table for this repository, provide the following
instruction:

> *"Generate the table in LaTeX code for the report following the guidelines in
> `docs/guidelines_tables_figures_apa7.md`: use `tabularx` with width
> `\textwidth`, adjust spacing with `\renewcommand{\arraystretch}{1.4}`, and use
> the mandatory macros `\thfirst{...}` for the first column, `\thcell{...}` for
> subsequent columns, and `\thspan{N}{...}` for merged section subheadings
> (without manually adding `\textbf{}`). Include `\caption{...}`,
> `\label{tbl:...}`, and the footnote with `*Note.*`."*

**Referencing in text:**

> Evaluating `Table \ref{tbl:team-profiles-matrix}`, we can conclude that...

## 3. Figures

By default, the system centers all images automatically and applies the APA 7
title format (bold number above, italic title below).

**Code:**

```markdown
![Information System Architecture](assets/arquitectura.png){#fig:system-architecture}

_Note._ Additional explanations or copyright attribution for the figure.
```

**Referencing in text:**

> The diagram in `@fig:system-architecture` details the information flow.
