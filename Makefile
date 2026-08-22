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
PANDOC_DOCKER = docker run --rm -v "$(abspath .):/workspace" -w /workspace pandoc/extra:latest

# C4 Structurizr paths
C4_WORKSPACE_FILE = report/assets/diagram-sources/c4-diagrams/workspace.dsl
C4_EXPORT_DIR = report/assets/diagram-sources/c4-exported

.PHONY: all pdf clean diagrams db-diagrams c4 single

all: pdf c4 diagrams db-diagrams

diagrams:
	@echo Generating class diagrams from PlantUML sources...
	$(MKDIR_CLASS_DIAGRAMS)
	$(DOCKER) miyadav/plantuml:latest -tpng -o "/app/$(CLASS_DIAGRAM_OUT)" "/app/report/assets/diagram-sources/class-diagrams/*.puml"
	@echo Done.

db-diagrams:
	@echo Generating database diagrams from PlantUML sources...
	$(MKDIR_DB_DIAGRAMS)
	$(DOCKER) miyadav/plantuml:latest -tpng -o "/app/$(DB_DIAGRAM_OUT)" "/app/report/assets/diagram-sources/database-diagrams/*.puml"
	@echo Done.

c4:
	@echo Exportando modelo C4 DSL a PlantUML...
	$(DOCKER) structurizr/cli export -workspace "/app/$(C4_WORKSPACE_FILE)" -format plantuml -output "/app/$(C4_EXPORT_DIR)"
	@echo Generando imágenes PNG de los diagramas C4...
	$(DOCKER) miyadav/plantuml:latest -tpng -o "/app/report/assets/c4-diagrams" "/app/$(C4_EXPORT_DIR)/*.puml"
	@echo Done C4 diagrams.

pdf:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(PDF_FILES) -o $(PDF)

clean:
	$(RMDIR_OUTPUT)

single:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(SRC) -o $(OUTPUT_DIR)/single-output.pdf
