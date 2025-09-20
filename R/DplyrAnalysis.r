---
title: "Ejercicio de feedback"
name: Iker de Cabo González
format: html
---

```{r load data}

if (! ('pacman' %in% installed.packages())) install.packages('pacman')

pacman::p_load(nycflights13)

```


# Pregunta 1

En esta actividad vamos a usar el conjunto de datos NYC Flights. Dicho conjunto de datos
está en la librería dplyr, una vez cargada la librería los datos están accesibles y solo hay
que llamarlos escribiendo el nombre en la consola

*Exploración básica*

## a 
Realice un análisis exploratorio básico empleando las funciones trabajadas en la
sección de EDA del curso. No use más de 4 funciones y 3 gráficos, distinga entre
variables categóricas y continuas. Tome en cuentas los valores faltantes por
(variable) columna (esto es importante para los siguientes ejercicios). Escriba un
breve párrafo (no más de 5 líneas) resumiendo sus conclusiones.

```{r}

pacman::p_load(dplyr, readr, lubridate, tidyr)

nycflights13::flights

head(flights)
str(flights)

# Tenemos un DataFrame con 19 variables , de las cuales 14 son numéricas(5 de ellas correspondientes al dia, mes, año, la hora y el minuto), 4 son de tipo caracter y una es un vector con la fecha y la hora. De las 14 variables numéricas, las correspondientes a la fecha son variables continuas, ya que las vamos a usar para calcular tiempos de llegada de los vuelos y retrasos, dep_delay, arr_delay, sched_dep_delay, distance, airtime y sched_arr_time son variables continuas también, mientras que el resto de variables (origin, dest, tailnum, flight y carrier) son variables categóricas.

summary(flights)


hist(flights$dep_delay)
hist(flights$arr_delay)
cor(flights$arr_delay, flights$dep_delay, use='complete.obs')

mean(flights$arr_delay, na.rm=TRUE)
median(flights$arr_delay, na.rm=TRUE)
var(flights$arr_delay, na.rm=TRUE)
sd(flights$arr_delay, na.rm=TRUE)
IQR(flights$arr_delay, na.rm=TRUE)
quantile(flights$arr_delay, na.rm=TRUE, c(0.25, 0.5, 0.75, 0.9, 0.95, 1))



# Podemos observar que las variables arr_delay y dep_delay tienen una correlación grandísima, prácticamente de 1 a 1. También observamos distribuciones muy sesgadas en ambos casos, habiendo muy pocos retrasos, pero cuando hay retrasos tienden a ser muy grandes. La mediana es un adelanto de 5 minutos respecto de la hora de llegada, mientras que la media es de un retraso de unos 7 minutos, y con unos retrasos en los últimos percentiles muy altos.

```

## b
Realice un análisis descriptivo solo de aquellos vuelos que que tengan como
destino la ciudad de Los Ángeles (LAX), que muestre la media, mediana y
número de vuelos con ese destino, usando verbos de dplyr y el pipe

```{r}

mean_arr_delay <- flights |> 
      filter(dest=='LAX') |> 
      summarize(avg_delay = mean(arr_delay, na.rm = TRUE)) 

mean_dep_delay<- flights |> 
     filter(dest=='LAX') |> 
     summarize(avg_delay = mean(dep_delay, na.rm=TRUE))

median_arr_delay <-  flights |> 
         filter(dest=='LAX') |> 
         summarize(avg_delay = median(arr_delay, na.rm = TRUE))

median_dep_delay <-  flights |>
         filter(dest=='LAX') |> 
         summarize(avg_delay = median(arr_delay, na.rm = TRUE))
num_flights <- flights |> filter(dest=='LAX') |> count()

print(num_flights)


```

## c
Elabore un histograma de la variable dep_delay. Intérprete el gráfico

```{r}

hist(flights$dep_delay)

# Como ya hemos comentado anteriormente, se trata de una distribución sesgada, donde el resultado más común es que exista un adelanto en la hora de salida. Sin embargo, la media es que el vuelo llegue con 9 minutos de retraso, lo que implica que aunque hay pocos vuelos que lleguen con retraso, existen vuelos con retrasos muy grandes, siendo el máximo un retraso de 1272 minutos o 21,2 horas.

```

