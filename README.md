
# Azul

## Estrategia

La estrategia implementada para los jugadores se basa en un punto de vista **greedy**. En cada turno, el jugador va a tomar la jugada que más puntos sume en ese instante de tiempo. Si hay varias jugadas que generan la misma cantidad de puntos, entonces se queda con la primera que consultó. El orden para consultar las jugadas es:

1. Posibles jugadas tomando de las factorías, respetando el orden de las factorías

2. Posibles jugadas tomando del centro de la mesa

## Iniciar la partida

Para iniciar la aprtida es neceario abrir una terminal con prolog en la carpeta del proyecto y seguir los siguientes pasos:

1. Importa el archivo principal:
```
?- consult('main.pl).
```

2. Iniciar la ejecución del juegoÑ
```
?- game.
```

El juego no se ejecuta de una vez completamente, se detiene en cada jugada a la espera que se presione cualquier tecla para continuar a la próxima jugada. Si desea que se ejecute rápidamente deje presionada cualquier tecla hasta que el juego llegue al final.

En cada jugada se muestra la siguiente información en la terminal:

![](img/info.png)

Donde se muestra el identificador del jugador, el estado de las factorías, las líneas de patrones, el muro, el piso, los puntos acumulados, la tapa del juego y el centro de la mesa.

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

### Board

Un **`Board`** es el tablero con que juega el jugador. Está compuesto por un **`Wall`**, un **`FloorVector`** y un **`PaternLines`**. Por lo que se representa como una tupla de la siguiente forma:

```
[Wall, FloorVector, PaternLines]
```

### Player

Un jugador o **`Player`** es una tupla de tres elementos **`Id, Board, Points`**. Donde **`Id`** es un identificador cualquiera y único entre todos los jugadores, **`Board`** es el tablero con el que juega el jugador y **`Points`** la puntuación del jugador.

Los puntos del jugador son de tipo **`COUNT`** ya que nunca se puede tener menos de 0 puntos.

### Factory

Una factoría o **`Factory`** no es más que un conjunto de azulejos, por lo que su representación es igual que la de un **`ColoVector`**

### Table

Una mesa o **`Table`** no es más que un conjunto de azulejos, por lo que su representación es igual que la de un **`ColoVector`**

### Bag

Una bolsa o **`Bag`** es un conjunto de azulejos, del cuál se desea extraer de forma aleatoria. Entonces es equivalente a extraer un azulejo de un color aleatorio, el problema es cuando no hay azulejos de ese color en la bolsa. Por este problema la bolsa es una tupla **`ColorVector`**, **`Mask`**. Donde **`Mask`** es el conjunto de índices de **`ColorVector`** que tienen al menos un azulejo.

```
[ColorVector, Mask]
```

### Cover

Una tapa o **`Cover`** no es más que un conjunto de azulejos, por lo que su representación es igual que la de un **`ColoVector`**

### Game

Una partida o **`Game`** es el tipo o estructura que agrupa al juego en su totalidad. Está compuesto por una lista de **`Player`**, un conjunto de **`Factory`**, un **`Table`**, un **`Bag`** y un **`Cover`**.

La cantidad de jugadores solo puede ser 2,3 o 4; y la cantidad de **`Factory`** depende de ello.

| Cantidad de jugadores | Cantidad de factorías |
| ---                   | ---                   |
| 2                     | 5                     |
| 3                     | 7                     |
| 5                     | 9                     |