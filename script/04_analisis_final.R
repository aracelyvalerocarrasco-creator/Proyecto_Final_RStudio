###############################################################
# PROYECTO FINAL
# ANÁLISIS FINAL
###############################################################

# Autor: Aracely Valero Carrasco
# Curso: R studio
# Base de datos: RENIPRESS - SUSALUD
###############################################################
# LIBRERÍAS
###############################################################

library(tidyverse)
library(readr)
library(lubridate)
library(DescTools)
###############################################################
# IMPORTAR BASE DE DATOS
###############################################################

df <- read_delim(
  "data/RENIPRESS_30-04-2026.csv",
  delim = ";"
)

###############################################################
# LIMPIEZA DE DATOS
###############################################################

df <- df %>%
  select(
    -IMAGEN_1,
    -IMAGEN_2,
    -IMAGEN_3,
    -FE_ACT_IMAGEN_1,
    -FE_ACT_IMAGEN_2,
    -FE_ACT_IMAGEN_3
  )

df <- df %>%
  mutate(
    ANTIGUEDAD = 2026 - year(INICIO_ACTIVIDAD)
  ) %>%
  filter(ANTIGUEDAD >= 0)

###############################################################
# PREGUNTA DE INVESTIGACIÓN
###############################################################

# ¿Existe una asociación entre la institución que administra
# un establecimiento de salud y el estado de funcionamiento
# de los establecimientos registrados en RENIPRESS?

###############################################################
# METODOLOGÍA
###############################################################

# Tipo de estudio:
# Estudio descriptivo y asociativo de corte transversal.

# Base de datos:
# RENIPRESS (Registro Nacional de Instituciones Prestadoras
# de Servicios de Salud) de SUSALUD.

# Variables analizadas:
# - Institución administradora.
# - Estado del establecimiento de salud.

# Método de análisis:
# Se elaboró una tabla de contingencia para evaluar la
# distribución conjunta de ambas variables. Posteriormente,
# se aplicó la prueba Chi-cuadrado de independencia para
# determinar si existe una asociación estadísticamente
# significativa entre ellas. Finalmente, se calculó la
# V de Cramér para medir la intensidad de dicha asociación.
###############################################################
# OBJETIVO DEL ANÁLISIS
###############################################################

# Analizar si existe una relación entre la institución que
# administra un establecimiento de salud y el estado en que
# se encuentra registrado en la base de datos RENIPRESS.

###############################################################
# IMPORTANCIA DEL ANÁLISIS
###############################################################

# Este análisis permite identificar si el estado de los
# establecimientos de salud varía según la institución que
# los administra. Los resultados pueden contribuir a conocer
# diferencias en la gestión de los establecimientos y servir
# como apoyo para la toma de decisiones en el sector salud.

###############################################################
# TABLA DE CONTINGENCIA
###############################################################

tabla_ie <- table(df$INSTITUCION, df$ESTADO)

tabla_ie

###############################################################
# PRUEBA CHI-CUADRADO
###############################################################

chi <- chisq.test(tabla_ie)

chi

###############################################################
# V DE CRAMÉR
###############################################################

CramerV(tabla_ie)

###############################################################
# HALLAZGOS
###############################################################

# La prueba Chi-cuadrado obtuvo un p-valor menor a 0.05,
# evidenciando una asociación estadísticamente significativa
# entre la institución administradora y el estado de los
# establecimientos de salud.

# La V de Cramér fue de 0.1292, lo que indica que la
# intensidad de la asociación es débil.

# Además, se observó que las instituciones privadas y los
# gobiernos regionales concentran la mayor cantidad de
# establecimientos registrados, predominando el estado
# "Activo" en ambas instituciones.


###############################################################
# RESPUESTA A LA PREGUNTA DE INVESTIGACIÓN
###############################################################

# Sí, existe una asociación estadísticamente significativa
# entre la institución administradora y el estado de los
# establecimientos de salud registrados en RENIPRESS.

# No obstante, la intensidad de dicha asociación es débil,
# lo que sugiere que el estado de los establecimientos
# también puede estar relacionado con otros factores que
# no fueron analizados en este estudio.

###############################################################
# INTERPRETACIÓN
###############################################################

# La prueba Chi-cuadrado obtuvo un valor de X² = 3553.6
# con un p-valor < 2.2e-16.

# Como el p-valor es menor a 0.05, se rechaza la hipótesis
# nula de independencia.

# Esto indica que existe una asociación estadísticamente
# significativa entre la institución que administra un
# establecimiento de salud y su estado de funcionamiento.

# La V de Cramér fue de 0.1292, lo que representa una
# asociación de intensidad débil.
###############################################################
# CONCLUSIONES
###############################################################

# Se encontró evidencia de una asociación estadísticamente
# significativa entre la institución administradora y el
# estado de los establecimientos de salud registrados en
# RENIPRESS.

# La intensidad de esta asociación fue débil
# (V de Cramér = 0.1292), por lo que la relación observada
# es limitada desde el punto de vista práctico.

# Los resultados muestran que la distribución del estado
# de los establecimientos varía según la institución
# administradora; sin embargo, esta variable no explica
# por sí sola las diferencias observadas.

# Este análisis proporciona información útil para comprender
# el comportamiento de los establecimientos de salud y sirve
# como base para futuras investigaciones que incorporen
# otras variables relacionadas con su funcionamiento.