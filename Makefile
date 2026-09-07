PROJECT_NAME ?= upc-pre-[SEMESTER]-[NRC]-[GROUP]-report-[VERSION]
OUTPUT_DIR=build
PDF_DEFAULTS=pandoc/report.yaml

# Language metadata files
LANG_ES = pandoc/lang/es-ES.yaml
LANG_EN = pandoc/lang/en-US.yaml

CLASS_DIAGRAM_OUT = report/assets/class-diagrams
DB_DIAGRAM_OUT = report/assets/database-diagrams
C4_DIAGRAM_OUT = report/assets/c4-diagrams

# OS detection and platform-specific commands
ifeq ($(OS),Windows_NT)
    SHELL := cmd.exe
    FIX_PATH = $(subst /,\,$(1))
    MKDIR = if not exist "$(call FIX_PATH,$(1))" mkdir "$(call FIX_PATH,$(1))"
    RMDIR = if exist "$(call FIX_PATH,$(1))" rmdir /s /q "$(call FIX_PATH,$(1))"
    RMDIR_MINUS_P = if exist "-p" rmdir /s /q "-p"
else
    MKDIR = mkdir -p $(1)
    RMDIR = rm -rf $(1)
    RMDIR_MINUS_P = rm -rf ./-p
endif

MKDIR_OUTPUT = $(call MKDIR,$(OUTPUT_DIR))
MKDIR_CLASS_DIAGRAMS = $(call MKDIR,$(CLASS_DIAGRAM_OUT))
MKDIR_DB_DIAGRAMS = $(call MKDIR,$(DB_DIAGRAM_OUT))
MKDIR_C4_EXPORT = $(call MKDIR,$(C4_EXPORT_DIR))
MKDIR_C4_DIAGRAMS = $(call MKDIR,$(C4_DIAGRAM_OUT))
RMDIR_OUTPUT = $(call RMDIR,$(OUTPUT_DIR))

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

.PHONY: all pdf pdf-es pdf-en clean diagrams db-diagrams c4 single single-es single-en

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
	$(MKDIR_C4_EXPORT)
	$(DOCKER) -w "/app/report/assets/diagram-sources/c4-diagrams" structurizr/structurizr export -workspace "workspace.dsl" -format plantuml -output "/app/$(C4_EXPORT_DIR)"
	@echo Normalizando nombres de archivos PlantUML a kebab-case estándar...
	$(DOCKER) --entrypoint sh ghcr.io/plantuml/plantuml -c "tr -d '\r' < /app/report/assets/diagram-sources/c4-diagrams/normalize-c4.sh | sh"
	@echo Generando imágenes PNG de los diagramas C4...
	$(MKDIR_C4_DIAGRAMS)
	$(DOCKER) ghcr.io/plantuml/plantuml -DPLANTUML_LIMIT_SIZE=16384 -tpng -o "/app/$(C4_DIAGRAM_OUT)" "/app/$(C4_EXPORT_DIR)"
	@echo Limpiando imágenes de leyenda \(-key.png\) residuales si existen...
	$(DOCKER) --entrypoint sh ghcr.io/plantuml/plantuml -c "rm -f /app/$(C4_DIAGRAM_OUT)/*-key.png"
	@echo Done C4 diagrams.

pdf:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(PDF_FILES) -o $(PDF)

pdf-es:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) --metadata-file=$(LANG_ES) $(PDF_FILES) -o $(PDF)

pdf-en:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) --metadata-file=$(LANG_EN) $(PDF_FILES) -o $(PDF)

clean:
	$(RMDIR_OUTPUT)
	$(RMDIR_MINUS_P)

single:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) $(SRC) -o $(OUTPUT_DIR)/single-output.pdf

single-es:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) --metadata-file=$(LANG_ES) $(SRC) -o $(OUTPUT_DIR)/single-output.pdf

single-en:
	$(MKDIR_OUTPUT)
	$(PANDOC_DOCKER) --defaults=$(PDF_DEFAULTS) --metadata-file=$(LANG_EN) $(SRC) -o $(OUTPUT_DIR)/single-output.pdf