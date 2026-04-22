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

# --- 3. VOLCANO PLOT ---------------------------------------------------------

message("\nGenerando Volcano Plot...")

png(file.path(dir_figuras, "volcano_plot.png"),
    width = 1400, height = 1000, res = 150)

EnhancedVolcano(
  resultados_df,
  lab            = resultados_df$gen,
  x              = "log2FoldChange",
  y              = "pvalue",
  title          = "Expresión Diferencial — Tumor vs. Normal",
  subtitle       = "Cáncer de Mama (GSE45827)",
  xlab           = bquote(~Log[2]~ "Fold Change"),
  ylab           = bquote(~-Log[10]~ "p-valor"),
  pCutoff        = 0.05,
  FCcutoff       = 1.0,
  pointSize      = 2.5,
  labSize        = 3.5,
  col            = c("grey70", "#56B4E9", "#E69F00", "#CC0000"),
  colAlpha       = 0.6,
  legendLabels   = c("No significativo", "Solo FC", "Solo p-valor", "Significativo"),
  legendPosition = "right",
  drawConnectors = TRUE,
  widthConnectors = 0.4
)

dev.off()
message("  Volcano plot guardado.")

# --- 4. HEATMAP --------------------------------------------------------------

message("\nGenerando Heatmap...")

# Seleccionar los top 50 genes más variables
varianza_genes <- apply(matriz_normalizada, 1, var)
top50_genes    <- names(sort(varianza_genes, decreasing = TRUE))[1:50]
matriz_top50   <- matriz_normalizada[top50_genes, ]

# Preparar anotación de columnas (condición de cada muestra)
columna_condicion <- grep("tissue|condition|source",
                          colnames(metadata),
                          ignore.case = TRUE,
                          value = TRUE)[1]

if (!is.na(columna_condicion)) {
  anotacion_col <- data.frame(
    Condicion = metadata[[columna_condicion]],
    row.names = rownames(metadata)
  )
} else {
  anotacion_col <- data.frame(
    Condicion = ifelse(grepl("tumor|T", colnames(matriz_top50),
                              ignore.case = TRUE), "Tumor", "Normal"),
    row.names = colnames(matriz_top50)
  )
}

# Colores para la anotación
colores_anotacion <- list(
  Condicion = c(Tumor = "#CC0000", Normal = "#56B4E9")
)

png(file.path(dir_figuras, "heatmap_top50_genes.png"),
    width = 1600, height = 1400, res = 150)

pheatmap(
  matriz_top50,
  annotation_col  = anotacion_col,
  annotation_colors = colores_anotacion,
  scale           = "row",
  clustering_distance_rows = "euclidean",
  clustering_distance_cols = "euclidean",
  clustering_method = "complete",
  color           = colorRampPalette(c("#2166AC", "white", "#CC0000"))(100),
  show_rownames   = TRUE,
  show_colnames   = FALSE,
  fontsize_row    = 7,
  main            = "Heatmap — Top 50 Genes Más Variables\nCáncer de Mama (GSE45827)",
  border_color    = NA
)

dev.off()
message("  Heatmap guardado.")

# --- 5. PCA ------------------------------------------------------------------

message("\nGenerando PCA...")

# Transponer la matriz (muestras en filas para PCA)
matriz_t <- t(matriz_normalizada)

# Calcular PCA
pca_resultado <- prcomp(matriz_t, scale. = TRUE, center = TRUE)

# Extraer varianza explicada
varianza_explicada <- summary(pca_resultado)$importance[2, ] * 100
pc1_var <- round(varianza_explicada[1], 1)
pc2_var <- round(varianza_explicada[2], 1)

# Crear data frame para graficar
pca_df <- data.frame(
  PC1       = pca_resultado$x[, 1],
  PC2       = pca_resultado$x[, 2],
  Muestra   = rownames(pca_resultado$x)
)

# Agregar condición
if (!is.na(columna_condicion)) {
  pca_df$Condicion <- metadata[rownames(pca_df), columna_condicion]
} else {
  pca_df$Condicion <- ifelse(grepl("tumor|T", pca_df$Muestra,
                                    ignore.case = TRUE), "Tumor", "Normal")
}

# Graficar PCA
grafico_pca <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Condicion)) +
  geom_point(size = 3.5, alpha = 0.8) +
  scale_color_manual(values = c("Tumor" = "#CC0000", "Normal" = "#56B4E9")) +
  labs(
    title    = "Análisis de Componentes Principales (PCA)",
    subtitle = "Cáncer de Mama — Tumor vs. Normal (GSE45827)",
    x        = paste0("PC1 (", pc1_var, "% varianza explicada)"),
    y        = paste0("PC2 (", pc2_var, "% varianza explicada)"),
    color    = "Condición"
  ) +
  theme_bw(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "grey50"),
    legend.position = "right"
  ) +
  stat_ellipse(aes(group = Condicion), level = 0.95, linetype = "dashed")

ggsave(
  filename = file.path(dir_figuras, "PCA_tumor_vs_normal.png"),
  plot     = grafico_pca,
  width    = 10, height = 7, dpi = 150
)

message("  PCA guardado.")

# --- 6. Resumen final --------------------------------------------------------

message("\n===== VISUALIZACIONES GENERADAS =====")
message("1. Volcano plot : results/figures/volcano_plot.png")
message("2. Heatmap      : results/figures/heatmap_top50_genes.png")
message("3. PCA          : results/figures/PCA_tumor_vs_normal.png")
message("=====================================")
message("Script 04 completado exitosamente.")