## d
Ajuste el bindwidth del histograma para valores de 15 y 150. ¿Qué histograma
aporta más información? ¿Por qué?

```{r}

hist(flights$dep_delay, 
     breaks = seq(min(flights$dep_delay, na.rm = TRUE), 
                  max(flights$dep_delay, na.rm = TRUE)+15, 
                  by = 15), 
     col = "blue", 
     border = "black",
     main = "Histograma de Retrasos en Salida, bindwidth=15",
     xlab = "Retraso en Minutos")

hist(flights$dep_delay, 
     breaks = seq(min(flights$dep_delay, na.rm = TRUE), 
                  max(flights$dep_delay, na.rm = TRUE)+150, 
                  by = 150), 
     col = "blue", 
     border = "black",
     main = "Histograma de Retrasos en Salida, bindwidth=150",
     xlab = "Retraso en Minutos")

# El histograma con bindwidth=15 aporta más información, ya que tiene más resolución. Al estar la distribución tan concentrada en los priemros valores, en el histograma con saltos de 150 minutos, tenemos prácticamente todos los datos en la misma barra, por lo que aporta menos información que el caso con más barras, donde al menos podemos observar que el resultadoo más común es llegar ligeramente antes del tiempo anticipado.
```

# Pregunta 2

*Análisis del conunto de datos*

## a
Obtenga el número de viajes por mes y destino usando dplyr

```{r}

flights_agrupados <- flights |> group_by(month, dest) |> summarize(num_viajes=n())
print(flights_agrupados)

```

## b
¿Qué destino recibió más vuelos en junio?

```{r}

flights_agrupados |> filter(month==6) |> slice_max(order_by=num_viajes)

# El destino con más vuelos en junio resulta ORD

```

## c
¿Qué compañía aérea tuvo la mayor distancia media por vuelo?

```{r}


head(flights)


num_na <- sum(is.na(flights$distance))

# No hay datos faltantes en esta columna, por lo que podemos calcular directamente la media de Km por vuelo


max_dist_flight <- flights |> group_by(carrier) |> summarize(distancia_total=sum(distance), num_viajes=n()) |> mutate(distancia_por_vuelo=distancia_total/num_viajes) |> slice_max(order_by=distancia_por_vuelo)

print(max_dist_flight)

# La compañía con los vuelos  más laegos en promedio resulta HA, con una distancia media de 4983KM por vuelo.


```

## d
¿Qué vuelo viajó a más velocidad (millas por hora en total)?

```{r}

flights |> mutate(velocidad=distance/air_time*60)|> slice_max(velocidad)

# El vuelo con la velocidad media más alta resulta ser el N666DN, con una velocidad media de 703,38 millas por hora


```

## e
¿Cuál fue la distancia total para todos los vuelos en enero? ¿Cuál fue la distancia media por vuelo?

```{r}

distancia_total <- flights |> filter(month==1) |> summarize(distancia_total=sum(distance))

print(distancia_total)

viajes_totales <- flights |> filter(month==1) |> summarize(viajes_totales=n())

distancia_por_vuelo=distancia_total/viajes_totales

print(distancia_por_vuelo)

# La distancia total de los vuelos de enero fue de 27188805 millas, con una distanca por vuelo promedio de 1006,8 millas.
```

## f
¿Qué día de la semana tuvo más vuelos? (Pista: use la columna "time_hour" que es una columna de fecha/hora y use una función para obtener el día de la semana para una fecha)

```{r}


vuelos <-flights |> mutate(dia_semana=wday(time_hour)) |> group_by(dia_semana) |> summarize(vuelos_totales=n()) |>arrange(desc(vuelos_totales))

print(vuelos)

# El día se la semana con más vuelos es el martes

```

## g
¿Cuál fue el número medio de plazas y motores en los aviones que salieron de Nueva York el 4 de julio? (Los datos de plazas (seats) y motores (engines) provienen de la tabla de aviones, tenga cuidado con sus joins/uniones)

