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

# --- 4. Filtrado de genes con baja expresión ---------------------------------

message("\nFiltrando genes con baja expresión...")

# Mantener solo genes con expresión media > 1 en al menos el 20% de las muestras
umbral_expresion  <- 1
umbral_porcentaje <- 0.20

genes_activos <- rowSums(matriz_cruda > umbral_expresion) >=
  (ncol(matriz_cruda) * umbral_porcentaje)

matriz_filtrada <- matriz_cruda[genes_activos, ]

message("  Genes antes del filtrado : ", nrow(matriz_cruda))
message("  Genes después del filtrado: ", nrow(matriz_filtrada))
message("  Genes eliminados          : ", nrow(matriz_cruda) - nrow(matriz_filtrada))

# --- 5. Normalización --------------------------------------------------------

message("\nNormalizando datos...")

# Normalización log2 (añadir pseudoconteo de 1 para evitar log(0))
matriz_normalizada <- log2(matriz_filtrada + 1)

message("  Normalización log2 completada.")
message("  Rango de valores normalizados: ",
        round(min(matriz_normalizada), 2), " a ",
        round(max(matriz_normalizada), 2))

# --- 6. Guardar datos procesados ---------------------------------------------

dir_processed <- "data/processed/"
if (!dir.exists(dir_processed)) dir.create(dir_processed, recursive = TRUE)

ruta_normalizada <- file.path(dir_processed, "matriz_expresion_normalizada.csv")
write.csv(matriz_normalizada, file = ruta_normalizada, row.names = TRUE)
message("\nDatos normalizados guardados en: ", ruta_normalizada)

# --- 7. Resumen final --------------------------------------------------------

message("\n===== RESUMEN PREPROCESAMIENTO =====")
message("Genes originales   : ", nrow(matriz_cruda))
message("Genes filtrados    : ", nrow(matriz_filtrada))
message("Muestras analizadas: ", ncol(matriz_filtrada))
message("Normalización      : log2(x + 1)")
message("=====================================\n")

message("Script 02 completado exitosamente.")
