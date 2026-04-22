# =============================================================================
# SCRIPT 04: Visualizaciones
# Proyecto: Análisis de Expresión Génica Diferencial en Cáncer de Mama
# Autores: Grupo 4 - UNIR
# Fecha: 2025
# =============================================================================
# Descripción:
# Este script genera las visualizaciones principales del análisis:
#   1. Volcano Plot — genes sobre y sub expresados
#   2. Heatmap     — top 50 genes más variables
#   3. PCA         — separación entre grupos tumor/normal
# =============================================================================

# --- 1. Cargar librerías -----------------------------------------------------

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!requireNamespace("EnhancedVolcano", quietly = TRUE))
  BiocManager::install("EnhancedVolcano")

library(ggplot2)
library(pheatmap)
library(EnhancedVolcano)
library(dplyr)

# Crear directorio de figuras si no existe
dir_figuras <- "results/figures/"
if (!dir.exists(dir_figuras)) dir.create(dir_figuras, recursive = TRUE)

# --- 2. Cargar datos ---------------------------------------------------------

message("Cargando datos para visualización...")

# Resultados del análisis diferencial
resultados_df <- read.csv(
  "results/tables/todos_los_genes_resultados.csv",
  stringsAsFactors = FALSE
)

# Matriz normalizada
matriz_normalizada <- read.csv(
  "data/processed/matriz_expresion_normalizada.csv",
  row.names = 1,
  check.names = FALSE
)

# Metadatos
metadata <- read.csv("data/metadata.csv", row.names = 1)

message("Datos cargados correctamente.")
