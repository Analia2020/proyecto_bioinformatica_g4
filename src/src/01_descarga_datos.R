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
  BiocManager::install("GEOquery")

library(GEOquery)

# --- 2. Definir parámetros del estudio ---------------------------------------

# Número de acceso en GEO
GEO_ID <- "GSE45827"

# Directorio donde se guardarán los datos crudos
dir_raw <- "data/raw/"

# Crear el directorio si no existe
if (!dir.exists(dir_raw)) {
  dir.create(dir_raw, recursive = TRUE)
  message("Directorio creado: ", dir_raw)
}

# --- 3. Descargar los datos desde GEO ----------------------------------------

message("Descargando datos de GEO: ", GEO_ID, "...")

gse <- getGEO(
  GEO = GEO_ID,
  destdir = dir_raw,
  GSEMatrix = TRUE,
  AnnotGPL = FALSE
)

message("Descarga completada.")
