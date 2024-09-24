---
layout: default
title: "Clase 2 - Primera parte - Empezando a programar"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Editor

Para escribir código propio la consola no alcanza. Necesitamos un archivo de texto que luego podemos correr desde la consola. 

No existe un entorno de desarrollo especializada para `Julia` como pueden ser `Spyder` para `Python`, `R Studio` para `R` o `Matlab` en sí mismo. Para escribir código `Julia` más extenso es necesario utilizar un editor de texto plano externo: `VSCode`, `Sublime`, `Atom`, `Kate`, `GEdit`, `Zed`, etc., etc., etc. Cualquiera de ellos es capaz de reconocer la sintaxis de `Julia` (eventualmente vía plug-ins). Los esfuerzos de la comunidad de `Julia` han estado focalizados en el desarrollo del plug-in para [`VSCode`](https://code.visualstudio.com/), de modo que si no hay preferencias previas lo más sencillo es usar `VSCode` (o `VS-Codium` si se prefiere una versión de código abierto y des-microsofteada). A quienes gusten de editores que corren en la terminal, les recomiendo [`Helix`](https://helix-editor.com/). 


Una vez instalado `VSCode` instalar también el plug-in de `Julia`. 

Por otro lado, en una consola de `Julia` instalar el paquete `LanguageServer`. Para ello, tipear `]`  para ingresar en el gestor de paquetes y luego: 

```julia
  pkg> add LanguageServer
```

El `LanguageServer` es un paquetito que contiene la descripción de la sintaxis de `Julia`. `VSCode` (y otros editores) ejecutan este paquete para poder reconocer el código `Julia` y ofrecer distintas herramientas (ayudas para autocompletar, firmas de funciones, etc.).


# Archivos `.jl`

Para escribir código `Julia` sólo necesitamos generar un archivo con extensión `.jl`. Luego podemos correrlo desde la consola. 

Generar un archivo nuevo e insertar el siguiente código: 

```julia
function fibonacci(n)
    fib = zeros(n)
    fib[1] = 1; fib[2] = 1
    for i ∈ 3:n
        fib[i] = fib[i-1] + fib[i-2]
    end
    return fib
end
```

Se trata de una función muy sencilla que recibe un parámetro `n` y devuelve un vector con los primeros `n` términos de la sucesión de Fibonacci. 

Guardamos el archivo, por ejemplo como `clase2.jl` (identificar en qué directorio queda guardado). 

Luego podemos ejecutarlo desde una consola `Julia` (en `VSCode` y otras IDEs puede abrirse una terminal interna, dentro del propio programa). 

# Funciones

Continuando con el ejemplo, vale la pena notar:

- Para definir una función usamos la palabra reservada `function`, que debe cerrarse con `end`.
- El encabezado de la función es `function nombre_de_la_funcion(parametros)`, donde los parámetros se separan con comas (ya veremos alguna salvedad a esta regla).
- `return` indica los valores a devolver. En este caso, devolvemos una sola cosa, pero si quisiéramos devolver varias bastaría ponerlas todas a continuación del `return`, separadas por comas.
- La palabra clave `return` puede omitirse. Por defecto, `Julia` devuelve el valor de la última instrucción, de modo que si la última línea de la función fuera sólo `fib`, funcionaría igual. 
- Podemos poner más de una operación por línea, separando los tramos con `;`. 
- `∈` puede usarse en reemplazo de `in`.

<div class="notebox">
<span class="notetit">Nota:</span>

La indentación no es obligatoria. Sin embargo, las recomendaciones de estilo indican que deben usarse 4 espacios.
</div>

Para ejecutar el archivo desde una sesión de `Julia` usamos la función `include()`. Esto equivale a copiar el código del archivo dentro de la consola.   

```julia
  julia> include("clase2.jl")
  fibonacci (generic function with 1 method)
```

Recordar que para que esto funcione la consola debe estar posicionada en el directorio del archivo. Si no, es posible incluir el archivo poniendo toda la ruta en lugar de sólo el nombre. El texto `fibonacci (generic function with 1 method)` aparece porque la sesión interactiva siempre muestra el resultado de la última expresión ejecutada. En este caso, la única expresión ha sido la definición de la función. Se puede suprimir este mensaje poniendo `;`: `include("clase.jl");`.

Hasta aquí sólo hemos generado la función dentro de la sesión interactiva. Podemos correrla, por ejemplo: 
 
```julia
  julia> fibonacci(4)
  4-element Vector{Float64}:
    1.0
    1.0
    2.0
    3.0
```

El resultado obtenido no es el más deseable, dado que la sucesión de Fibonacci está formada por enteros. El problema viene de que `zeros(n)` genera, por defecto, un vector de ceros en flotante. Al cargarle enteros, `Julia` los _promueve_ a flotantes para mantener el tipo del vector.
Para obtener un vector de enteros, podemos hacer:
```julia
fib = zeros(Int,n)
```
Recargar el archivo y probar la función. 


Como última observación, la segunda línea de la función podría usar _broadcasting_: `fib[1:2] .= 1`. El `.` antecede al operador de asignación e indica que la asignación debe ser casillero a casillero sobre el subvector formado por los dos primeros lugares de `fib`. Notar que al llamar a una función el `.` se coloca luego del nombre de la función (`f.(x)`), pero se pone _antes_ de los operadores (`.=`).

Y ya que estamos hablando de _broadcasting_, ¿Qué cabe esperar si corremos el siguiente código?
```julia
  julia> fibonacci.([2,4,7])
```
¿Y el siguiente código?
```julia
  julia> fibonacci.((3,4,5))
```

# If

Agreguemos la siguiente función a nuestro archivo:

```julia
function comparar(x,y)
    if x<y
        println("$x es menor que $y")
    elseif x>y
        println("$x es mayor que $y")
    else
        println("$x e $y son iguales")
    end
end      
```

Luego de recargar el archivo en la consola, correr el código:

```julia
  julia> w = comparar(5,4)
  julia> w
  julia> typeof(w)
```

¿Qué devuelve? 

- `if` evalúa una operación lógica (que debe devolver un booleano, `true` o `false`). Como siempre, debe cerrarse con `end`. 
- `elseif` permite agregar nuevas condiciones para ser evaluadas. Pueden incluirse todas las cláusulas `elseif` necesarias.
- `else` recoge los casos no considerados por las cláusulas anteriores, y no lleva condición. 
- Las cláusulas `elseif` y `else` no son obligarias. Es decir: un sentencia `if condicion; codigo; end` funciona perfectamente y ejecuta el código sólo si la condición se cumple. 
- La notación `$x` permite interpolar el valor de la variable `x` en una `String`. 
- Otros lenguajes tienen el valor `NULL` o el valor `None`. En `Julia`, `nothing` cumple un papel similar. `nothing` es un valor único de tipo `Nothing`. Al mostrar el valor de una variable que tiene asignado `nothing`, la consola muestra... nada. 

Los operadores booleanos usuales en `Julia` son: 

- `==`: igualdad
- `!=`,`≠`: distinto
- `>`: mayor
- `<`: menor
- `>=`,`≥`: mayor o igual
- `<=`,`≤`: menor o igual
- `!`: negación
- `&&`: y
- `||`: o

## Evaluaciones de circuito corto y operador ternario

Probar las siguientes secuencias de código

```julia
  julia> 1 == 1.0
  julia> 1 == 1 + 0im
  julia> 1 < 2
  julia> 1 < 2+0im
  julia> 1 > 2//3
  julia> 1 == 2//2
  julia> 1 === 1
  julia> 1 === 1.0
  julia> 1 === 1+0im
  julia> 1 === 2//2
```

```julia
  julia> isodd(4)
  julia> iseven(8)
  julia> isinteger(9)
  julia> isinteger(3.5)
  julia> isinteger(2//2)
  julia> x::UInt64 = 9
  julia> typeof(x)
  julia> typeof(x) == typeof(9)
  julia> isinteger(x)
```

```julia
  julia> z = println("es par")
  julia> z
  julia> typeof(z)
  julia> iseven(2) && println("es par")
  julia> iseven(3) && println("es par")
  julia> iseven(2) || println("es impar")
  julia> iseven(3) || println("es impar")
```

En el ejemplo anterior, los operadores `&&` y `||` ¿están realmente haciendo una comparación de valores booleanos?

Pasemos en limpio: 

- Los operadores `<`,`>`, `==`, `<=`,`>=` realizan comparaciones y devuelven `true` o `false`.
- No se puede comparar con un complejo, porque los complejos no están ordenados.
- El operador `===` compara la representación en memoria de los valores. Es decir que `1===1` es `true`, pero `1===1.0` es `false`.
- Las funciones `isodd`, `iseven`, `isinteger` también devuelven booleanos, de acuerdo a si el parámetro es impar, par o entero, respectivamente. `isinteger` no refiere exactamente al tipo de dato, pues es capaz de darse cuenta de que `2//2` es entero, pese a que estríctamente se almacena como un racional. 
- Podemos _anotar_ el tipo de un dato al asignarlo usando `::`. Por ejemplo: `x::Int8 = 4`. `UInt64` son enteros _positivos_ (`U` por _Unsigned_) que ocupan 64 bits. `Int8` es un entero (con signo) que ocupa 8 bits. 
- La función `println` imprime en pantalla, pero devuelve `nothing`.
- **Evaluación corta**: Los operadores `&&` y `||` pueden usarse como condicionales compactos. Al ejecutar la expresión: 
```julia
  julia> iseven(2) && println("es par")
```
`Julia` evalúa `iseven(2)`, obtiene `true` y luego debe evaluar el `println` porque debe verificar si _ambas_ expresiones son `true`. El `println` no devuelve nada, de modo que la verificación del `&&` no ocurre. Pero se evalúa la expresión derecha y por lo tanto se imprime el mensaje. 
En cambio, al correr: 
```julia
  julia> isodd(2) && println("es impar")
```
La primera constatación es `isodd(2)` que devuelve `false`. Dado que las expresiones están conectadas con un `&&` y que la primera expresión es `false`, `Julia` ya sabe que el resultado es `false` y no se toma la molestia de evaluar la expresión derecha y por lo tanto el mensaje no se imprime. 
La misma lógica aplica al operador `||`: si la primera expresión es `true`, no se evalúa la segunda. 
Es decir que  `&&` y `||` **sirven para escribir expresiones cortas que ejecutan condicionalmente una sentencia**.
```julia
iseven(2) && println("es par")
```
es equivalente a la más extensa
```julia
if iseven(2)
    println("es par")
end
```
 
Usemos este último concepto en un caso realista. En nuestro archivo con funciones, modificar la función `fibonacci` agregando la siguiente línea (inmediatamente debajo del encabezado de la función:)
Esta herramienta se usa bastante en `Julia`. Un buen uso podría ser agregar la siguiente línea a la función `fibonacci()`:

```julia
isinteger(n) || error("n debe ser entero, se pasó el valor $n de tipo $(typeof(n))")
```

Volver a cargar el archivo en la consola y correrlo con un dato no entero y con uno entero

```julia
  julia> include("clase1.jl")
  julia> fibonacci(2.5)
  julia> fibonacci(4)
  julia> fibonacci(12//4)
```

Probar el siguiente código:

```julia
  julia> isodd(3) ? println("es impar") : println("es par")
  julia> isodd(2) ? println("es impar") : println("es par")
  julia> esimpar(x) = isodd(x) ? println("es impar") : println("es par")
  julia> esimpar(4)
  julia> esimpar(7)
  julia> esparbit(x) = iseven(x) ? 1 : 0
  julia> esparbit(4)
  julia> esparbit(9)
  julia> x = rand(1:100,100);
  julia> println(x)
  julia> esparbit.(x)
  julia> sum(esparbit.(x))
  julia> x .|> esparbit |> sum
  julia> sum(esparbit,x)
  julia> sum(iseven,x)
```

Pasemos en limpio:

+ El operador ternario `?:` es una forma compacta de escribir un `if - else - end`. La sintaxis es:  
    `condicion ? respuesta si true : respuesta si false`. 
  Son importantes los espacios antes y después de `?` y de `:`. 
+ Más interesante aún: el operador ternario _devuelve_ el valor de salida, por lo cual puede usarse para realizar asignaciones condicionales. La funcion `esparbit` valdrá `1` si el número recibido es par y `0` en caso contrario. 
+ La función `rand`:
  - `rand()` (sin parámetros) devuelve un número aleatorio entre 0 y 1. 
  - `rand(n)` con `n` entero devuelve un vector de longitud `n` con números aleatorios entre 0 y 1. 
  - `rand(v)` donde `v` es un vector o un rango devuelve un número aleatorio dentro de ese vector o rango. 
  - `rand(v,n)` con `v` vector o rango y `n` entero devuelve un vector de longitud `n` con valores elegidos al azar dentro de `v`. 
+ Para contar la cantidad de números pares en un vector `x` podemos hacer: `sum(esparbit.(x))`. Esto aplica `esparbit` casillero a casillero y luego suma.
+ Alternativamente tenemos la sintaxis tipo _pipeline_ usando el operador `|>` que permite hacer que una variable _pase a lo largo_ de una secuencia de funciones. La sintaxis: `x .|> esparbit |> sum` toma `x` lo pasa por la función `esparbit` (casillero a casillero porque se usó `.|>`) y el resultado se lo pasa a la función `sum`. 
+ Otra alternativa es usar directamente `sum(esparbit,x)`. Es decir:
  - `sum(v)` donde `v` es un vector o un rango, suma todos los elementos.
  - `sum(f,v)`  donde `f` es una función y `v` un vector o un rango primero aplica la función a cada elemento y luego suma. 
+ A los fines de sumar, la función `esparbit` es superflua, dado que puede usarse directamente `iseven`.


**Ejercicio:** Escribir la función partida que recibe un natural `n` y devuelve `n÷2` si `n` es par y `3n+1` si es impar. Escribir dos versiones: una extensa, usando `function` con un `if - else - end` y una compacta, en una línea, usando el operador ternario. 

# While

La sintaxis del `while` sigue la misma lógica que el if: 
```julia
    while condiciones
        instrucciones a repetir
    end
```

**Ejercicio:** La conjetura de Collatz dice que si aplicamos la función del ejercicio anterior sucesivamente comenzando por cualquier natural `n`, eventualmente se alcanzará el valor `1`. Experimentemos para evaluar esta conjetura. Implementar una función cuya firma sea:
```julia
function verif_collatz(n)
```
que reciba un valor `n` y aplique reiteradamente la función anterior hasta que se alcance el valor `1`. La función debe devolver la cantidad de iteraciones que fueron necesarias para llegar a `1`.

**Ejercicio:** Si la conjetura fuera falsa, podríamos encontrar un `n` para el cual la aplicación reiterada de la función no concluya nunca. Para evitar eso podemos imponer un tope al número de iteraciones a realizar. Para ello, el encabezado de nuestra función podría ser 
```julia
function verif_collatz(n,max_iter)
```
donde `max_iter` será el tope que impongamos al número de evaluaciones, agregando al `while` la condición `i < max_iter` (donde `i` es el contador de iteraciones). Esto no es del todo feliz, porque normalmente no nos interesa el valor de `max_iter`, sino sólo el de `n`. Una forma de evitar el problema es asignarle a `max_iter` un valor por defecto. Esto se logra cambiando la firma de la función por:
```julia
function verif_collatz(n,max_iter=1000)
```
De este modo la función puede ejecutarse con dos parámetros (`n` y `max_iter`), o sólo uno (`n`), en cuyo caso `max_iter` tomará el valor por defecto `1000`. Implementar este cambio en la función. 

**Ejercicio:** Escribir una función que reciba un parámetro `N` y genere (y devuelva) el vector de longitud `N` conteniendo la logitud de la sucesión de Collatz para cada `n` menor o igual que `N`. Calcular el vector para `N=1_000_000` y decidir cuál es el valor de `n` que genera la sucesión más larga (se puede usar la función `argmax`).

<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-1/clase-1-2"> << Volver a la clase 1</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-2/clase-2-2"> >> Ir a la parte 2</a> 
</div>


