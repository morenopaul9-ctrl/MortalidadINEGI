# MortalidadINEGI
Estadísticas de defunciones registradas, INEGI. Prueba técnica de admisión a DataCívica, Diciembre 2025

Las tablas csv contienen 59 variables.
Unidades de análisis: Entidad federativa donde se registra el hecho vital; entidad federativa donde ocurre el hecho vital; entidad federativa de residencia habitual del fallecido

Variables de interés para el ejercicio:

1   Ent_regis   Entidad de registro     C(2)    01-32       Entidad federativa donde se inscribe el hecho vital
7   Ent_ocurr   Entidad de ocurrencia   C(2)    01-35, 99   Entidad federativa donde ocurrió el hecho vital
13  Sexo        Sexo                    N(1)    1,2,9       Condición biológica que distingue a las personas en hombres y mujeres (Hombre/Mujer/NoEspecificado)
16  Mes_ocurr   Mes de ocurrencia       N(2)    1-12, 99    Mes en que ocurrió el hecho vital (99, No especificado)
17  Anio_ocurr  Año de ocurrencia       N(4)                Año en que ocurrió el hecho vital (99, no especificado)
20  Anio-regis  Año de registro         N(4)    2020-2024   Año en que se inscribe el hecho vital en la institución correspondiente
25  Escolarida  Escolaridad             N(2)    1-10, 88, 99    (1 Sin escolaridad / 2 Preescolar / 3 Primaria incompleta / 4 Completa / 5 Secundaria incompleta / 6 Completa / 7 Bachillerato incompleto / 8 Completo / 9 Profesional / 10 Posgrado / 88 No aplica a menores de 3 años / 99 No especificado)
34  Nacionalid  Nacionalidad            N(1)    1,2,9       Condición legal por nacimiento o naturalización (1 Mexicana / 2 Extranjera / 9 No especificado)
45  Area_ur     Área urbana o rural     N(1)    1,2,9       Urbana: población de al menos 2500 habitantes (1 Urbana / 2 Rural / 9 No especificado)
52  Lengua      Lengua indígena         N(1)    1,2,8,9     El fallecido habla una lengua indígena (1 Sí / 2 No / 8 No aplica a menores de 3 años / 9 No especificado)
14  Cod_adicio  Código adicional CIE10  C(4)    Interés en presuntos homicidios: X85 a Y09 (agresiones) y Y87.1 (secuelas de agresión)

