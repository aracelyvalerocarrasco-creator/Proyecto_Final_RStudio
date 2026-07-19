###############################################################
# PROYECTO FINAL
# ANÁLISIS EXPLORATORIO DE DATOS (EDA)
###############################################################

# Autor: Aracely Valero Carrasco
# Carrera: Economía
# Universidad: Universidad Nacional del Centro del Perú
# Curso: R para Ciencia de Datos
# Base de datos: RENIPRESS (SUSALUD)
# Fecha: Julio 2026

###############################################################
# CONTEXTO DEL PROYECTO
###############################################################

# ¿Qué es RENIPRESS?
# RENIPRESS es el Registro Nacional de Instituciones Prestadoras
# de Servicios de Salud administrado por la Superintendencia
# Nacional de Salud (SUSALUD).

# Objetivo del proyecto
# Realizar un Análisis Exploratorio de Datos (EDA) para conocer
# cómo se distribuyen los establecimientos de salud registrados
# en el Perú utilizando información oficial.

# ¿Qué analizaremos?
# - Departamento
# - Provincia
# - Distrito
# - Categoría del establecimiento
# - Institución
# - Estado
# - Fecha de inicio de actividades

###############################################################
# LIBRERÍAS
###############################################################

# ¿Qué hace este bloque?
# Instala (solo la primera vez) y carga los paquetes que
# utilizaremos durante todo el análisis.

# Instalar paquetes (solo ejecutar una vez)

install.packages("tidyverse")
install.packages("readr")
install.packages("janitor")
install.packages("skimr")
install.packages("patchwork")
install.packages("viridis")
install.packages("DescTools")
install.packages("magick")

# Cargar librerías

library(tidyverse)
library(readr)
library(janitor)
library(skimr)
library(patchwork)
library(viridis)
library(DescTools)

###############################################################
# IMPORTACIÓN DE LA BASE DE DATOS
###############################################################

# ¿Qué hace este bloque?
# Importa la base de datos oficial RENIPRESS ubicada en la
# carpeta "data" del proyecto.

# Leer la base de datos

df <- read_delim(
  "data/RENIPRESS_30-04-2026.csv",
  delim = ";"
)

head(df)

###############################################################
# EXPLORACIÓN INICIAL DE LA BASE DE DATOS
###############################################################

# ¿Qué hace este bloque?
# Permite conocer el tamaño, la estructura y las variables
# de la base de datos antes de iniciar el análisis.

# Dimensiones de la base de datos
dim(df)

# Nombre de las variables
names(df)

# Estructura de la base de datos
str(df)

# Resumen estadístico
summary(df)

# Vista general de las variables
glimpse(df)

###############################################################
# CALIDAD DE LOS DATOS
###############################################################

# ¿Cuántos valores perdidos (NA) tiene cada variable?

colSums(is.na(df))

# ¿Existen registros duplicados?

sum(duplicated(df))

# Frecuencia de establecimientos por estado

table(df$ESTADO)

###############################################################
# LIMPIEZA DE DATOS
###############################################################

# ¿Qué hace este bloque?
# Elimina variables que no serán utilizadas en el análisis
# para trabajar con una base más limpia.

df <- df %>%
  select(
    -IMAGEN_1,
    -IMAGEN_2,
    -IMAGEN_3,
    -FE_ACT_IMAGEN_1,
    -FE_ACT_IMAGEN_2,
    -FE_ACT_IMAGEN_3
  )

# Verificar el nuevo número de variables

dim(df)

###############################################################
# CREACIÓN DE NUEVAS VARIABLES
###############################################################

# ¿Qué hace este bloque?
# Calcula la antigüedad (en años) de cada establecimiento
# tomando como referencia el año 2026.

df <- df %>%
  mutate(
    ANTIGUEDAD = 2026 - lubridate::year(INICIO_ACTIVIDAD)
  )

# Verificar la nueva variable

head(df$ANTIGUEDAD)

###############################################################
# REVISIÓN DE LA VARIABLE ANTIGÜEDAD
###############################################################

