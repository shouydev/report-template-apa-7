PROJECT_NAME ?= upc-pre-[SEMESTER]-[NRC]-[GROUP]-report-[VERSION]
OUTPUT_DIR=build
PDF_DEFAULTS=pandoc/report.yaml

CLASS_DIAGRAM_OUT = report/assets/class-diagrams
DB_DIAGRAM_OUT = report/assets/database-diagrams

MKDIR_OUTPUT = mkdir -p $(OUTPUT_DIR)
MKDIR_CLASS_DIAGRAMS = mkdir -p $(CLASS_DIAGRAM_OUT)
MKDIR_DB_DIAGRAMS = mkdir -p $(DB_DIAGRAM_OUT)
RMDIR_OUTPUT = rm -rf $(OUTPUT_DIR)

# PDF files
FRONT_MATTER = $(sort $(wildcard report/front-matter/*.md))
CHAPTERS = $(sort $(wildcard report/chapters/*/*.md))
BACK_MATTER = $(sort $(wildcard report/back-matter/*.md))
ANNEXES = $(sort $(wildcard report/annexes/*.md))

# PDF configuration
PDF_FILES = $(FRONT_MATTER) $(CHAPTERS) $(BACK_MATTER) $(ANNEXES)
PDF=$(OUTPUT_DIR)/$(PROJECT_NAME).pdf

# Docker configuration
DOCKER = docker run --rm -v "$(abspath .):/app" -w /app
PANDOC_DOCKER = docker run --rm -v "$(abspath .):/workspace" -w /workspace pandoc/extra:3.8.3

# C4 Structurizr paths
C4_WORKSPACE_FILE = report/assets/diagram-sources/c4-diagrams/workspace.dsl
C4_EXPORT_DIR = report/assets/diagram-sources/c4-exported

.PHONY: all pdf clean diagrams db-diagrams c4 single

all: pdf c4 diagrams db-diagrams

diagrams:
	@echo Generating class diagrams from PlantUML sources...
	$(MKDIR_CLASS_DIAGRAMS)
	$(DOCKER) ghcr.io/plantuml/plantuml -tpng -o "/app/$(CLASS_DIAGRAM_OUT)" "/app/report/assets/diagram-sources/class-diagrams/*.puml"
	@echo Done.

db-diagrams:
	@echo Generating database diagrams from PlantUML sources...
	$(MKDIR_DB_DIAGRAMS)
	$(DOCKER) ghcr.io/plantuml/plantuml -tpng -o "/app/$(DB_DIAGRAM_OUT)" "/app/report/assets/diagram-sources/database-diagrams/*.puml"
	@echo Done.

c4:
	@echo Exportando modelo C4 DSL a PlantUML...
	$(DOCKER) -w "/app/report/assets/diagram-sources/c4-diagrams" structurizr/structurizr export -workspace "workspace.dsl" -format plantuml -output "/app/$(C4_EXPORT_DIR)"
	@echo Eliminando archivos de leyenda \(-key.puml\)...
	rm -f $(C4_EXPORT_DIR)/*-key.puml
	@echo Normalizando nombres de archivos PlantUML a kebab-case estándar...
	@test -f $(C4_EXPORT_DIR)/structurizr-SystemContext.puml && mv -f $(C4_EXPORT_DIR)/structurizr-SystemContext.puml $(C4_EXPORT_DIR)/context-level-diagram-atelier.puml || true
	@test -f $(C4_EXPORT_DIR)/structurizr-Containers.puml && mv -f $(C4_EXPORT_DIR)/structurizr-Containers.puml $(C4_EXPORT_DIR)/container-level-diagram-atelier.puml || true
	@test -f $(C4_EXPORT_DIR)/structurizr-Components-API.puml && mv -f $(C4_EXPORT_DIR)/structurizr-Components-API.puml $(C4_EXPORT_DIR)/component-level-diagram-api.puml || true
	@test -f $(C4_EXPORT_DIR)/structurizr-Components-WebApp.puml && mv -f $(C4_EXPORT_DIR)/structurizr-Components-WebApp.puml $(C4_EXPORT_DIR)/component-level-diagram-webapp.puml || true
	@test -f $(C4_EXPORT_DIR)/structurizr-Deployment-Production.puml && mv -f $(C4_EXPORT_DIR)/structurizr-Deployment-Production.puml $(C4_EXPORT_DIR)/deployment-diagram-atelier.puml || true
	@for f in $(C4_EXPORT_DIR)/structurizr-*.puml; do \
		if [ -f "$$f" ]; then \
			target=$$(basename "$$f" | sed 's/^structurizr-//'); \
			mv -f "$$f" "$(C4_EXPORT_DIR)/$$target"; \
		fi \
	done
	@echo Generando imágenes PNG de los diagramas C4...
	$(DOCKER) ghcr.io/plantuml/plantuml -DPLANTUML_LIMIT_SIZE=16384 -tpng -o "/app/report/assets/c4-diagrams" "/app/$(C4_EXPORT_DIR)"
	@echo Limpiando imágenes de leyenda \(-key.png\) residuales si existen...
	rm -f report/assets/c4-diagrams/*-key.png
	@echo Done C4 diagrams.

pdf:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(PDF_FILES) -o $(PDF)

clean:
	$(RMDIR_OUTPUT)

single:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(SRC) -o $(OUTPUT_DIR)/single-output.pdf