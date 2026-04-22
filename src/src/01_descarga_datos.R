r# =============================================================================
# SCRIPT 01: Descarga de datos desde GEO (NCBI)
# Proyecto: Análisis de Expresión Génica Diferencial en Cáncer de Mama
# Autores: Grupo 4 - UNIR
# Fecha: 22/04/2025
# =============================================================================
# Descripción:
# Este script descarga los datos de expresión génica del repositorio público
# GEO (Gene Expression Omnibus) usando el acceso GSE45827.
# Los datos corresponden a muestras de tejido tumoral y tejido sano de mama.
# =============================================================================

# --- 1. Instalar y cargar librerías necesarias -------------------------------

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!requireNamespace("GEOquery", quietly = TRUE))