```{r}

nycflights13::planes
flights

joinned <- inner_join(flights, planes, by = "tailnum")|> filter(month==7, day==4) |> summarize(plazas=sum(seats), engines=sum(engines), vuelos=n())|>mutate(plazas_vuelo=plazas/vuelos, engines_vuelo=engines/vuelos)

print(joinned)

# El número de pasajeros y motores para el 4 de julio fue de 140,65 y 1,99, respectivamente

```

## h
Supongamos que va a volar desde Nueva York y quiere saber cuál de los tres aeropuertos principales de Nueva York tiene el mejor índice de puntualidad en los vuelos de salida. Suponga también que, para usted, un vuelo que se retrase menos de 5 minutos es básicamente "puntual". Usted considera "retrasado" cualquier vuelo que se retrase 5 minutos o más.

```{r}

sum(is.na(flights$dep_delay))

 por_retrasos <- flights |> filter(!is.na(dep_delay)) |>
  group_by(origin) |>                              
  summarize(
    vuelos = n(),                                   
    vuelos_retrasados = sum(dep_delay >= 5, na.rm = TRUE), 
    por_retrasos = vuelos_retrasados / vuelos      
  )

print(por_retrasos)

# Podemos ver que el mejor aeropuerto para estos criterios es LGA.
```

### i
Para determinar qué aeropuerto tiene el mejor índice de salidas puntuales, puede clasificar primero cada vuelo como "puntual" o "retrasado. Use dplyr y el pipe para hacer todas las operaciones.

```{r}

sum(is.na(flights$dep_delay))

# Existen valores Nan en la variable dep_delay, por lo tanto vamos a eliminar estos registros

puntualidad <- flights |> filter(!is.na(dep_delay)) |> mutate(puntualidad = ifelse(dep_delay <=0, 'puntual', 'retrasado'))
                            

sum(is.na(puntualidad$puntualidad))

print(puntualidad)
```

### ii
Agrupe los vuelos por aeropuerto de origen

```{r}

puntualidad_agrupada <- puntualidad |> group_by(origin) |> summarize(vuelos_retrasados=sum(puntualidad=='retrasado', na.rm=TRUE), vuelos=n())

print(puntualidad_agrupada)

```

### iii
Calcule los índices de puntualidad de cada aeropuerto de origen como la fracción de vuelos puntuales sobre el total

```{r}
por_puntualidad <- puntualidad_agrupada |> mutate(por_puntuales= (vuelos-vuelos_retrasados)/vuelos)

print(por_puntualidad)

```

### iv
Ordene los aeropuertos en orden descendente según el porcentaje de salidas puntuales


```{r}

por_puntualidad|> arrange(desc(por_puntuales))

```

### v
Elabore un gráfico que contenga los 10 aeropuertos más puntuales y su porcentaje de salidas puntuales. Escoga el diseño que considere más informativo

```{r}

# Dado que los origenes de vuelo y salidas son solo desde 3 aeropuestos, vamos a considerar que se pregunta los destinos y las horas de llegada

puntualidad_arrivals <- flights |> filter(!is.na(arr_delay)) |> group_by(dest) |> mutate(puntualidad = ifelse(arr_delay <=0, 'puntual', 'retrasado')) |> summarize( 
    vuelos_totales = n(), 
    vuelos_retrasados = sum(puntualidad == 'retrasado'), 
    proporcion_retrasados = vuelos_retrasados / vuelos_totales 
  ) |> arrange(proporcion_retrasados)

print(puntualidad_arrivals)

# Existe un destino con un solo registro. Vamos a eliminarla ya que no resulta representativa

top10 <- puntualidad_arrivals[c(2:11), ]
print(top10)

# Vamos a representar los datos

barplot(top10$proporcion_retrasados*100, names.arg = top10$dest, col='skyblue',
        ylab='Porcentaje(%)', xlabel='Destino', main = 'Proporción de Vuelos Retrasados por Destino' )

# Podemos observar que para los mejores aeropuertos con muestras minimamente significativos, el porcentaje de aviones que llegan a la hora es de alrededor del 30%, siendo el destino DEX descartado al solo tener un vuelo registrado, dándonos un 100% de puntualidad, resultado que no es para nada representativo.

```

