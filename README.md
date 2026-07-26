# Proyecto Final - Análisis Exploratorio y Análisis de Asociación con RENIPRESS

## Descripción

Este proyecto desarrolla un análisis exploratorio de datos (EDA) y un análisis de asociación utilizando la base de datos RENIPRESS (Registro Nacional de Instituciones Prestadoras de Servicios de Salud) de SUSALUD.

El estudio incluye la limpieza de datos, análisis descriptivo, visualizaciones estadísticas y una evaluación de la relación entre la institución administradora y el estado de los establecimientos de salud mediante la prueba Chi-cuadrado y la V de Cramér.


---
## Contexto del conjunto de datos

**Institución que proporciona los datos:**
SUSALUD (Superintendencia Nacional de Salud) es el organismo peruano encargado de proteger los derechos en salud de los ciudadanos y de supervisar el funcionamiento de las instituciones prestadoras de servicios de salud (IPRESS) a nivel nacional. RENIPRESS es su registro nacional de establecimientos de salud.


## Objetivo

Analizar la distribución de los establecimientos de salud registrados en RENIPRESS y determinar si existe una asociación entre la institución administradora y el estado del establecimiento.

RENIPRESS recopila información administrativa y operativa de todos los establecimientos de salud registrados en el Perú (hospitales, centros de salud, postas, clínicas, etc.), incluyendo su ubicación, tipo de institución administradora, categoría y estado de funcionamiento.

**Principales variables analizadas:**
- `institucion_administradora`: entidad que gestiona el establecimiento (MINSA, EsSalud, Gobierno Regional, Privado, etc.)
- `estado`: situación operativa del establecimiento (activo, inactivo, etc.)
- `departamento` / `provincia` / `distrito`: ubicación geográfica
- `categoria`: nivel de complejidad del establecimiento

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

1. **Análisis exploratorio de datos (EDA)**
   - Importación y limpieza de datos
   - Estadísticas descriptivas
   - Visualizaciones con ggplot2

2. **Análisis de asociación**
   - Tabla de contingencia
   - Prueba Chi-cuadrado
   - V de Cramér
   - Análisis de residuos estandarizados, para identificar en qué combinaciones institución-estado se concentra la asociación

---
## Pregunta de análisis

> **¿Existe una asociación entre la institución administradora y el estado operativo de los establecimientos de salud registrados en RENIPRESS, y en qué instituciones se concentra dicha asociación?**

Esta pregunta surge de un hallazgo del EDA: se observó que las instituciones privadas y los gobiernos regionales concentran la mayor cantidad de establecimientos, lo que motivó indagar si el tipo de institución administradora se relaciona con la probabilidad de que un establecimiento esté activo, dado de baja o cerrado.

---     
## Resultados principales

- Se identificó una asociación estadísticamente significativa entre la institución administradora y el estado del establecimiento (Chi-cuadrado, p < 0.05).
- La intensidad global de la asociación fue **débil** (V de Cramér = 0.1292).
- El análisis de residuos estandarizados mostró que esta asociación **no se distribuye de manera uniforme**, sino que se concentra principalmente en dos instituciones con comportamientos opuestos:
  - **Gobierno Regional:** muchos más establecimientos activos de lo esperado (residuo = +48.9) y muchos menos cierres temporales/bajas definitivas de lo esperado (residuos de -40.1 y -18.4).
  - **Privado:** patrón inverso — déficit marcado de establecimientos activos (residuo = -48.9) y exceso de cierres temporales de oficio (residuo = +45.4) y bajas definitivas (residuo = +13.6).
- Instituciones como **MINSA** y **EsSalud** se comportan cercanas a lo esperado bajo independencia (residuos pequeños), es decir, aportan poco a la asociación global.
- Las instituciones de sanidad de las Fuerzas Armadas y Policía Nacional muestran un patrón moderado, con exceso de bajas definitivas pero sin ser tan extremas como Privado o Gobierno Regional.

---
## Conclusiones

Respondiendo a la pregunta planteada: **sí existe una asociación estadísticamente significativa entre la institución administradora y el estado del establecimiento**, pero su magnitud global es débil (V de Cramér = 0.1292). Sin embargo, el análisis de residuos estandarizados permite ir más allá del estadístico global y muestra que esta asociación **no es un fenómeno uniforme entre todas las instituciones, sino que está impulsada principalmente por dos actores con comportamientos opuestos**: el Gobierno Regional, que concentra una proporción de establecimientos activos muy superior a la esperada por azar, y el sector Privado, que concentra una proporción de cierres temporales y bajas definitivas muy superior a la esperada.

Esto sugiere que las políticas de supervisión o mejora del estado operativo de los establecimientos de salud no deberían tratar a "la institución administradora" como un factor homogéneo, sino reconocer que el comportamiento del sector privado y el de los gobiernos regionales son estructuralmente distintos y merecen estrategias diferenciadas. Por el contrario, instituciones como MINSA y EsSalud —que concentran gran parte de la oferta pública de salud— no muestran desviaciones relevantes respecto a lo esperado, lo que indica que su estado operativo depende más de otros factores (ubicación, categoría, antigüedad, financiamiento) que de su naturaleza institucional en sí.

---

## Difusión
Los hallazgos finales fueron publicados en [LinkedIn/Twitter(X)]: [agrega aquí el link a tu publicación]

![Captura de publicación](figures/captura_publicacion.png)

---
## Repositorio
🔗 [Link a este repositorio en GitHub](AGREGA-AQUI-TU-LINK)

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
