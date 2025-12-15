# paúl moreno
# ejercicio para posición "data analyst" en DataCivica
# diciembre 2025

rm(list=ls())

library(tidyverse)
library(foreign)

getwd()

setwd("/Users/paulmoreno/MortalidadPM/data")

list.files("/Users/paulmoreno/MortalidadPM/data")

edr <- read.csv("/Users/paulmoreno/MortalidadPM/data/defun24.csv")

# Filtro de homicidios 

edr_hom <- edr %>%
  rename(
    sexo = SEXO,
    edad = EDAD,
    entidad = ENT_OCURR,
    cie10 = CAUSA_DEF
  ) %>%
  filter(
    str_detect(cie10, "^X8[5-9]|^X9[0-9]|^Y0[0-9]|^Y87\\.1")
  ) %>%
  mutate(
    sexo = recode(sexo,
                  "1" = "Hombre",
                  "2" = "Mujer",
                  "9" = "No especificado"),
    edad = as.numeric(edad)
  ) %>%
  filter(!is.na(edad), edad >= 0)

# Variables mínimas para análisis 

edr_hom <- edr_hom %>%
  select(
    entidad,
    sexo,
    edad,
    cie10,
    everything()
  )

# Verificar 

count(edr_hom, sexo)
summary(edr_hom$edad)

# Guardar 

write_csv(edr_hom, "EDR_2024_homicidios.csv")

# Hallazgo 1, Por sexo

edr_hom %>%
  count(SEXO) %>%
  mutate(pct = n / sum(n))

# por edad

edr_hom <- edr_hom %>%
  filter(!is.na(edad), edad >= 0, edad <= 100)
edr_hom %>%
  ggplot(aes(x = edad)) +
  geom_histogram(bins = 40) +
  labs(x = "Edad", y = "Número de homicidios")

edr_hom <- edr %>%
  mutate(
    cie10 = str_trim(toupper(CAUSA_DEF))
  ) %>%
  filter(
    str_detect(cie10, "^X8[5-9]|^X9[0-9]|^Y0[0-9]|^Y87")
  )

edr_hom <- edr_hom %>%
  mutate(
    edad_anios = case_when(
      EDAD >= 4000 & EDAD < 5000 ~ EDAD - 4000,
      EDAD >= 3000 & EDAD < 4000 ~ (EDAD - 3000) / 12,
      EDAD >= 2000 & EDAD < 3000 ~ (EDAD - 2000) / 365,
      EDAD >= 1000 & EDAD < 2000 ~ (EDAD - 1000) / (365 * 24),
      TRUE ~ NA_real_
    )
  )

summary(edr_hom$edad_anios)
edr_hom <- edr_hom %>%
  filter(!is.na(edad_anios), edad_anios >= 0, edad_anios <= 100)

ggplot(edr_hom, aes(x = edad_anios)) +
  geom_histogram(bins = 40) +
  labs(
    x = "Edad (años)",
    y = "Número de homicidios"
  )

# por entidad

edr_hom %>%
  count(entidad, sort = TRUE)

names(edr_hom)
table(edr_hom$ENT_OCURR)[1:10]
edr_hom <- edr_hom %>%
  rename(entidad = ENT_OCURR)

edr_hom %>%
  count(entidad, sort = TRUE)

entidades <- tibble(
  entidad = 1:32,
  nombre = c(
    "Aguascalientes","Baja California","Baja California Sur","Campeche",
    "Coahuila","Colima","Chiapas","Chihuahua","Ciudad de México","Durango",
    "Guanajuato","Guerrero","Hidalgo","Jalisco","México","Michoacán",
    "Morelos","Nayarit","Nuevo León","Oaxaca","Puebla","Querétaro",
    "Quintana Roo","San Luis Potosí","Sinaloa","Sonora","Tabasco","Tamaulipas",
    "Tlaxcala","Veracruz","Yucatán","Zacatecas"
  )
)

edr_hom <- edr_hom %>%
  left_join(entidades, by = "entidad")

edr_hom %>%
  count(nombre, sort = TRUE) %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(nombre, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "",
    y = "Número de homicidios"
  )

# Hallazgo 2, por género

edr_hom %>%
  group_by(SEXO) %>%
  summarise(
    edad_mediana = median(edad_anios, na.rm = TRUE),
    n = n()
  )

edr_hom %>%
  group_by(entidad) %>%
  summarise(
    total = n(),
    mujeres = sum(SEXO == "Mujer", na.rm = TRUE),
    pct_mujeres = mujeres / total
  ) %>%
  arrange(desc(pct_mujeres))

edr_hom %>%
  group_by(entidad) %>%
  summarise(
    total = n(),
    mujeres = sum(SEXO == "Mujer", na.rm = TRUE),
    pct_mujeres = mujeres / total
  ) %>%
  arrange(desc(pct_mujeres))

# 3 Migrantes

edr_hom <- edr_hom %>%
  mutate(
    migrante = case_when(
      NACIONALID == 2 ~ "Migrante",
      NACIONALID == 1 ~ "No migrante",
      TRUE ~ "No especificado"
    )
  )

edr_hom %>%
  count(migrante)

edr_hom %>%
  count(migrante, SEXO) %>%
  group_by(migrante) %>%
  mutate(pct = n / sum(n))

# Grafica 1

edr_hom %>%
  filter(edad_anios >= 0, edad_anios <= 100, SEXO %in% c("Hombre", "Mujer")) %>%
  ggplot(aes(x = edad_anios, fill = SEXO)) +
  geom_histogram(bins = 40, position = "identity", alpha = 0.6) +
  labs(
    x = "Edad",
    y = "Número de homicidios",
    fill = "Sexo"
  )

# 2

edr_hom %>%
  filter(SEXO %in% c("Hombre", "Mujer")) %>%
  group_by(entidad) %>%
  summarise(
    total = n(),
    mujeres = sum(SEXO == "Mujer"),
    pct_mujeres = mujeres / total
  ) %>%
  arrange(pct_mujeres) %>%
  slice_tail(n = 10) %>%   # entidades con mayor proporción
  ggplot(aes(x = reorder(entidad, pct_mujeres), y = pct_mujeres)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "Entidad",
    y = "Proporción de mujeres entre las víctimas de homicidio"
  )

# 3

edr_hom <- edr_hom %>%
  mutate(
    migrante = case_when(
      NACIONALID == 2 ~ "Migrante",
      NACIONALID == 1 ~ "Nacionalidad Mexicana",
      TRUE ~ "No especificado"
    )
  )

count(edr_hom, migrante)

count(edr_hom, migrante, SEXO)

edr_hom %>%
  filter(migrante != "No especificado") %>%
  count(migrante) %>%
  ggplot(aes(x = migrante, y = n)) +
  geom_col() +
  labs(
    x = "",
    y = "Número de homicidios"
  )

edr_hom <- edr_hom %>%
  filter(SEXO %in% c(1, 2))

edr_hom <- edr_hom %>%
  mutate(
    sexo = recode(as.character(SEXO),
                  "1" = "Hombre",
                  "2" = "Mujer")
  )

edr_hom %>%
  filter(migrante != "No especificado") %>%
  count(migrante, SEXO) %>%
  ggplot(aes(x = migrante, y = n, fill = SEXO)) +
  geom_col(position = "dodge") +
  labs(
    x = "",
    y = "Número de homicidios",
    fill = "Sexo"
  )

# FIN

rm(list=ls())
