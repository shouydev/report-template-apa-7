# Guía de Arquitectura C4 (Model-as-Code)

Este proyecto utiliza **Structurizr DSL** para gestionar los diagramas de arquitectura (C4 Model). A diferencia del enfoque tradicional de dibujar diagramas manualmente, aquí construimos un **modelo centralizado** del cual se generan automáticamente todas las vistas gráficas.

## 📁 Estructura Modular de Archivos

Para evitar un archivo maestro gigante y difícil de mantener, la arquitectura está dividida de forma modular. El archivo `workspace.dsl` actúa únicamente como un "índice" que une todas las piezas.

```text
c4-diagrams/
├── workspace.dsl               <-- (Archivo maestro. El Makefile solo lee este)
├── model/                      <-- (Definición de elementos del sistema)
│   ├── actors.dsl              <-- Usuarios y roles (Person)
│   ├── external-systems.dsl    <-- APIs o sistemas de terceros (SoftwareSystem)
│   └── systems/                
│       └── bussiness-core.dsl  <-- Contenedores y componentes internos
└── views/                      <-- (Definición de las vistas gráficas)
    ├── context-views.dsl       
    └── container-views.dsl     
```

## 🛠️ ¿Cómo colaborar en la arquitectura?

### 1. Agregar un nuevo Actor o Sistema Externo
Si necesitas agregar un nuevo tipo de usuario, abre `model/actors.dsl` e instáncialo:
```dsl
nuevo_rol = person "Nombre del Rol" "Descripción de lo que hace."
```
*(Nota: La variable `nuevo_rol` es la que usarás luego para conectarlo con flechas).*

### 2. Agregar un nuevo Contenedor (Base de datos, API, etc.)
Ve a `model/systems/viora-core.dsl` (o el sistema correspondiente) y agrégalo dentro del bloque del sistema:
```dsl
mi_nueva_db = container "Base de Datos Analítica" "Almacena logs" "MongoDB" "Database"
```

### 3. Crear Relaciones (Flechas)
Las relaciones (quién se comunica con quién) se definen preferiblemente en el archivo maestro `workspace.dsl` o en un archivo dedicado `relationships.dsl` para mantener el contexto global:
```dsl
nuevo_rol -> mi_nueva_db "Consulta métricas en" "TCP/IP"
```

## 🚀 ¿Cómo previsualizar mientras trabajo? (Live Reload)

Escribir código a ciegas es ineficiente. Para ver tu diagrama actualizarse en **tiempo real** cada vez que guardas un archivo, levanta el servidor local de Structurizr Lite usando Docker.

Abre tu terminal en la raíz del proyecto y ejecuta:
```bash
docker run -it --rm -p 8080:8080 -v "$PWD/report/assets/diagram-sources/c4-diagrams:/usr/local/structurizr" structurizr/lite
```
Luego, abre tu navegador en **http://localhost:8080**.

## 📦 Compilación para el Reporte Final (PDF)

Una vez que tu código esté listo y guardado, debes exportar el modelo a imágenes `.png` para que Pandoc pueda incrustarlas en el PDF final. 

Ejecuta el siguiente comando en la raíz del proyecto:
```bash
make c4
```
**¿Qué ocurre internamente?**
1. Docker exporta tu modelo a código `.puml` temporal en `c4-exported/`.
2. Docker invoca a PlantUML para renderizar las imágenes `.png` definitivas en `report/assets/c4-diagrams/`.
3. Tu reporte PDF leerá directamente estas imágenes finales.