# ¿Existen antigüedades negativas?

sum(df$ANTIGUEDAD < 0, na.rm = TRUE)

# Mostrar los registros con antigüedad negativa

df %>%
  filter(ANTIGUEDAD < 0)

###############################################################
# CORRECCIÓN DE DATOS ERRÓNEOS
###############################################################

# ¿Qué hace este bloque?
# Elimina los registros con antigüedad negativa debido a
# que corresponden a fechas incorrectas.

df <- df %>%
  filter(ANTIGUEDAD >= 0)

# Verificar el nuevo tamaño de la base

dim(df)

# Confirmar que ya no existen antigüedades negativas

sum(df$ANTIGUEDAD < 0)

###############################################################
# RESUMEN DE ESTABLECIMIENTOS POR DEPARTAMENTO
###############################################################

# ¿Qué hace este bloque?
# Cuenta la cantidad y el porcentaje de establecimientos
# registrados en cada departamento.

resumen_departamento <- df %>%
  count(DEPARTAMENTO, name = "Cantidad") %>%
  mutate(
    Porcentaje = round(Cantidad / sum(Cantidad) * 100, 2)
  ) %>%
  arrange(desc(Cantidad))

# Visualizar la tabla

resumen_departamento

###############################################################
# EXPORTAR TABLA
###############################################################

write.csv(
  resumen_departamento,
  "figures/resumen_departamento.csv",
  row.names = FALSE
)


###############################################################
# TOP 15 DEPARTAMENTOS CON MÁS ESTABLECIMIENTOS
###############################################################

top15 <- resumen_departamento %>%
  slice_max(
    order_by = Cantidad,
    n = 15
  )

ggplot(
  top15,
  aes(
    x = reorder(DEPARTAMENTO, Cantidad),
    y = Cantidad,
    fill = Cantidad
  )
) +
  geom_col(width = 0.75) +
  geom_text(
    aes(label = scales::comma(Cantidad)),
    hjust = -0.2,
    size = 4
  ) +
  coord_flip() +
  scale_fill_viridis_c(option = "C") +
  labs(
    title = "Top 15 departamentos con mayor número de establecimientos",
    subtitle = "RENIPRESS - SUSALUD (2026)",
    x = NULL,
    y = "Número de establecimientos"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    panel.grid.major.y = element_blank()
  )

###############################################################
# RESUMEN POR DEPARTAMENTO
###############################################################

resumen_departamento <- df %>%
  group_by(DEPARTAMENTO) %>%
  summarise(
    Establecimientos = n(),
    Porcentaje = round(n() / nrow(df) * 100, 2)
  ) %>%
  arrange(desc(Establecimientos))

resumen_departamento

write.csv(
  resumen_departamento,
  "figures/resumen_departamento.csv",
  row.names = FALSE
)

###############################################################
# TOP 15 DEPARTAMENTOS
###############################################################

top15 <- resumen_departamento %>%
  slice_head(n = 15)

