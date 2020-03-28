
# Azul

## Tipos y estructuras

### COLOR

El conjunto de colores se define como **`{azul, amarillo, rojo, negro, blanco}`**. Además se mantiene el convenio del orden, por lo que a cada color se le puede asociar un índice : **`azul:0, amarillo:1, rojo:2, negro:3, blanco:4`**.

### COUNT

Un elemento **`COUNT`** es un número entero mayor o igual que 0

### VALUE

Un **`VALUE`** es un número entero

### BOOL

Un **`BOOL`** solo puede tener dos valores: **`true`** o **`false`**

### ColorTuple (CT)

Un **`ColorTuple`** una tupla que tiene como primer elemento el nombre del color y como segundo elemento un contador

```
[COLOR,COUNT]
```

### ColorVector (CV)

Un **`ColoVector`** es una estructura que almacena un conjunto de **`ColorTuple`**, donde no se repiten colores, como se muestra a continuación:

```
[[COLOR,COUNT], [COLOR,COUNT], ... [COLOR,COUNT]]
```
*Ejemplo*: **`[[azul,2],[amarillo,1],[rojo,0],[negro,5],[blanco,3]]`**

### FloorSpace (FS)

Un **`FloorSpace`** es una tupla en la cual el primer valor indica si el espacio está ocupado o no y la segunda el costo en puntos de tenerlo ocupado

```
[BOOL,VALUE]
```

### FloorVector (FV)

Un **`FloorVector`** consiste en un conjunto de **`FloorSpace`**

```
[[BOOL,VALUE], [BOOL,VALUE], ..., [BOOL,VALUE]]
```

### The Wall

El muro o **`Wall`** es la estructura que contiene los azulejos que el jugador va poniendo. Es la estructura central del juego. Es una lista unidimesional de 25 elementos tipo **`BOOL`**.
