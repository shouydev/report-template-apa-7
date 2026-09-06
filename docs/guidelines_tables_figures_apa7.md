# Guía de Tablas y Figuras - Normas APA 7

El proyecto está configurado para automatizar la numeración, el formato de los títulos y el índice de Tablas y Figuras siguiendo la norma APA 7. Al momento de generar el PDF, las tablas y figuras compartirán una secuencia numérica universal (Tabla 1, Tabla 2, etc.), sin importar si fueron escritas en Markdown o en LaTeX.

Todas obtendrán de forma automática:

- El identificador en **Negrita** (ej. **Tabla 1**).
- Un salto de línea.
- El título descriptivo en _Cursiva_.

A continuación se detalla cómo debes insertar y referenciar cada elemento en tus archivos Markdown de los capítulos.

---

## 1. Tablas Simples (Markdown)

Úsalas para tablas de datos sencillas. Cumplen estrictamente con APA 7 (alineación de texto y ausencia de líneas verticales internas, las cuales son gestionadas automáticamente por el motor al exportar).

### 1.1. Automatización de Encabezados y Líneas Horizontales

Gracias a los filtros Lua del proyecto (`pandoc/filters/table-headers-autocenter.lua` y `pandoc/filters/table-row-lines.lua`):

- **Encabezados en Negrita y Centrados Automáticos:** No necesitas escribir `**...**` ni `\centering` en los títulos de las columnas. El motor los centra y formatea en negrita de forma 100% automática.
- **Alineación Independiente del Cuerpo:** La fila divisoria (`:---`, `:---:`, `---:`) controla exclusivamente la alineación de las celdas de datos del cuerpo, sin afectar el centrado del encabezado.
- **Líneas Divisorias Congruentes:** Cada fila del cuerpo cuenta con una línea horizontal divisoria con el mismo grosor homogéneo (`\lightrulewidth`).

**Código:**

```markdown
| Columna 1 | Columna 2 | Columna 3 |
| :-------- | :-------: | --------: |
| Izquierda | Centrado  |   Derecha |
| Dato      |   Dato    |      Dato |

: Título breve pero descriptivo de la tabla {#tbl:mi-tabla-simple}

_Nota._ Utiliza las notas para describir los contenidos de la tabla que no pueden entenderse solo con el título.
```

_(No le agregues formato de cursiva al título en la línea del caption ni negrita manual a las columnas, el sistema lo hará automáticamente)._

**Para referenciarla en el texto:**

> Como se puede observar en la `@tbl:mi-tabla-simple`, los datos demuestran que...

## 2. Tablas Complejas (LaTeX Puro)

Úsalas para tablas como matrices de competidores, matrices de roles, Sprint Backlog o estructuras que requieran unir celdas (rowspan/colspan), líneas verticales y anchos fijos (`p{...}`, `m{...}`, `X`). Por su complejidad, se exonera su diseño interior de la norma APA 7 estricta, pero su título exterior y numeración seguirán el estándar de forma automatizada.

### 2.1. Optimización para Encabezados (`\thfirst`, `\thcell`, `\thc`, `\thspan`)

En columnas de tipo párrafo o automáticas (`p{...}`, `m{...}` o `X`), LaTeX alinea el texto por defecto a la izquierda. Para evitar escribir manualmente instrucciones largas como `\multicolumn{1}{|c|}{\textbf{...}}` en cada celda del encabezado o en subtítulos combinados, el proyecto incluye macros globales en `pandoc/report.yaml`:

- **`\thfirst{Título}`**: Primera columna de la fila de encabezados. Aplica **centrado horizontal y negrita automática**, conservando el borde vertical izquierdo y derecho (`|c|`).
- **`\thcell{Título}`**: Columnas siguientes (de la segunda en adelante). Aplica **centrado horizontal y negrita automática**, conservando el borde divisorio vertical (`c|`).
- **`\thc{Título}`**: Para tablas sin bordes verticales. Aplica **centrado horizontal y negrita automática** sin agregar líneas verticales (`c`).
- **`\thspan{N}{Título}`**: Para subtítulos o encabezados intermedios que unen $N$ columnas (_colspan_ como «Descripción»). Aplica **centrado horizontal y negrita automática**, manteniendo el borde vertical derecho (`c|`).
- **`\thspanfirst{N}{Título}`**: Igual que `\thspan`, pero iniciando desde la primera columna (incluye borde izquierdo `|c|`).

