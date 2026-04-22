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

metadata <- read.csv("data/metadata.csv", row.names = 1)

message("Datos cargados:")
message("  Genes    : ", nrow(matriz_cruda))
message("  Muestras : ", ncol(matriz_cruda))

# --- 3. Control de calidad ---------------------------------------------------

message("\nRealizando control de calidad...")

# 3.1 Verificar valores faltantes
n_na <- sum(is.na(matriz_cruda))
message("  Valores faltantes (NA): ", n_na)

# 3.2 Distribución de la expresión antes de filtrar
message("  Resumen de expresión cruda:")
print(summary(as.vector(as.matrix(matriz_cruda))))

# 3.3 Guardar boxplot de control de calidad
dir_figuras <- "results/figures/"
if (!dir.exists(dir_figuras)) dir.create(dir_figuras, recursive = TRUE)

png(file.path(dir_figuras, "boxplot_calidad_crudo.png"),
    width = 1200, height = 600, res = 120)
boxplot(
  matriz_cruda[, 1:20],
  las = 2,
  cex.axis = 0.7,
  main = "Control de Calidad — Distribución de Expresión (primeras 20 muestras)",
  ylab = "log2(Expresión)",
  col = "lightblue"
)
dev.off()
message("  Boxplot guardado en: ", file.path(dir_figuras, "boxplot_calidad_crudo.png"))
