---
title: "Ejercicio de feedback"
format: html
---

Nombre: Iker
Apellidos: De Cabo González


#	Tipos básicos

Escriba un código que calcule la raíz cuadrada de la suma de el cuadrado de 5 más el cuadrado de 3

```{r}
raiz <- sqrt(5^2+3^2)

raiz

```

Defina un vector que contenga los números 4-8-23-75 en ese mismo orden

```{r}
vector1 <- c(4, 8, 23, 75)
vector1

```


Defina un vector cuyo primer elemento sea el 5, el último el 20 y la secuencia aumente de uno en uno


```{r}
vector_5 <- c(29, 79, 41, 89, 95, 5, 53, 90, 56, 46, 96, 46, 68, 58, 11, 90, 25, 5, 33, 96, 89, 70, 65, 100, 66)
vector_5

```

vector_5 <- c(29,  79,  41,  89,  95,   5,  53,  90,  56,  46,  96,  46,  68,  58,  11,  90,  25,   5,  33,  96,  89,  70,  65, 100,  66) Extraiga de vector_5 los siguientes elementos 

el quinto elemento 

```{r}
vector_5[5]

```

los elementos de la posición 5 a la 10 

```{r}

vector_5[5:10]

```

el mayor elemento 

```{r}

max(vector_5)

```

el menor elemento 

```{r}

min(vector_5)

```

los elementos de las posiciones 8, 10 y 2 en ese orden 

```{r}
vector_5_nuevo <- c(vector_5[8], vector_5[10], vector_5[2])
vector_5_nuevo

```

los elementos del vector mayores a 50 

```{r}

vector_5[vector_5>50]

```

los elementos menores a 30 

```{r}

vector_5[vector_5<30]

```

el último elemento usando la función length

```{r}

vector_5[length(vector_5)]

```

todos los elementos excepto los 5 últimos
 
```{r}

vector_5[1:(length(vector_5)-5)]

```


Modifique la siguiente instrucción para que se muestren solo las cinco primeras filas del data frame: head(mpg) (NOTA: Para acceder al data frame mpg, debe cargar la librería ggplot2 o con ggplot2::mpg) 

```{r}

if (!require(ggplot2)) install.packages("ggplot2")

library(ggplot2)

ggplot2::mpg

head(mpg, n=5)

```

Muestre los nombres de las columnas de la tabla mpg

```{r}

colnames(mpg)

```

Muestre el número de filas y columnas de mpg

```{r}

#podemos hacerlo usando la funcion dim

dim(mpg)

# o usando ncol y nrow

nrow(mpg)

ncol(mpg)

```

Haga un summary de la columnas displ y manufacturer. ¿Qué diferencia observa? ¿Por qué?

```{r}
summary(mpg$displ)

summary(mpg$manufacturer)

# Diferencias: la columna disp es numérica, por lo tanto realiza un estudio estadístico (míniomo, máximo, media, mediana, quartiles).
# En la columna manufacturer, sin embargo, tenemos caracteres (el fabricante), por lo que este análisis no es posible, por lo  
# tanto simplemente  nos dice que son caracteres y cuantos elementos tiene la columna

```

Repita el apartado anterior transformando en factor todas las columnas que sean de tipo carácter

```{r}

unique(mpg$manufacturer)


x <- factor(c("audi","chevrolet","dodge", "ford", "honda", "hyundai", "jeep", "land rover", "lincoln", "mercury", "nissan", "pontiac", "subaru", "toyota", "volkswagen"), levels = c("audi","chevrolet","dodge", "ford", "honda", "hyundai", "jeep", "land rover", "lincoln", "mercury", "nissan", "pontiac", "subaru", "toyota", "volkswagen"))

# Define los niveles del factor
niveles <- c("audi", "chevrolet", "dodge", "ford", "honda", "hyundai", 
             "jeep", "land rover", "lincoln", "mercury", 
             "nissan", "pontiac", "subaru", "toyota", "volkswagen")

# Aplica la factorización al vector mpg$manufacturer
mpg$manufacturer <- factor(mpg$manufacturer, levels = niveles)

levels(mpg$manufacturer)
summary(mpg$manufacturer)

```

Cree una nueva tabla mpg_small que contenga solo las 6 primeras columnas de mpg

```{r}

mpg_small=mpg[,1:6]
mpg_small

```

Extraiga las 3 primeras filas y 2 primeras columnas de mpg_small

```{r}

mpg_small[1:3, 1:2]


```

Aplique las funciones table y posteriormente  prop.table a la columna cyl de mpg_small

```{r}

table(mpg_small$cyl)
prop.table(mpg_small$cyl)

```

# Estructuras de control

Usamos de nuevo el vector_5 vector_5 <- c(29,  79,  41,  89,  95,   5,  53,  90,  56,  46,  96,  46,  68,  58,  11,  90,  25,   5,  33,  96,  89,  70,  65, 100,  66). Usando un bucle calcule la raíz cuadradada de cada elemento más la suma de el cuadrado de 5 más el cuadrado de 3 

```{r}

vector_5 <- c(29, 79, 41, 89,
              95, 5, 53, 90, 56, 46, 96, 46, 68, 58, 11,
              90, 25, 5, 33, 96, 89, 70, 65, 100, 66)

seq_along(vector_5)

for (i in seq_along(vector_5)) {
  vector_5_nuevo[i] <- sqrt(vector_5[i]+5^2+3^2)
}

vector_5_nuevo

```

Calcule lo anterior solo para los números mayores a 50

```{r}

resultado=c()


for (i in seq_along(vector_5)) {
  if (vector_5[i] > 50) {
    resultado <- c(resultado, sqrt(vector_5[i] + 5^2 + 3^2))
  }
}

resultado


```

Calcule lo anterior solo para los números mayores a 30 y menores a 60

```{r}

resultado_2=c()

for (i in seq_along(vector_5)) {
  if (vector_5[i] > 30 & vector_5[i]< 60) {
    resultado_2 <- c(resultado_2, sqrt(vector_5[i] + 5^2 + 3^2))
  }
}

resultado_2



```

Calcule lo anterior solo para los números pares

```{r}
resultado_3=c()

for (i in seq_along(vector_5)) {
  if (vector_5[i] %% 2 == 0) {
    resultado_3 <- c(resultado_3, sqrt(vector_5[i] + 5^2 + 3^2))
  }
}

resultado_3

```
