# Proyecto Bioinformatica G4
Este repositorio contiene el desarrollo de la actividad grupal correspondiente a la asignatura Introducción Programación Científica. El objetivo del proyecto es aplicar los conceptos teóricos y prácticos vistos en la materia mediante la resolución de un problema concreto, utilizando herramientas de programación científica y buenas prácticas de desarrollo.
# 🧬 Análisis de Expresión Génica Diferencial en Cáncer de Mama (RNA-Seq)

![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-yellow)
![Licencia](https://img.shields.io/badge/Licencia-MIT-blue)
![R](https://img.shields.io/badge/R-4.0%2B-276DC3?logo=r)
![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?logo=python)

## 📋 Descripción del Proyecto

Este repositorio contiene el pipeline completo para el análisis de expresión génica diferencial en muestras de cáncer de mama utilizando datos de secuenciación de ARN (RNA-Seq). Los datos provienen del repositorio público **GEO (Gene Expression Omnibus)** del NCBI.

El objetivo principal es identificar genes diferencialmente expresados (DEGs) entre tejido tumoral y tejido sano, utilizando herramientas bioinformáticas.

---

## 🎯 Objetivos

- Descargar y preprocesar datos de RNA-Seq de acceso público (GEO)
- Realizar control de calidad de las lecturas crudas
- Normalizar los datos de expresión génica
- Identificar genes diferencialmente expresados con **DESeq2**
- Visualizar los resultados mediante volcano plots, heatmaps y PCA
- Documentar el pipeline de forma reproducible

---

## 🗂️ Estructura del Repositorio
proyecto_bioinformatica_g4/
│
├── 📁 data/                    # Datos del proyecto
│   ├── raw/                    # Datos crudos descargados de GEO
│   ├── processed/              # Datos normalizados y filtrados
│   └── metadata.csv            # Información de las muestras
│
├── 📁 src/                     # Scripts del análisis
│   ├── 01_descarga_datos.R     # Descarga de datos desde GEO
│   ├── 02_preprocesamiento.R   # Control de calidad y normalización
│   ├── 03_expresion_diferencial.R  # Análisis DESeq2
│   └── 04_visualizacion.R      # Volcano plot, heatmap, PCA
│
├── 📁 notebooks/               # Notebooks explicativos
│   └── analisis_exploratorio.ipynb
│
├── 📁 results/                 # Resultados generados
│   ├── figures/                # Gráficos y visualizaciones
│   └── tables/                 # Tablas de genes diferenciales
│
├── 📁 docs/                    # Documentación adicional
│   └── informe_analisis.md     # Informe del análisis
│
├── README.md                   # Este archivo
├── LICENSE                     # Licencia MIT
└── .gitignore                  # Archivos ignorados por Git

---

## 🔬 Dataset Utilizado

| Campo | Información |
|-------|-------------|
| **Fuente** | NCBI Gene Expression Omnibus (GEO) |
| **Acceso** | GSE45827 |
| **Organismo** | *Homo sapiens* |
| **Tipo de datos** | RNA-Seq (mRNA) |
| **Condiciones** | Tejido tumoral vs. tejido sano |
| **Número de muestras** | 130 muestras |

---