ggplot(
  top15,
  aes(
    x = reorder(DEPARTAMENTO, Establecimientos),
    y = Establecimientos,
    fill = Establecimientos
  )
) +
  geom_col(width = .75) +
  geom_text(
    aes(label = Establecimientos),
    hjust = -0.15,
    fontface = "bold",
    size = 4
  ) +
  coord_flip() +
  scale_fill_viridis_c(option = "C") +
  expand_limits(y = max(top15$Establecimientos) * 1.08) +
  labs(
    title = "Top 15 departamentos con mayor número de establecimientos",
    subtitle = "Fuente: RENIPRESS - SUSALUD",
    x = NULL,
    y = "Número de establecimientos"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

###############################################################
# ANÁLISIS ESPECÍFICO DEL DEPARTAMENTO DE JUNÍN
###############################################################

junin <- df %>%
  filter(DEPARTAMENTO == "JUNIN")

resumen_junin <- junin %>%
  count(PROVINCIA, name = "Establecimientos") %>%
  mutate(
    Porcentaje = round(
      Establecimientos / sum(Establecimientos) * 100,
      2
    )
  ) %>%
  arrange(desc(Establecimientos))

resumen_junin

write.csv(
  resumen_junin,
  "figures/resumen_junin.csv",
  row.names = FALSE
)

###############################################################
# ESTABLECIMIENTOS POR PROVINCIA - JUNÍN
###############################################################

ggplot(
  resumen_junin,
  aes(
    x = reorder(PROVINCIA, Establecimientos),
    y = Establecimientos,
    fill = Establecimientos
  )
) +
  geom_col(width = .75) +
  geom_text(
    aes(label = Establecimientos),
    hjust = -0.15,
    size = 4,
    fontface = "bold"
  ) +
  coord_flip() +
  scale_fill_viridis_c(option = "B") +
  expand_limits(y = max(resumen_junin$Establecimientos) * 1.10) +
  labs(
    title = "Distribución de establecimientos por provincia",
    subtitle = "Departamento de Junín",
    x = NULL,
    y = "Número de establecimientos"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

###############################################################
# HEATMAP: PROVINCIA VS CATEGORÍA (JUNÍN)
###############################################################

# ¿Qué hace este bloque?
# Muestra la distribución de las categorías de establecimientos
# en cada provincia del departamento de Junín.

heatmap_junin <- junin %>%
  count(PROVINCIA, CATEGORIA)

ggplot(
  heatmap_junin,
  aes(
    x = CATEGORIA,
    y = reorder(PROVINCIA, -n),
    fill = n
  )
) +
  geom_tile(color = "white", linewidth = 0.4) +
  geom_text(
    aes(label = n),
    color = "white",
    size = 3
  ) +
  scale_fill_viridis_c(
    option = "C",
    name = "Cantidad"
  ) +
  labs(
    title = "Categorías de establecimientos por provincia",
    subtitle = "Departamento de Junín",
    x = "Categoría",
    y = "Provincia"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )


ggsave(
  "figures/heatmap_junin_categoria.png",
  width = 11,
  height = 7,
  dpi = 300
)

###############################################################
# PROVINCIA VS ESTADO (JUNÍN)
###############################################################

estado_junin <- junin %>%
  count(PROVINCIA, ESTADO)

ggplot(
  estado_junin,
  aes(
    x = reorder(PROVINCIA, n),
    y = n,
    fill = ESTADO
  )
) +
  geom_col(position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Proporción del estado de los establecimientos",
    subtitle = "Departamento de Junín",
    x = "",
    y = "Porcentaje",
    fill = "Estado"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid.major.y = element_blank()
  )

###############################################################
# PROVINCIA VS ESTADO (JUNÍN)
###############################################################

estado_junin <- junin %>%
  count(PROVINCIA, ESTADO)

ggplot(
  estado_junin,
  aes(
    x = reorder(PROVINCIA, n),
    y = n,
    fill = ESTADO
  )
) +
  geom_col(position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Proporción del estado de los establecimientos",
    subtitle = "Departamento de Junín",
    x = "",
    y = "Porcentaje",
    fill = "Estado"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    panel.grid.major.y = element_blank()
  )

###############################################################
# ANTIGÜEDAD POR INSTITUCIÓN
###############################################################

institucion_ant <- df %>%
  filter(INSTITUCION %in% c(
    "MINSA",
    "ESSALUD",
    "PRIVADO",
    "SANIDAD DE LA POLICIA NACIONAL DEL PERU",
    "SANIDAD DE LAS FUERZAS ARMADAS"
  ))

ggplot(
  institucion_ant,
  aes(
    x = INSTITUCION,
    y = ANTIGUEDAD,
    fill = INSTITUCION
  )
) +
  geom_violin(alpha = .6) +
  geom_boxplot(
    width = .15,
    fill = "white",
    outlier.shape = NA
  ) +
  labs(
    title = "Distribución de la antigüedad según institución",
    subtitle = "RENIPRESS - Perú",
    x = "",
    y = "Antigüedad (años)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    axis.text.x = element_text(angle = 15)
  )


###############################################################
# DISTRIBUCIÓN DE CATEGORÍAS POR DEPARTAMENTO (TOP 10)
###############################################################

library(forcats)

top10_dep <- df %>%
  count(DEPARTAMENTO, sort = TRUE) %>%
  slice_head(n = 10) %>%
  pull(DEPARTAMENTO)

grafico_categoria <- df %>%
  filter(DEPARTAMENTO %in% top10_dep) %>%
  count(DEPARTAMENTO, CATEGORIA)

ggplot(
  grafico_categoria,
  aes(
    x = fct_reorder(CATEGORIA, n, .desc = TRUE),
    y = n,
    fill = CATEGORIA
  )
) +
  geom_col(width = 0.8) +
  facet_wrap(~DEPARTAMENTO, scales = "free_y") +
  scale_fill_viridis_d(option = "C") +
  labs(
    title = "Distribución de categorías por departamento",
    subtitle = "Top 10 departamentos con mayor número de establecimientos",
    x = "Categoría",
    y = "Número de establecimientos",
    caption = "Fuente: RENIPRESS (SUSALUD) - Elaboración propia"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 13),
    strip.text = element_text(face = "bold", size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    panel.grid.major.x = element_blank()
  )

ggsave(
  "figures/categorias_top10_departamentos.png",
  width = 13,
  height = 9,
  dpi = 300
)

###############################################################
# RELACIÓN ENTRE INSTITUCIÓN Y ESTADO
###############################################################

institucion_estado <- df %>%
  group_by(INSTITUCION, ESTADO) %>%
  summarise(
    Cantidad = n(),
    .groups = "drop"
  )

ggplot(
  institucion_estado,
  aes(
    x = INSTITUCION,
    y = Cantidad,
    fill = ESTADO
  )
) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Distribución del estado según institución",
    subtitle = "RENIPRESS - SUSALUD",
    x = "Institución",
    y = "Proporción",
    fill = "Estado"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.text.x = element_text(angle = 25, hjust = 1),
    panel.grid.major.x = element_blank()
  )

###############################################################
# TABLA CRUZADA: INSTITUCIÓN VS ESTADO
###############################################################

tabla_ie <- table(
  df$INSTITUCION,
  df$ESTADO
)

tabla_ie

prop.table(
  tabla_ie,
  margin = 1
)

chisq.test(tabla_ie)

###############################################################
# RESULTADO DE LA PRUEBA CHI-CUADRADO
###############################################################

chi_ie <- chisq.test(tabla_ie)

chi_ie


###############################################################
# V DE CRAMÉR
###############################################################

CramerV(tabla_ie)

###############################################################
# INSTITUCIÓN VS ESTADO
###############################################################

institucion_estado <- df %>%
  count(INSTITUCION, ESTADO)

ggplot(
  institucion_estado,
  aes(
    x = INSTITUCION,
    y = n,
    fill = ESTADO
  )
) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Distribución porcentual del estado según institución",
    subtitle = "RENIPRESS - Perú",
    x = "Institución",
    y = "Porcentaje",
    fill = "Estado"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 25, hjust = 1)
  )

