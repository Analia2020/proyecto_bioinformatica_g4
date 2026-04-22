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

# --- 3. Definir condiciones experimentales -----------------------------------

message("\nDefiniendo condiciones experimentales...")

# Clasificar muestras en: tumor vs. normal
# Se busca la columna que contiene el tipo de tejido
columna_condicion <- grep("tissue|condition|source", 
                          colnames(metadata), 
                          ignore.case = TRUE, 
                          value = TRUE)[1]

if (!is.na(columna_condicion)) {
  condiciones <- metadata[[columna_condicion]]
} else {
  # Si no se encuentra automáticamente, asignar manualmente
  message("  Columna de condición no detectada automáticamente.")
  message("  Asignando condiciones manualmente basado en el nombre de muestra...")
  condiciones <- ifelse(grepl("tumor|cancer|T", colnames(matriz_normalizada), 
                               ignore.case = TRUE), "tumor", "normal")
}

# Crear tabla de diseño experimental
diseno <- data.frame(
  muestra   = colnames(matriz_normalizada),
  condicion = factor(condiciones)
)

message("  Muestras por condición:")
print(table(diseno$condicion))

# --- 4. Crear objeto DESeq2 --------------------------------------------------

message("\nCreando objeto DESeq2...")

# Convertir a enteros (DESeq2 requiere conteos enteros)
conteos <- round(2^matriz_normalizada - 1)
conteos <- as.matrix(conteos)
storage.mode(conteos) <- "integer"

# Crear objeto DESeqDataSet
dds <- DESeqDataSetFromMatrix(
  countData = conteos,
  colData   = diseno,
  design    = ~ condicion
)

message("  Objeto DESeq2 creado exitosamente.")

# --- 5. Ejecutar análisis diferencial ----------------------------------------

message("\nEjecutando análisis de expresión diferencial...")
message("  Esto puede tardar unos minutos...")

dds <- DESeq(dds)

message("  Análisis completado.")

# --- 6. Extraer resultados ---------------------------------------------------

message("\nExtrayendo resultados...")

# Comparación: tumor vs. normal
resultados <- results(
  dds,
  contrast  = c("condicion", "tumor", "normal"),
  alpha     = 0.05
)

# Convertir a data frame y ordenar por p-valor ajustado
resultados_df <- as.data.frame(resultados) %>%
  tibble::rownames_to_column("gen") %>%
  arrange(padj)

message("  Resumen de resultados:")
summary(resultados)
