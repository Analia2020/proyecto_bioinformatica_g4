# Informe de Análisis — Expresión Génica Diferencial en Cáncer de Mama

**Proyecto:** Análisis RNA-Seq - Grupo 4  
**Asignatura:** Introducción a la Programación Científica - UNIR  
**Fecha:** 22/04/2026  

---

## 1. Introducción

El cáncer de mama es el tipo de cáncer más frecuente en mujeres a nivel mundial. 
Comprender qué genes están diferencialmente expresados entre tejido tumoral y tejido 
sano es fundamental para identificar biomarcadores diagnósticos y posibles dianas 
terapéuticas.

En este análisis utilizamos datos de secuenciación de ARN (RNA-Seq) del repositorio 
público **GEO (Gene Expression Omnibus)** del NCBI, específicamente el dataset 
**GSE45827**, que contiene muestras de tejido mamario tumoral y sano.

---

## 2. Dataset

| Parámetro | Detalle |
|-----------|---------|
| **GEO ID** | GSE45827 |
| **Organismo** | *Homo sapiens* |
| **Tipo de datos** | RNA-Seq (mRNA) |
| **Plataforma** | Illumina HiSeq 2000 |
| **Muestras tumorales** | 15 |
| **Muestras normales** | 10 |
| **Total muestras** | 25 |
| **Subtipos tumorales** | Luminal A, Luminal B, HER2+, Triple negativo |

---

## 3. Pipeline de Análisis

### 3.1 Descarga de datos
Los datos fueron descargados directamente desde GEO usando el paquete 
`GEOquery` de Bioconductor en R. Se descargó la matriz de expresión 
completa junto con los metadatos de cada muestra.

### 3.2 Preprocesamiento y Control de Calidad
Se aplicaron los siguientes pasos:

- Verificación de valores faltantes (NA)
- Filtrado de genes con baja expresión (expresión media < 1 en más del 80% de las muestras)
- Normalización logarítmica: `log2(x + 1)`
- Visualización de la distribución mediante boxplots

### 3.3 Análisis de Expresión Diferencial
Se utilizó el paquete **DESeq2** para identificar genes diferencialmente 
expresados entre las condiciones tumor y normal.

**Criterios de significancia:**
- p-valor ajustado (FDR) < 0.05
- |log2 Fold Change| > 1

### 3.4 Visualizaciones
Se generaron tres visualizaciones principales:

1. **Volcano Plot:** muestra todos los genes según su fold change y significancia estadística
2. **Heatmap:** muestra los top 50 genes más variables con clustering jerárquico
3. **PCA:** evalúa la separación entre muestras tumorales y normales

---

## 4. Resultados

### 4.1 Genes Diferencialmente Expresados

Tras aplicar los criterios de significancia se identificaron genes 
diferencialmente expresados, clasificados en:

- **Sobreexpresados en tumor:** genes con log2FC > 1 (mayor actividad en tejido tumoral)
- **Subexpresados en tumor:** genes con log2FC < -1 (menor actividad en tejido tumoral)

Los resultados completos se encuentran en:
- `results/tables/todos_los_genes_resultados.csv`
- `results/tables/genes_diferenciales_significativos.csv`
- `results/tables/top20_sobreexpresados.csv`
- `results/tables/top20_subexpresados.csv`

### 4.2 Visualizaciones Generadas

Las figuras se encuentran en `results/figures/`:

| Figura | Archivo | Descripción |
|--------|---------|-------------|
| Volcano Plot | `volcano_plot.png` | Distribución de genes por FC y p-valor |
| Heatmap | `heatmap_top50_genes.png` | Patrones de expresión top 50 genes |
| PCA | `PCA_tumor_vs_normal.png` | Separación entre grupos experimentales |

---

## 5. Herramientas Utilizadas

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| R | 4.0+ | Lenguaje principal del análisis |
| DESeq2 | 1.38+ | Análisis de expresión diferencial |
| GEOquery | 2.66+ | Descarga de datos desde GEO |
| ggplot2 | 3.4+ | Visualizaciones |
| pheatmap | 1.0.12 | Generación del heatmap |
| EnhancedVolcano | 1.16+ | Volcano plot |

---

## 6. Conclusiones

El análisis de expresión génica diferencial mediante RNA-Seq permite 
identificar de forma sistemática los genes que presentan cambios 
significativos de expresión entre tejido tumoral y tejido sano en 
cáncer de mama.

Este pipeline es completamente reproducible y puede adaptarse a otros 
tipos de cáncer o condiciones experimentales modificando el GEO ID 
en el script de descarga.

---

## 7. Referencias

1. Love MI, Huber W, Anders S. *Moderated estimation of fold change and 
   dispersion for RNA-seq data with DESeq2*. Genome Biology, 2014.
2. Davis S, Meltzer PS. *GEOquery: a bridge between the Gene Expression 
   Omnibus (GEO) and BioConductor*. Bioinformatics, 2007.
3. NCBI GEO Dataset GSE45827. Disponible en: 
   https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE45827

---

*Informe generado como parte de la actividad grupal de la asignatura 
Introducción a la Programación Científica - UNIR 2025*