ggsave(
  "figures/institucion_estado.png",
  width = 10,
  height = 6,
  dpi = 300
)

CramerV(tabla_ie)


###############################################################
# RESUMEN DEL ANÁLISIS: INSTITUCIÓN VS ESTADO
###############################################################

resumen_ie <- df %>%
  group_by(INSTITUCION, ESTADO) %>%
  summarise(
    Cantidad = n(),
    .groups = "drop"
  ) %>%
  group_by(INSTITUCION) %>%
  mutate(
    Porcentaje = round(Cantidad / sum(Cantidad) * 100, 2)
  )

resumen_ie

write.csv(
  resumen_ie,
  "figures/resumen_institucion_estado.csv",
  row.names = FALSE
)

###############################################################
# TOP 15 DISTRITOS DE JUNÍN
###############################################################

top_distritos_junin <- junin %>%
  count(DISTRITO, sort = TRUE) %>%
  slice_head(n = 15)

ggplot(
  top_distritos_junin,
  aes(
    x = reorder(DISTRITO, n),
    y = n,
    fill = n
  )
) +
  geom_col(width = 0.75) +
  geom_text(
    aes(label = n),
    hjust = -0.2,
    size = 3.8,
    fontface = "bold"
  ) +
  coord_flip() +
  scale_fill_viridis_c(option = "C") +
  expand_limits(y = max(top_distritos_junin$n) * 1.10) +
  labs(
    title = "Top 15 distritos con mayor número de establecimientos",
    subtitle = "Departamento de Junín",
    x = "",
    y = "Número de establecimientos"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank()
  )

