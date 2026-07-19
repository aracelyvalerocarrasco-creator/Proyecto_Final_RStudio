# Proyecto Final - Análisis Exploratorio y Análisis de Asociación con RENIPRESS

## Descripción

Este proyecto desarrolla un análisis exploratorio de datos (EDA) y un análisis de asociación utilizando la base de datos RENIPRESS (Registro Nacional de Instituciones Prestadoras de Servicios de Salud) de SUSALUD.

El estudio incluye la limpieza de datos, análisis descriptivo, visualizaciones estadísticas y una evaluación de la relación entre la institución administradora y el estado de los establecimientos de salud mediante la prueba Chi-cuadrado y la V de Cramér.

---

## Objetivo

Analizar la distribución de los establecimientos de salud registrados en RENIPRESS y determinar si existe una asociación entre la institución administradora y el estado del establecimiento.

---

## Base de datos

- Fuente: SUSALUD – RENIPRESS
- Archivo: RENIPRESS_30-04-2026.csv

---

## Librerías utilizadas

- tidyverse
- readr
- janitor
- skimr
- patchwork
- viridis
- DescTools
- lubridate
- magick

---

## Metodología

El proyecto se desarrolló en dos etapas:

1. Análisis exploratorio de datos (EDA).
2. Análisis de asociación mediante:
   - Tabla de contingencia.
   - Prueba Chi-cuadrado.
   - V de Cramér.

---

## Resultados principales

- Se identificó una asociación estadísticamente significativa entre la institución administradora y el estado del establecimiento.
- La intensidad de la asociación fue débil (V de Cramér = 0.1292).
- Las instituciones privadas y los gobiernos regionales concentran la mayor cantidad de establecimientos registrados.

---

## Estructura del proyecto

```text
Proyecto_Final/
│
├── data/
├── figures/
├── collage/
├── script/
└── Proyecto_Final.Rproj
```

---

## Autor

**Aracely Valero Carrasco**

Universidad Nacional del Centro del Perú (UNCP)

Escuela Profesional de Economía
