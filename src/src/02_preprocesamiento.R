r# =============================================================================
# SCRIPT 02: Preprocesamiento y Control de Calidad
# Proyecto: Análisis de Expresión Génica Diferencial en Cáncer de Mama
# Autores: Grupo 4 - UNIR
# Fecha: 2025
# =============================================================================
# Descripción:
# Este script realiza el control de calidad de los datos crudos,
# filtra genes con baja expresión y normaliza la matriz de expresión
# para su uso en el análisis diferencial.
# =============================================================================

# --- 1. Cargar librerías -----------------------------------------------------

library(DESeq2)
library(dplyr)
library(ggplot2)

# --- 2. Cargar los datos crudos ----------------------------------------------

message("Cargando datos crudos...")

matriz_cruda <- read.csv(
  "data/raw/matriz_expresion_cruda.csv",
  row.names = 1,
  check.names = FALSE
)
