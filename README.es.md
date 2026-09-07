# Plantilla de Reporte Académico - Normas APA 7

<!-- prettier-ignore -->
> [!NOTE]
> **Idioma / Language:** Español | [English](README.md)

Plantilla profesional y modular para la redacción de reportes de tesis, memorias de ingeniería y documentos académicos bajo el estándar **APA 7 (7.ª edición)**, siguiendo las mejores prácticas del paradigma **Docs as Code**. El proyecto integra un entorno contenerizado con **Docker**, **Pandoc**, **LuaLaTeX**, filtros Lua y herramientas de **Diagramas como Código** (Structurizr C4 DSL y PlantUML).

---

## Tabla de Contenidos

- [Características Principales](#características-principales)
- [Requisitos Previos](#requisitos-previos)
- [Convenciones Docs as Code (Estructura de Numeración)](#convenciones-docs-as-code-estructura-de-numeración)
- [Estructura del Repositorio](#estructura-del-repositorio)
- [Soporte Multidioma y Compilación](#soporte-multidioma-y-compilación)
  - [Compilación del Reporte Completo](#compilación-del-reporte-completo)
  - [Previsualización Individual (`make single`)](#previsualización-individual-make-single-make-single-es-make-single-en)
  - [Alcance de los Idiomas Soportados](#alcance-de-los-idiomas-soportados)
- [Comandos del Makefile](#comandos-del-makefile)
- [Guía de Redacción APA 7](#guía-de-redacción-apa-7)
  - [1. Tablas en Formato APA 7](#1-tablas-en-formato-apa-7)
  - [2. Figuras](#2-figuras)
  - [3. Citas y Bibliografía](#3-citas-y-bibliografía)
- [Diagramas como Código](#diagramas-como-código)
- [Documentación Adicional](#documentación-adicional)
- [Licencia](#licencia)

---

## Características Principales

- **Cumplimiento Estricto de APA 7:**
  - Identificador en negrita, salto de línea y título descriptivo en cursiva automáticos para tablas y figuras.
  - Sangría de primera línea de 0.5 pulgadas en párrafos, sangría francesa en bibliografía, interlineado 1.5 y numeración de página en la esquina superior derecha.
- **Enfoque Docs as Code:**
  - Documentos modulares en Markdown versionados con Git.
  - Convención estricta de rangos numéricos que garantiza determinismo en el orden de compilación.
- **Soporte Multidioma Integrado:**
  - Soporte para **Español estándar (`es`)** e **Inglés estadounidense (`en`)**.
  - Adaptación automática de referencias cruzadas (`pandoc-crossref`), separación silábica en LaTeX (Babel) y procesador de citas (`citeproc`).
- **Tablas Avanzadas (Markdown y LaTeX):**
  - Tablas Markdown con filtros Lua para centrado de cabeceras en negrita y líneas divisorias horizontales homogéneas (`\lightrulewidth`).
  - Macros globales para tablas complejas en LaTeX (`\thfirst`, `\thcell`, `\thc`, `\thspan`).
- **Diagramas como Código (Diagrams-as-Code):**
  - Arquitectura de software C4 con Structurizr DSL (`workspace.dsl`).
  - Diagramas de clases y relacionales de bases de datos en PlantUML (`.puml`).
- **Entorno Contenerizado Cero Dependencias:**
  - Todo se ejecuta mediante contenedores Docker oficiales (`pandoc/extra:3.8.3`, `plantuml`, `structurizr`). No requiere instalar TeX Live ni Pandoc en la máquina anfitriona.
- **Multiplataforma Nativo:**
  - Compatible con **Linux**, **macOS** (tanto procesadores Intel como Apple Silicon M1/M2/M3/M4) y **Windows** (vía Docker Desktop y comandos adaptados en el `Makefile`).

---

## Requisitos Previos

Solo requieres tener instaladas las siguientes herramientas:

1. **[Docker](https://www.docker.com/)**:
   - **Linux:** Docker Engine con demonio activo.
   - **macOS:** Docker Desktop (soporte nativo para procesadores Apple Silicon M1/M2/M3/M4 e Intel x86_64).
   - **Windows:** Docker Desktop con backend WSL2.
2. **[GNU Make](https://www.gnu.org/software/make/)**:
   - **Linux:** Preinstalado en la mayoría de distribuciones.
   - **macOS:** Preinstalado a través de las Command Line Tools (`xcode-select --install`) o mediante Homebrew (`brew install make`).
   - **Windows:** Disponible mediante Chocolatey (`choco install make`), Scoop (`scoop install make`) o entornos como Git Bash / MSYS2.

---

## Convenciones Docs as Code (Estructura de Numeración)

Para garantizar un orden de compilación determinista y libre de ambigüedades al concatenar los archivos modulares con `$(sort ...)`, el proyecto utiliza rangos de numeración específicos:

```text
report/
├── front-matter/              # Rango 01 - 09: Archivos preliminares
│   ├── 01-caratula.md
│   ├── 02-dedicatoria.md
│   └── 03-resumen.md
├── chapters/                  # Rango 10 - 89: Capítulos temáticos del cuerpo principal
│   ├── 10-presentation/       # Capítulo 1 (carpeta 10-*, desarrollo de 11 a 19)
│   │   ├── 11-contexto.md
│   │   ├── 12-problematica.md
│   │   └── 13-objetivos.md
│   ├── 20-marco-teorico/      # Capítulo 2 (carpeta 20-*, desarrollo de 21 a 29)
│   │   ├── 21-estado-del-arte.md
│   │   └── 22-tecnologias.md
│   ├── 30-arquitectura/       # Capítulo 3 (carpeta 30-*, desarrollo de 31 a 39)
│   │   ├── 31-diseno-c4.md
│   │   └── 32-diagramas-clases.md
│   └── ...                    # Capítulos sucesivos (40-*, 50-*, etc.) hasta 89-*
├── back-matter/               # Rango 90 - 99: Secciones finales y conclusiones
│   ├── 90-conclusiones.md
│   ├── 91-recomendaciones.md
│   └── 99-referencias.md
└── annexes/                   # Anexos y material suplementario
```

### Reglas de la Convención:
1. **Front Matter (`01` al `09`):** Contiene páginas preliminares que preceden al desarrollo principal (carátula, dedicatoria, agradecimientos, resumen / abstract).
2. **Chapters (`10` al `89`):** Cada capítulo se aloja en su propia carpeta nombrada con la decena correspondiente (`10-nombre`, `20-nombre`, `30-nombre`, etc.).
   - El desarrollo del capítulo 1 se distribuye en archivos numerados del **`11` al `19`**.
   - El desarrollo del capítulo 2 se distribuye en archivos numerados del **`21` al `29`**.
   - El desarrollo del capítulo 3 se distribuye en archivos numerados del **`31` al `39`**, y así sucesivamente.
3. **Back Matter (`90` al `99`):** Contiene el cierre formal del informe: conclusiones, lecciones aprendidas, recomendaciones y el apartado de referencias bibliográficas.

---

## Estructura del Repositorio

```text
.
├── Makefile                           # Automatización y recetas de compilación
├── README.md                          # Documentación principal en inglés
├── README.es.md                       # Documentación en español
├── LICENSE                            # Licencia de código abierto MIT
├── docs/                              # Guías técnicas complementarias
│   ├── guidelines_tables_figures_apa7.md  # Guía de tablas y figuras APA 7
│   └── project-statement.md           # Declaración del proyecto
├── pandoc/                            # Configuración del motor de generación PDF
│   ├── csl/
│   │   └── apa-7.csl                 # Hoja de estilo CSL para citas APA 7
│   ├── filters/                      # Filtros Lua de formateo automático
│   │   ├── table-headers-autocenter.lua  # Centrado y negrita en encabezados de tabla
│   │   └── table-row-lines.lua       # Líneas divisorias horizontales homogéneas
│   ├── lang/                         # Archivos de localización (i18n)
│   │   ├── en-US.yaml                # Configuración para Inglés estadounidense
│   │   ├── en.yaml                   # Alias para Inglés
│   │   ├── es-ES.yaml                # Configuración para Español estándar
│   │   └── es.yaml                   # Alias para Español
│   ├── report.yaml                   # Configuración maestra por defecto de Pandoc
│   └── template/
│       └── eisvogel.tex              # Plantilla LaTeX adaptada al estándar APA 7
└── report/                            # Contenido del informe modular
    ├── front-matter/                 # Archivos preliminares (01 - 09)
    ├── chapters/                     # Capítulos organizados por decenas (10 - 89)
    ├── back-matter/                  # Conclusiones y referencias (90 - 99)
    ├── annexes/                      # Anexos del proyecto
    ├── assets/                       # Imágenes y diagramas generados
    │   └── diagram-sources/          # Código fuente de diagramas
    │       ├── c4-diagrams/          # Arquitectura en Structurizr DSL
    │       ├── class-diagrams/       # Diagramas de clases PlantUML (.puml)
    │       └── database-diagrams/    # Diagramas relacionales PlantUML (.puml)
    └── bibliography/
        └── references.bib            # Base bibliográfica en formato BibTeX
```

---

## Soporte Multidioma y Compilación

El proyecto soporta de forma nativa la generación de documentos tanto en español como en inglés estadounidense, con comportamientos bien definidos:

### Compilación del Reporte Completo

1. **`make pdf` (Idioma por Defecto):**  
   Compila todo el informe tomando la configuración indicada en `pandoc/report.yaml`. Por defecto viene configurado en español, pero el usuario puede editar libremente `pandoc/report.yaml` para establecer el idioma o ajustes predeterminados que desee.

2. **`make pdf-es` (Español Forzado):**  
   Compila todo el informe forzando la configuración de idioma en **Español** (`pandoc/lang/es-ES.yaml`).

3. **`make pdf-en` (Inglés Forzado):**  
   Compila todo el informe forzando la configuración de idioma en **Inglés estadounidense** (`pandoc/lang/en-US.yaml`).

### Previsualización Individual (`make single`, `make single-es`, `make single-en`)

Cuando estés redactando un archivo Markdown y desees validar su renderizado rápidamente sin compilar todo el reporte:

```bash
# Previsualización con la configuración por defecto de pandoc/report.yaml:
make single SRC=report/chapters/10-presentation/11-contexto.md

# Previsualización forzando idioma español:
make single-es SRC=report/chapters/10-presentation/11-contexto.md

# Previsualización forzando idioma inglés:
make single-en SRC=report/chapters/10-presentation/11-contexto.md
```

El resultado se genera en `build/single-output.pdf`.

### Alcance de los Idiomas Soportados

- **Español (`es` / `es-ES`):**  
  Diseñado como un **español formal y estandarizado**, representativo y válido tanto para **España** como para toda la comunidad hispanohablante de **Latinoamérica**. Ajusta las etiquetas automáticas a **Tabla**, **Figura**, **Índice de tablas**, aplica separación silábica española en LaTeX Babel y traduce conectores y abreviaturas en citas bibliográficas (ej. «y», «págs.», «2.ª ed.»).
- **Inglés (`en` / `en-US`):**  
  Corresponde al **inglés estadounidense**, lengua y contexto en el que se publica originalmente el manual oficial de la **norma APA 7** por la *American Psychological Association*. Configura rótulos como **Table**, **Figure**, **List of Tables**, coma serial de Oxford, separación silábica americana y abreviaturas anglosajonas (ej. «&», «pp.», «2nd ed.»).

---

## Comandos del Makefile

| Comando | Descripción |
| :--- | :--- |
| `make pdf` | Compila el informe completo con la configuración por defecto de `pandoc/report.yaml`. |
| `make pdf-es` | Compila el informe completo forzando el idioma español (`es-ES`). |
| `make pdf-en` | Compila el informe completo forzando el idioma inglés estadounidense (`en-US`). |
| `make single SRC=<ruta>` | Compila un único archivo Markdown a `build/single-output.pdf` usando `report.yaml`. |
| `make single-es SRC=<ruta>` | Compila un único archivo Markdown forzando el idioma español (`es-ES`). |
| `make single-en SRC=<ruta>` | Compila un único archivo Markdown forzando el idioma inglés (`en-US`). |
| `make diagrams` | Genera imágenes PNG a partir de los diagramas de clases PlantUML. |
| `make db-diagrams` | Genera imágenes PNG a partir de los diagramas relacionales PlantUML. |
| `make c4` | Exporta el modelo Structurizr C4 DSL a PlantUML y compila los diagramas PNG. |
| `make all` | Genera todos los diagramas y compila el informe PDF completo. |
| `make clean` | Limpia el directorio de salida `build/` y archivos temporales. |

> [!TIP]
> Puedes personalizar el nombre del archivo PDF final sobrescribiendo la variable `PROJECT_NAME`:
> ```bash
> make pdf PROJECT_NAME=reporte-tesis-final
> ```

---

## Guía de Redacción APA 7

### 1. Tablas en Formato APA 7

El sistema aplica automáticamente el identificador de la tabla en negrita y su título descriptivo en cursiva.

#### Tablas Simples (Markdown)

Para tablas de datos convencionales. Para que la tabla se expanda ocupando todo el ancho de la página (`\textwidth`), define una longitud representativa en los guiones divisores:

```markdown
| Criterio                     | Puntuación | Estado       |
| :--------------------------- | :--------: | -----------: |
| Rendimiento                  |    98%     | Aprobado     |
| Seguridad                    |   100%     | Excelente    |

: Resumen de evaluación de calidad {#tbl:evaluacion-calidad}

_Nota._ Datos obtenidos en la fase de pruebas de estrés.
```

Para referenciarla en el texto:

```markdown
Como se describe en la @tbl:evaluacion-calidad, los resultados confirman...
```

#### Tablas Complejas (LaTeX Puro)

Para tablas que requieran combinación de celdas (`colspan` / `rowspan`), bordes verticales o anchos fijos, usa el entorno `tabularx` con las macros de cabecera del proyecto:

```latex
\begin{table}[htpb]
\centering
\caption{Matriz de Perfiles del Equipo de Trabajo}
\label{tbl:perfiles-equipo}
\renewcommand{\arraystretch}{1.4}
\begin{tabularx}{\textwidth}{| m{2.5cm} | X | m{4.5cm} |}
\hline
\thfirst{Foto} & \thcell{Nombre} & \thcell{Especialidad} \\
\hline
\multirow{2}{2.5cm}{\centering [Foto]}
& Juan Pérez & Arquitectura de Software \\
\cline{2-3}
& \thspan{2}{Responsable técnico del diseño del backend y observabilidad.} \\
\hline
\end{tabularx}
\end{table}

*Nota.* Elaboración propia.
```

> [!NOTE]
> Para conocer todas las macros disponibles (`\thfirst`, `\thcell`, `\thc`, `\thspan`) y directrices para solicitar tablas a modelos de IA, revisa [docs/guidelines_tables_figures_apa7.md](docs/guidelines_tables_figures_apa7.md).

---

### 2. Figuras

Las imágenes en Markdown se centran de forma automática y adoptan la rotulación APA 7:

```markdown
![Diagrama de Contenedores del Sistema](report/assets/c4-diagrams/container-diagram.png){#fig:contenedores}

_Nota._ Vista adaptada del modelo de arquitectura de solución C4.
```

Para referenciarla en el texto:

```markdown
El flujo de comunicación se ilustra en la @fig:contenedores.
```

---

### 3. Citas y Bibliografía

Registra tus fuentes bibliográficas en `report/bibliography/references.bib` en formato BibTeX:

```bibtex
@book{evans2003ddd,
  author    = {Eric Evans},
  title     = {Domain-Driven Design: Tackling Complexity in the Heart of Software},
  year      = {2003},
  publisher = {Addison-Wesley Professional}
}
```

En tus archivos Markdown puedes citar con la clave asignada:

- **Cita parentética:** `[@evans2003ddd]` $\rightarrow$ *(Evans, 2003)*.
- **Cita narrativa:** `@evans2003ddd` $\rightarrow$ *Evans (2003)*.
- **Con página o párrafo:** `[@evans2003ddd, p. 45]` $\rightarrow$ *(Evans, 2003, p. 45)*.

Al final del documento, la lista de referencias se compilará con el formato de sangría francesa y orden alfabético estricto de APA 7.

---

## Diagramas como Código

El proyecto integra flujos automatizados de arquitectura como código:

1. **C4 Model con Structurizr:** Modela el sistema en `report/assets/diagram-sources/c4-diagrams/workspace.dsl`. Ejecuta `make c4` para exportar a PlantUML y renderizar los archivos PNG en `report/assets/c4-diagrams/`.
2. **Diagramas de Clases:** Añade tus archivos `.puml` en `report/assets/diagram-sources/class-diagrams/` y ejecuta `make diagrams`.
3. **Diagramas de Base de Datos:** Añade tus archivos `.puml` en `report/assets/diagram-sources/database-diagrams/` y ejecuta `make db-diagrams`.

Para previsualización interactiva en tiempo real de los diagramas C4 en tu navegador mediante Structurizr Lite, consulta [report/assets/diagram-sources/c4-diagrams/c4-guidelines.md](report/assets/diagram-sources/c4-diagrams/c4-guidelines.md).

---

## Documentación Adicional

- [Guía de Tablas y Figuras APA 7](docs/guidelines_tables_figures_apa7.md): Guía de referencia técnica para tablas Markdown, tablas complejas LaTeX y figuras.
- [Guía de Arquitectura C4](report/assets/diagram-sources/c4-diagrams/c4-guidelines.md): Estructura modular del modelo Structurizr DSL y servidor local en Docker.

---

## Licencia

Este proyecto se distribuye bajo la [Licencia MIT](LICENSE).

Eres completamente libre de clonar este repositorio, modificar su estructura, agregar soporte para nuevos idiomas o dialectos y personalizar la plantilla según los estándares y normativas académicas que tu institución o proyecto requieran.
