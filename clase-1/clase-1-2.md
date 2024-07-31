---
layout: default
title: "Clase 1 - Segunda parte - Empezando a programar"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Editor

No existe una IDE especializada para `Julia` como pueden ser `Spyder` para `Python`, `R Studio` para `R` o `Matlab` en sí mismo. Para escribir código `Julia` más extenso es necesario utilizar un editor de texto plano externo: `VSCode`, `Sublime`, `Atom`, `Kate`, `GEdit`, `Zed`, etc., etc., etc. Cualquiera de ellos es capaz de reconocer la sintaxis de `Julia` (eventualmente vía plug-ins). Los esfuerzos de la comunidad de `Julia` han estado focalizados en el desarrollo del plug-in para `VSCode`, de modo que si no hay preferencias previas lo más sencillo es usar `VSCode` (o `VS-Codium` si se prefiere una versión de código abierto y des-microsofteada). A quienes gusten de editores que corren en la terminal, les recomiendo [Helix](https://helix-editor.com/). 

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

Guardamos el archivo, por ejemplo como `clase1.jl` (identificar en qué directorio queda guardado). 

Luego podemos ejecutarlo desde una consola `Julia` (en `VSCode` y otras IDEs puede abrirse una terminal interna, dentro del propio programa). 

# Funciones

Continuando con el ejemplo, vale la pena notar:

- Ya vimos que el `for` debe cerrarse con un `end`. Lo mismo ocurre con todos los bloques, incluido `function`.
- Podemos poner más de una operación por línea, separando los tramos con `;`. 
- `∈` puede usarse en reemplazo de `in`.
- La instrucción `return` nos dice qué valor devuelve la función, aunque ya veremos que puede omitirse.

<div class="notebox">
<span style="font-weight:bold;color:#0A9090;">Nota:</span>

La indentación no es obligatoria. Sin embargo, las recomendaciones de estilo indican que deben usarse 4 espacios.
</div>

Al ejecutar el archivo desde una sesión de `Julia` obtenemos: 

```julia
  julia> include("clase1.jl")
  fibonacci (generic function with 1 method)
```

Recordar que para que esto funcione la consola debe estar posicionada en el directorio del archivo. Si no, es posible incluir el archivo poniendo toda la ruta en lugar de sólo el nombre. El texto `fibonacci (generic function with 1 method)` aparece porque la sesión interactiva siempre muestra el resultado de la última expresión ejecutada. En este caso, la única expresión ha sido la definición de la función. Se puede suprimir este mensaje poniendo `;`. 

Hasta aquí sólo hemos generado la función dentro de la sesión interactiva. Podemos correrla, por ejemplo: 
 
```julia
  julia> fibonacci(4)
  4-element Vector{Float64}:
    1.0
    1.0
    2.0
    3.0
```

Hay varias cosas que vale la pena remarcar. 

- La instrucción `return` no es necesaria. Como ya dijimos, los bloques de código devuelven por defecto el valor de la última sentencia. Por lo tanto, `return fib` puede reemplazar simplemente por `fib`. Hacer esta modificación en el archivo, recargarlo en la consola y volver a correr la función. 
- El resultado obtenido no es el más deseable, dado que la sucesión de Fibonacci está formada por enteros. El problema viene de que `zeros(n)` genera, por defecto, un vector de ceros en flotante. Al cargarle enteros, `Julia` los _promueve_ a flotantes para mantener el tipo del vector.
Para obtener un vector de enteros, podemos hacer:
```julia
fib = zeros(Int,n)
```
Recargar el archivo y probar la función. 
- La primera línea de la función podría usar _broadcasting_: `fib[1:2] .= 1`. El `.` antecede al operador de asignación e indica que la asignación debe ser casillero a casillero sobre subvector formado por los dos primeros lugares de `fib`. Notar que al llamar a una función el `.` se coloca luego del nombre de la función (`f.(x)`), pero se pone _antes_ de los operadores (`.=`).
Y ya que estamos hablando de _broadcasting_, ¿Qué esperaría al correr el siguiente código?
```julia
  julia> fibonacci.([2,4,7])
```

# If

Agreguemos la siguiente función a nuestro archivo,  volvamos a correrlo en la consola y probemos la función: 

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

- `if` evalúa una operación lógica (que debe devolver un booleano, `true` o `false`). Como siempre, debe cerrarse con `end`. 
- `elseif` permite agregar nuevas condiciones para ser evaluadas. Pueden incluirse todas las cláusulas `elseif` necesarias.
- `else` recoge los casos no considerados por las cláusulas anteriores, y no lleva condición. 
- `elseif` y `else` pueden omitirse. 
- La notación `$x` permite interpolar el valor de la variable `x` en una `String`. 

Al ejecutar la función, ¿qué devuelve? Probar el código:

```julia
  julia> w = comparar(5,4)
  julia> w
  julia> typeof(w)
```

Otros lenguajes tienen el valor `NULL` o el valor `None`. En `Julia`, `nothing` cumple un papel similar. `nothing` es un valor único de tipo `Nothing`. Al mostrar el valor de una variable que tiene asignado `nothing`, la consola muestra... nada. 

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

Además, existe el operador `===` que compara la representación en memoria de los valores. Probar:

```julia
  julia> 1 == 1.0
  julia> 1 === 1.0
  julia> 1 === 2÷2
```

Además, existen muchísimas funciones que devuelven booleanos y pueden usarse como condiciones lógicas. Por ejemplo, `isodd()` e `iseven()`.

## Evaluaciones cortas

Cuando `Julia` evalúa una instrucción `if`-`elseif`-`else` lo hace sólo hasta encontrar un `true`. Es decir: si la condición del `if` se verifica, no se chequea la condición del `elseif`. Lo mismo ocurre con `&&` y `||`. Probar lo siguiente: 

```julia
  julia> iseven(2) && println("es par")
  julia> iseven(3) && println("es par")
  julia> iseven(2) || println("es impar")
  julia> iseven(3) || prinln("es impar")
```

En todos los casos, el operador lógico (`&&`, `||`) no está realmente comparando variables booleanas, porque el segundo término no devuelve un booleano (de hecho, devuelve `nothing`). Lo que estamos haciendo es aprovechar el mecanismo de evaluación de `Julia` para correr condicionalmente el `println()`, que sólo se ejecutará cuando el primer término sea `true` (en los cosas con `&&`) o cuando sea `false` (en los casos con `||`). La sentencia 
```julia
iseven(2) && println("es par")
```
es equivalente a la más extensa
```julia
if iseven(2)
    println("es par")
end
```

Esta herramienta se usa bastante en `Julia`. Un buen uso podría ser agregar la siguiente línea a la función `fibonacci()`:

```julia
isinteger(n) || error("n debe ser entero")
```

## Operador ternario

Dado que la cláusula `if - else` aparece con muchísima frecuencia, `Julia` incluye una variante abreviada. Probar lo siguiente: 

```julia
  julia> isodd(3) ? println("es impar") : println("es par")
  julia> isodd(2) ? println("es impar") : println("es par")
```

La sintaxis es: `condicion ? respuesta si true : respuesta si false`. Son importantes los espacios antes y después de `?` y de `:`. 

Más interesante aún: el operador ternario _devuelve_ el valor de salida, por lo cual puede usarse para realizar asignaciones condicionales. Veamos un ejemplo. 

      
Consideremos la función partida que un `n` natural devuelve `n/2` si `n` es par y `3n+1` si es impar. Una implementación de esta función podría ser: 
```julia
function collatz(n)
    if iseven(n)
        out = n÷2
    else
        out = 3n+1
    end
end
```

Notar que no le estamos poniendo `return` a la función. Podríamos hacerlo, pero no hace falta. Las funciones siempre devuelven el valor de su última expresión. En este caso la última expresión será alguna de las respuestas del `if`. Incluso podríamos eliminar la variable `out`. Esta función hace lo que necesitamos, pero cuesta 7 líneas para evaluar una pavada. La siguiente variante es mucho más compacta (y más fácil de leer):

```julia
collatz(n) = iseven(n) ? n÷2 : 3n+1
```

# While

La conjetura de Collatz dice que si componemos la función implementada más arriba suficientes veces eventualmente se alcanzará el valor `1`. Experimentemos para evaluar esta conjetura. 

Podemos agregar la siguiente función a nuestro archivo: 

```julia
function verif_collatz(n)
    i = 0
    while n!=1 && i<1000
        n = collatz(n)
        i = i+1
    end  
    if i==1000
        println("No cumple (en 1000 iteraciones)")
    else 
        println("Cumple! (en $i iteraciones)")
    end
end
```

Tenemos un clásico uso de la sentencia `while`. `while` repite un determinado bloque de código _mietras_ se ejecute cumpla una cierta condición. En este caso nuestra condición es doble: en primer lugar, continuamos evaluando `collatz` mientras no se haya alcanzado el valor `1`. Sin embargo, esto por sí sólo entraña un riesgo: si la conjetura es falsa y probamos un `n` para el cual nunca se alcanza el `1`, el loop continuará para siempre. Para prevenir esto, agregamos un contador de iteraciones `i` y cortamos el `while` si se alcanzan las `1000` vueltas.

El valor `1000` es totalmente arbitrario. Podríamos eliminarlo agregando un parámetro `max_iter`a la función: 
```julia
function verif_collatz(n,max_iter)
    i = 0
    while n!=1 && i<max_iter
        n = collatz(n)
        i = i+1
    end  
    if i==max_iter
        println("No cumple (en $max_iter iteraciones)")
    else 
        println("Cumple! (en $i iteraciones)")
    end
end
```

Esto no es del todo feliz, porque normalmente no nos interesa el valor de `max_iter`, sino sólo el de `n`. Una forma de evitar el problema es asignarle a `max_iter` un valor por defecto. Esto se logra cambiando la firma de la función por:
```julia
function verif_collatz(n,max_iter=1000)
```

De este modo la función puede ejecutarse con dos parámetros (`n` y `max_iter`), o sólo uno (`n`), en cuyo caso `max_iter` tomará el valor por defecto `1000`.

**Ejercicio:** Modificar el código de `verif_collatz` reemplazando el `if - else` por el operador ternario.

 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-1-1"> << Volver a la parte 1</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-1-3"> >> Ir a la parte 3</a> 
</div>


