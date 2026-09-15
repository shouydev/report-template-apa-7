# Guía de Diagramas de Clases (Diagrams-as-Code con PlantUML)

Este proyecto gestiona los diagramas de clases orientados a objetos mediante el
enfoque **Diagrams-as-Code** utilizando **PlantUML**. Este método garantiza que
los diagramas de diseño de software se mantengan versionados en Git, sean
fácilmente editables por el equipo y se compilen automáticamente a imágenes de
alta resolución para el reporte de tesis.

---

## 📁 Estructura de Archivos y Directorios

Los diagramas de clases se organizan de forma modular en archivos con extensión
`.puml`:

```text
report/assets/
├── diagram-sources/
│   └── class-diagrams/                     <-- Fuentes PlantUML (.puml)
│       ├── class-diagrams-guidelines.md    <-- Esta guía
│       └── domain-model-example.puml       <-- Ejemplo base de diagrama de clases
└── class-diagrams/                         <-- Salida generada por Docker (.png)
    └── domain-model-example.png
```

- **Fuentes (`diagram-sources/class-diagrams/`):** Almacena únicamente archivos
  `.puml` nombrados en formato `kebab-case` descriptivo (por ejemplo,
  `identity-domain-model.puml`, `catalog-class-diagram.puml`).
- **Salida (`report/assets/class-diagrams/`):** Directorio donde el motor de
  PlantUML exporta los archivos `.png` listos para ser referenciados en los
  capítulos en Markdown.

---

## 🛠️ Estándares de Modelado en PlantUML

Cada diagrama debe comenzar con `@startuml` y finalizar con `@enduml`. Para
garantizar la máxima legibilidad visual en la exportación PDF con formato APA 7,
sigue estas directrices de estilo y modelado.

### 1. Configuración de renderizado y estilo

Incluye los siguientes parámetros al inicio de cada archivo `.puml` para asegurar
alta resolución y nitidez tipográfica en la impresión:

```plantuml
@startuml
skinparam dpi 300
skinparam shadowing false
skinparam roundcorner 6
skinparam classAttributeIconSize 0
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 11
skinparam classHeaderBackgroundColor #F3F4F6
skinparam classBorderColor #4B5563
skinparam arrowColor #1F2937
```

### 2. Definición de clases, atributos y métodos

- **Visibilidad:** Usa los modificadores estándar de UML:
  - `+` Público (*public*)
  - `-` Privado (*private*)
  - `#` Protegido (*protected*)
  - `~` Paquete (*package-private*)
- **Tipado explícito:** Especifica siempre el tipo de dato de atributos y valores
  de retorno de métodos (`nombre : String`, `calcularTotal() : Double`).
- **Separadores:** Emplea `--` para separar atributos de métodos.

```plantuml
class User {
  - id: UUID
  - username: String
  - email: String
  - passwordHash: String
  - active: Boolean
  --
  + activate(): void
  + changePassword(newPass: String): Boolean
  + getEmail(): String
}

class Order {
  - id: UUID
  - orderDate: LocalDateTime
  - status: OrderStatus
  - totalAmount: BigDecimal
  --
  + addItem(item: OrderItem): void
  + cancel(): void
  + calculateTotal(): BigDecimal
}
```

### 3. Relaciones y multiplicidades UML

Utiliza las flechas canónicas de UML según el tipo de acoplamiento:

| Relación | Sintaxis PlantUML | Significado |
| :--- | :---: | :--- |
| **Herencia / Generalización** | `SuperClass <|-- SubClass` | Extensión de clase (*is-a*) |
| **Realización / Implementación** | `Interface <|.. Implementation` | Implementación de contrato |
| **Composición** | `Owner *-- "1..*" Component` | Pertenencia fuerte (ciclo de vida ligado) |
| **Agregación** | `Aggregate o-- "0..*" Member` | Pertenencia débil (ciclo de vida independiente) |
| **Asociación dirigida** | `Source --> "1" Target` | Conoce o navega hacia otra clase |
| **Dependencia** | `Consumer ..> Service` | Uso transitorio o como parámetro de método |

**Ejemplo de relaciones:**

```plantuml
interface PaymentMethod <<interface>> {
  + processPayment(amount: BigDecimal): Boolean
}

class CreditCardPayment implements PaymentMethod {
  - cardNumber: String
  - expirationDate: String
  + processPayment(amount: BigDecimal): Boolean
}

Order "1" *-- "1..*" OrderItem : contains
Order "1" --> "1" PaymentMethod : uses
Customer "1" o-- "0..*" Order : places
```

### 4. Modularidad por paquetes o Bounded Contexts

Si el sistema abarca múltiples subsistemas o capas (por ejemplo, Arquitectura
Limpia o DDD), agrupa las entidades en paquetes temáticos para preservar la
claridad:

```plantuml
package "Identity and Access Management" {
  class Account
  class Role
}

package "Billing and Orders" {
  class Invoice
  class Payment
}

Account "1" --> "0..*" Invoice : billed to
```

---

## 🚀 Previsualización en Tiempo Real (Live Preview)

Para iterar de manera rápida sin compilar todo el proyecto:

1. **Visual Studio Code:** Instala la extensión oficial **PlantUML** (de Jebbs).
   Abre cualquier archivo `.puml` y presiona `Alt + D` (o `Option + D` en macOS)
   para ver el diagrama renderizado en tiempo real mientras escribes.
2. **JetBrains IDEs:** El plugin **PlantUML Integration** ofrece un panel lateral
   con vista interactiva instantánea.

---

## 📦 Compilación para el Reporte Final (PDF)

Una vez que tus diagramas `.puml` estén actualizados, compila las imágenes PNG
ejecutando en la terminal raíz:

```bash
make class-diagrams
```

*(Nota: El comando alias `make diagrams` también está disponible por compatibilidad).*

**¿Qué ocurre internamente?**

1. Make invoca un contenedor Docker con la imagen oficial de PlantUML.
2. Cada archivo `.puml` ubicado en `report/assets/diagram-sources/class-diagrams/`
   se procesa y exporta como imagen PNG con resolución de 300 DPI a
   `report/assets/class-diagrams/`.

---

## 📝 Inserción y Referencia en Capítulos Markdown (APA 7)

Para incluir el diagrama en cualquier capítulo del reporte (por ejemplo, en
`report/chapters/04-design/class-model.md`), usa la sintaxis estándar de figuras:

```markdown
![Modelo de Clases del Dominio Principal](assets/class-diagrams/domain-model-example.png){#fig:class-domain-model}

_Note._ Diagrama de clases elaborado por los autores siguiendo principios de diseño guiado por el dominio (DDD).
```

Para referenciar la figura dentro del cuerpo del texto:

```markdown
En la @fig:class-domain-model se observan las relaciones estructurales entre las entidades principales del dominio...
```

---

## 💡 Buenas Prácticas

- **Divide y vencerás:** No intentes plasmar más de 15 o 20 clases en un único
  gráfico. Es preferible crear diagramas separados por módulo funcional o
  *Bounded Context*.
- **Evita dependencias redundantes:** Modela únicamente las relaciones que
  aportan valor arquitectónico; no satures el gráfico con flechas obvias de tipos
  primitivos.
- **Mantén sincronía con el código:** Valida periódicamente que los nombres de
  clases y métodos coincidan exactamente con la implementación del repositorio de
  software.