<!-- prettier-ignore -->
> [!NOTE]
> La **negrita es 100% automática**: no debes escribir `\textbf{...}` dentro de `\thfirst{...}`, `\thcell{...}`, `\thc{...}` ni `\thspan{...}`. Solo pasa el texto del título y la macro lo formateará en negrita y centrado.

**Código de ejemplo (con bordes verticales y subtítulo combinado):**

```latex
\begin{table}[htpb]
\centering
\caption{Matriz de Perfiles del Equipo de Trabajo}
\label{tbl:matriz-perfiles-equipo}
\renewcommand{\arraystretch}{1.4}
\begin{tabularx}{\textwidth}{| m{2.5cm} | X | m{4.5cm} |}
\hline
\thfirst{Foto} & \thcell{Nombre} & \thcell{Carrera} \\
\hline
\multirow{4}{2.5cm}{\centering [Foto]}
& Nombre del Integrante & Ingeniería de Software \\
\cline{2-3}
& \thspan{2}{Descripción} \\
\cline{2-3}
& \multicolumn{2}{p{\dimexpr\textwidth-2.5cm-4\tabcolsep-3\arrayrulewidth\relax}|}{%
    Descripción detallada del perfil profesional del integrante...
} \\
\hline
\end{tabularx}
\end{table}

*Nota.* Matriz elaborada por el equipo para el reporte del proyecto.
```

**Código de ejemplo en `longtable` (multipage):**

```latex
\begin{longtable}{|p{4.5cm}|p{6cm}|p{4.5cm}|}
\hline
\thfirst{Criterio Específico} & \thcell{Acciones Realizadas} & \thcell{Conclusiones} \\
\hline
\endfirsthead

\hline
\thfirst{Criterio Específico} & \thcell{Acciones Realizadas} & \thcell{Conclusiones} \\
\hline
\endhead

... filas de contenido ...
\hline
\end{longtable}
```

### 2.2. Directrices para Solicitar Tablas

Este documento sirve como especificación técnica directa para solicitar tablas LaTeX a cualquier modelo de IA (Antigravity, ChatGPT, Claude, etc.). Cuando le pidas a una IA que genere una tabla en LaTeX para este repositorio, dale la siguiente instrucción:

> *"Genera la tabla en código LaTeX para el informe siguiendo las directrices de `docs/guidelines_tables_figures_apa7.md`: usa `tabularx` con ancho `\textwidth`, ajusta el espaciado con `\renewcommand{\arraystretch}{1.4}`, utiliza obligatoriamente las macros `\thfirst{...}` para la primera columna, `\thcell{...}` para las columnas siguientes y `\thspan{N}{...}` para subtítulos de sección combinados (sin agregar `\textbf{}` manual). Incluye `\caption{...}`, `\label{tbl:...}` y la nota al pie con `*Nota._`."_

**Para referenciarla en el texto:**

> Evaluando la `Tabla \ref{tbl:matriz-perfiles-equipo}`, podemos concluir que...

## 3. Figuras

Por defecto, el sistema centrará todas las imágenes automáticamente e incorporará el título APA 7 (número en negrita, título inferior en cursiva).

**Código:**

```markdown
![Arquitectura del Sistema de Información](assets/arquitectura.png){#fig:arquitectura-sistema}

_Nota._ Explicaciones extras con asteriscos o atribución de derechos de autor de la figura.
```

**Para referenciarla en el texto:**

> El diagrama de la `@fig:arquitectura-sistema` detalla el flujo de información.
