# =============================================================================
# SCRIPT 03: Análisis de Expresión Diferencial
# Proyecto: Análisis de Expresión Génica Diferencial en Cáncer de Mama
# Autores: Grupo 4 - UNIR
# Fecha: 2025
# =============================================================================
# Descripción:
# Este script realiza el análisis de expresión diferencial entre muestras
# de tejido tumoral y tejido sano usando el paquete DESeq2.
# Se identifican los genes significativamente sobre y sub expresados.
# =============================================================================

# --- 1. Cargar librerías -----------------------------------------------------

library(DESeq2)
library(dplyr)

# --- 2. Cargar datos procesados ----------------------------------------------

message("Cargando datos normalizados...")

matriz_normalizada <- read.csv(
  "data/processed/matriz_expresion_normalizada.csv",
  row.names = 1,
  check.names = FALSE
)

metadata <- read.csv("data/metadata.csv", row.names = 1)

message("Datos cargados correctamente.")
message("  Genes    : ", nrow(matriz_normalizada))
message("  Muestras : ", ncol(matriz_normalizada))
