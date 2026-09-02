# Guía de Tablas y Figuras - Normas APA 7

El proyecto está configurado para automatizar la numeración, el formato de los títulos y el índice de Tablas y Figuras siguiendo la norma APA 7. Al momento de generar el PDF, las tablas y figuras compartirán una secuencia numérica universal (Tabla 1, Tabla 2, etc.), sin importar si fueron escritas en Markdown o en LaTeX.

Todas obtendrán de forma automática:
- El identificador en **Negrita** (ej. **Tabla 1**).
- Un salto de línea.
- El título descriptivo en *Cursiva*.

A continuación se detalla cómo debes insertar y referenciar cada elemento en tus archivos Markdown de los capítulos.

---

## 1. Tablas Simples (Markdown)

Úsalas para tablas de datos sencillas. Cumplen estrictamente con APA 7 (alineación de texto y ausencia de líneas verticales internas, las cuales son gestionadas automáticamente por el motor al exportar).

**Código:**
```markdown
| Columna 1 | Columna 2 | Columna 3 |
| :--- | :---: | ---: |
| Izquierda | Centrado | Derecha |
| Dato | Dato | Dato |
: Título breve pero descriptivo de la tabla {#tbl:mi-tabla-simple}

*Nota.* Utiliza las notas para describir los contenidos de la tabla que no pueden entenderse solo con el título.
```
```alternativa para centrar titulo de tabla que esta a la izquierda o derecha
| \centering \textbf{Columna 1} | Columna 2 | Columna 3 |
| :--- | :---: | ---: |
| Izquierda | Centrado | Derecha |
| Dato | Dato | Dato |
: Título breve pero descriptivo de la tabla {#tbl:mi-tabla-simple}

*Nota.* Utiliza las notas para describir los contenidos de la tabla que no pueden entenderse solo con el título.
```

*(No le agregues formato de cursiva al título en la línea del caption, el sistema lo hará automáticamente).*

**Para referenciarla en el texto:**
> Como se puede observar en la `@tbl:mi-tabla-simple`, los datos demuestran que...


## 2. Tablas Complejas (LaTeX Puro)

Úsalas para tablas como matrices de competidores, Sprint Backlog o estructuras que requieran unir celdas (rowspan/colspan), líneas verticales y colores. Por su complejidad, se exonera su diseño interior de la norma APA 7, pero su título exterior y numeración seguirán el estándar de forma automatizada.

**Código:**
```latex
\begin{table}[H]
\centering
\caption{Matriz Comparativa de Competidores}
\label{tbl:competidores}
\begin{tabular}{|l|c|r|}
\hline
\textbf{Competidor} & \textbf{Ventajas} & \textbf{Desventajas} \\ \hline
Empresa A & Rápido & Costoso \\ \hline
Empresa B & Económico & Lento \\ \hline
\end{tabular}
\end{table}

*Nota.* Si utilizas abreviaturas en la tabla compleja, puedes especificarlas aquí en las notas.
```
*(Puedes generar el código LaTeX de la tabla visualmente usando herramientas como [TablesGenerator](https://www.tablesgenerator.com/latex_tables) y simplemente copiar y pegar el código en tu archivo Markdown asegurándote de incluir los comandos `\caption{}` y `\label{}`).*

**Para referenciarla en el texto:**
> Evaluando la `Tabla \ref{tbl:competidores}`, podemos concluir que...


## 3. Figuras

Por defecto, el sistema centrará todas las imágenes automáticamente e incorporará el título APA 7 (número en negrita, título inferior en cursiva).

**Código:**
```markdown
![Arquitectura del Sistema de Información](assets/arquitectura.png){#fig:arquitectura-sistema}

*Nota.* Explicaciones extras con asteriscos o atribución de derechos de autor de la figura.
```

**Para referenciarla en el texto:**
> El diagrama de la `@fig:arquitectura-sistema` detalla el flujo de información.

# 4. Ejemplo

\begin{table}[!ht]
    \centering
    \caption{Matriz Comparativa de Competidores}
    \label{tbl:competidores}
    \begin{tabular}{|l|l|l|l|}
    \hline
        ~ & ~ & ~ & ~ \\ \hline
        ~ & ~ & ~ & ~ \\ \hline
    \end{tabular}
\end{table}
*Nota.* Si utilizas abreviaturas en la tabla compleja, puedes especificarlas aquí en las notas.

| **Versión** | **Fecha** | **Autor** | **Descripción de modificación** |
|:-----------:|:---------:|:---------:|:-------------------------------:|
|             |           |           |                                 |
|             |           |           |                                 |
|             |           |           |                                 |
|             |           |           |                                 |
|             |           |           |                                 |
: Título breve pero descriptivo de la tabla {#tbl:mi-tabla-simple}

*Nota.* Utiliza las notas para describir los contenidos de la tabla que no pueden entenderse solo con el título.

![Arquitectura del Sistema de Información](assets/logos/upc-logo.png){#fig:arquitectura-sistema}

*Nota.* Explicaciones extras con asteriscos o atribución de derechos de autor de la figura.