###############################################################
# ANTIGÜEDAD SEGÚN CATEGORÍA
###############################################################

antiguedad_categoria <- df %>%
  filter(!is.na(CATEGORIA))

ggplot(
  antiguedad_categoria,
  aes(
    x = reorder(CATEGORIA, ANTIGUEDAD, median),
    y = ANTIGUEDAD,
    fill = CATEGORIA
  )
) +
  geom_boxplot(
    outlier.alpha = 0.3,
    show.legend = FALSE
  ) +
  coord_flip() +
  scale_fill_viridis_d(option = "C") +
  labs(
    title = "Antigüedad de los establecimientos según categoría",
    subtitle = "RENIPRESS - SUSALUD",
    x = "Categoría",
    y = "Antigüedad (años)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    panel.grid.major.y = element_blank()
  )

###############################################################
# GUARDAR EL ÚLTIMO GRÁFICO
###############################################################

ggsave(
  filename = "figures/antiguedad_categoria.png",
  width = 10,
  height = 6,
  dpi = 300
)

###############################################################
# GUARDAR TOP 15 DISTRITOS DE JUNÍN
###############################################################

ggsave(
  filename = "figures/top15_distritos_junin.png",
  width = 10,
  height = 6,
  dpi = 300
)

###############################################################
# DISTRIBUCIÓN DEL ESTADO SEGÚN INSTITUCIÓN
###############################################################

institucion_estado <- df %>%
  count(INSTITUCION, ESTADO) %>%
  group_by(INSTITUCION) %>%
  mutate(Total = sum(n)) %>%
  ungroup() %>%
  group_by(INSTITUCION) %>%
  filter(Total == max(Total)) %>%
  ungroup()

top_inst <- df %>%
  count(INSTITUCION, sort = TRUE) %>%
  slice_head(n = 8) %>%
  pull(INSTITUCION)

institucion_estado <- df %>%
  filter(INSTITUCION %in% top_inst) %>%
  count(INSTITUCION, ESTADO)

ggplot(
  institucion_estado,
  aes(
    y = reorder(INSTITUCION, n),
    x = n,
    fill = ESTADO
  )
) +
  geom_col(position = "fill", width = 0.8) +
  scale_x_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Estado de los establecimientos según institución",
    subtitle = "Ocho instituciones con mayor número de registros",
    x = "Porcentaje",
    y = NULL,
    fill = "Estado"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom",
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(face = "bold")
  )

ggsave(
  "figures/institucion_estado.png",
  width = 10,
  height = 6,
  dpi = 300
)


###############################################################
# COLLAGE DE LOS DOS GRÁFICOS PRINCIPALES
###############################################################

library(magick)

# Leer imágenes
g1 <- image_read("figures/categorias_top10_departamentos.png")
g2 <- image_read("figures/institucion_estado.png")

# Igualar el ancho
ancho <- max(image_info(g1)$width, image_info(g2)$width)

g1 <- image_resize(g1, paste0(ancho))
g2 <- image_resize(g2, paste0(ancho))

# Unir verticalmente
collage <- image_append(
  c(g1, g2),
  stack = TRUE
)

# Guardar
image_write(
  collage,
  path = "figures/collage_graficos.png",
  format = "png"
)

# Mostrar el collage
collage
