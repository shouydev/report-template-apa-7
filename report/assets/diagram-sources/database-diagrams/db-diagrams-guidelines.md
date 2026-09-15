# Guía de Diagramas de Base de Datos (Entity-Relationship & Relational Model)

Este proyecto gestiona los diagramas de base de datos (Modelo Entidad-Relación y
Modelo Relacional / Físico) mediante el enfoque **Diagrams-as-Code** utilizando
**PlantUML**. Al escribir el esquema de base de datos como código, se mantiene
el historial de versiones en Git, se facilita la revisión entre pares y se
automatiza la compilación a imágenes de alta definición para el reporte final.

---

## 📁 Estructura de Archivos y Directorios

Los diagramas de base de datos se organizan en archivos con extensión `.puml`:

```text
report/assets/
├── diagram-sources/
│   └── database-diagrams/                  <-- Fuentes PlantUML (.puml)
│       ├── db-diagrams-guidelines.md       <-- Esta guía
│       └── database-model-example.puml     <-- Ejemplo base de esquema relacional
└── database-diagrams/                      <-- Salida generada por Docker (.png)
    └── database-model-example.png
```

- **Fuentes (`diagram-sources/database-diagrams/`):** Almacena únicamente archivos
  `.puml` nombrados en formato `kebab-case` descriptivo (por ejemplo,
  `physical-data-model.puml`, `iam-schema.puml`).
- **Salida (`report/assets/database-diagrams/`):** Directorio donde el motor de
  PlantUML exporta las imágenes `.png` que serán incrustadas en el reporte PDF.

---

## 🛠️ Estándares de Modelado en PlantUML (Notación ERD)

Para representar entidades, atributos y relaciones de base de datos de manera
profesional y legible en el reporte de tesis, sigue estas directrices:

### 1. Configuración de renderizado y estilo visual

Incluye la siguiente cabecera al inicio de cada archivo `.puml`:

```plantuml
@startuml
skinparam dpi 300
skinparam shadowing false
skinparam roundcorner 6
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 11
skinparam classHeaderBackgroundColor #E5E7EB
skinparam classBorderColor #374151
skinparam arrowColor #1F2937

' Estilo para entidades de base de datos
hide circle
skinparam class {
  BackgroundColor #FFFFFF
  ArrowColor #1F2937
  BorderColor #374151
}
```

### 2. Definición de entidades (tablas) y atributos

- Usa la palabra clave `entity` con el nombre físico de la tabla en snake_case
  (o convención elegida para el motor de base de datos).
- Marca con un asterisco `*` los atributos obligatorios (*NOT NULL*).
- Indica explícitamente los modificadores clave:
  - `<<PK>>` Llave Primaria (*Primary Key*)
  - `<<FK>>` Llave Foránea (*Foreign Key*)
  - `<<UQ>>` Restricción Única (*Unique Constraint*)
- Separa la llave primaria del resto de columnas con un divisor `--`.

```plantuml
entity "users" as users {
  * id : uuid <<PK>>
  --
  * email : varchar(255) <<UQ>>
  * password_hash : varchar(255)
  * is_active : boolean
  * created_at : timestamptz
  updated_at : timestamptz
}

entity "orders" as orders {
  * id : uuid <<PK>>
  --
  * user_id : uuid <<FK>>
  * order_number : varchar(64) <<UQ>>
  * total_amount : numeric(12,2)
  * status : varchar(32)
  * created_at : timestamptz
}
```

### 3. Cardinalidades en notación Crow's Foot

Define las relaciones entre tablas empleando la notación estándar de pata de
gallo (*Crow's Foot*):

| Sintaxis PlantUML | Cardinalidad | Significado |
| :---: | :--- | :--- |
| `\|\|--\|\|` | Exactamente uno a exactamente uno | Relación 1:1 obligatoria en ambos extremos |
| `\|o--\|\|` | Cero o uno a exactamente uno | Relación 1:1 opcional en el origen |
| `\|\|--\|{` | Exactamente uno a uno o más | Relación 1:N (al menos uno obligatorio) |
| `\|\|--o{` | Exactamente uno a cero o más | Relación 1:N convencional |
| `\|o--o{` | Cero o uno a cero o más | Relación 1:N con nulabilidad en la foránea |
| `}o--o{` | Cero o más a cero o más | Relación M:N conceptual (resolver con tabla intermedia) |

**Ejemplo de relaciones con etiquetas:**

```plantuml
users ||--o{ orders : "places"
orders ||--|{ order_items : "contains"
products ||--o{ order_items : "referenced in"
```

---

## 🚀 Previsualización en Tiempo Real (Live Preview)

Para ver el diagrama mientras editas:

1. **Visual Studio Code:** Con la extensión **PlantUML** instalada, presiona
   `Alt + D` (o `Option + D` en macOS) dentro del archivo `.puml`.
2. **JetBrains IDEs:** Abre la pestaña lateral de **PlantUML** para renderizado
   instantáneo al guardar cambios.

---

## 📦 Compilación para el Reporte Final (PDF)

Para compilar todos los diagramas de base de datos a imágenes PNG, ejecuta en la
raíz del proyecto:

```bash
make db-diagrams
```

**¿Qué ocurre internamente?**

1. Docker inicia un contenedor con la imagen oficial de PlantUML.
2. Cada archivo `.puml` en `report/assets/diagram-sources/database-diagrams/` se
   compila a un archivo `.png` en `report/assets/database-diagrams/` con resolución
   de 300 DPI para impresión en el documento final.

---

## 📝 Inserción y Referencia en Capítulos Markdown (APA 7)

Para incluir el diagrama en cualquier capítulo del reporte (por ejemplo, en
`report/chapters/04-design/database-design.md`), usa la sintaxis estándar de figuras:

```markdown
![Modelo Físico de Base de Datos Relacional](assets/database-diagrams/database-model-example.png){#fig:database-physical-model}

_Note._ Esquema relacional implementado en PostgreSQL para el almacenamiento persistente del sistema.
```

Para referenciar la figura dentro del cuerpo del texto:

```markdown
Como se evidencia en la @fig:database-physical-model, la entidad principal mantiene una relación de uno a muchos...
```

---

## 💡 Buenas Prácticas

- **Fidelidad al motor:** Utiliza los tipos de datos exactos soportados por el
  motor relacional seleccionado (PostgreSQL, MySQL, Oracle, etc.), por ejemplo:
  `uuid`, `varchar(n)`, `timestamptz`, `numeric(p,s)`.
- **Modula esquemas grandes:** Si la base de datos excede 15 o 20 tablas, no
  fuerces todo en un solo diagrama ilegible. Crea un diagrama general y luego
  diagramas detallados por esquema o subsistema funcional.
- **Normalización:** Asegúrate de que el modelo refleje la tercera forma normal
  (3FN) o documenta explícitamente las decisiones de desnormalización si existen.
