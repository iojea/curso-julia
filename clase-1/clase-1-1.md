---
layout: default
title: "Clase 1 - Primera parte - La consola"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Instalación

`Julia` es gratuito y de código abierto (no sólo eso sino que, como remarcaremos reiteradamente, la mayor parte del código ¡está escrito en `Julia`!). La instalación es muy sencilla, siguiendo las instrucciones en el sitio de [Descargas](https://julialang.org/downloads/). La opción recomendada es abrir una terminal y correr el siguiente código (requiere conexión a internet):

```
 $ curl -fsSL https://install.julialang.org | sh
```
Esto instala `juliaup` que es una aplicación para mantener y actualizar `Julia` y además corre `juliaup` instalando la versión actual de `Julia`. En el futuro se podrá actualizar a la versión más reciente de `Julia` corriendo en una terminal: 

```
 $ juliaup update
```

La segunda alternativa es bajar un instalador o un binario específico para el sistema operativo en el que se quiera instalar (más abajo, en la misma página). Esto sólo instala `Julia`. Es posible que esta sea la mejor opción para Windows. 

En cualquiera de los casos se obtendrá una instalación del núcleo de `Julia` (lo que se llama `Julia Base`) más algunas librerías consideradas básicas (`Statistics`, `LinearAlgebra`, etc.) que se incluyen en el paquete básico pero deben importarse en caso de querer usarlas. Existen muchísimos otros paquetes, que pueden instalarse aparte (desde `Julia`). 

# La (o el?) REPL

Una vez realizada la instalación lo más común (y recomendable) es usar `Julia` a través de la REPL (Read, Eval, Print Loop), a la que llamaremos simplemente "consola". En Windows probablemente se genere un ícono de `Julia`, que permitirá abrir la consola. En Linux y MacOS debería bastar correr el comando `julia` en una terminal.

La REPL es una consola interactiva que nos permite escribir código (en pocas líneas) y ejecutarlo, correr archivos `.jl`, importar módulos, instalar módulos, acceder a un help y algunas cosas más. Un archivo con código `Julia` puede también ejecutarse de manera directa, sin consola interactiva. También puede usarse `Julia` en una `jupyter-notebook` (incluido Colab, aunque tiene sus vueltas). Y `Julia` cuenta también con su propio sistema de notebooks (`Pluto`) que es un poco distinto de `jupyter`. Por ahora nos concentraremos en la consola. 

La consola nos muestra inicialmente un banner que nos da algo de información sobre la instalación y nos da un _prompt_:

```julia
  julia>
```

Allí podemos escribir código y ejecutarlo (apretando Enter). Para salir de la consola de `Julia` basta con correr la función: 

```julia
  julia> exit()
```

# Modos

Además del prompt para ejecutar código, la consola tiene otros tres modos que resultan muy útiles y la convierten en un entorno muy práctico para usar y gestionar `Julia`. 

- Tipeando `?` se accede al modo <span style="color:orange">help</span>. Si ahí escribimos el nombre de una función, por ejemplo `length`, vemos la documentación de la función. Este modo también permite buscar expresiones regulares. Por ejemplo si buscamos "length" nos devuelve una lista de todas las funciones en cuya documentación aparece la palabra "length".
- Tipeando `;` se accede al modo <span style="color:red">shell</span>, es decir: se obtiene una terminal del sistema operativo. Allí se pueden hacer cualquier operación válida en una terminal: cambiar de directorio, crear archivos, editarlos (con algún editor de terminal), moverlos, etc. Al retornar, la consola de `Julia` queda en el directorio al que nos hayamos movido desde <span style="color:red">shell</span>. 
- `Julia` viene con su propio gestor de paquetes. Se accede a él tipeando `]` (modo <span style="color:blue">pkg</span>). Para instalar paquetes hay que ponerse en modo <span style="color:blue">pkg</span> y tipear:
```julia
  pkg> add NombreDePaquete
```
Para borrar un paquete:
```julia
  pkg> rm NombreDePaquete
```
Para actualizar los paquetes instalados: 
```julia
  pkg> update
```
Cada paquete (módulo) de `Julia` identifica sus dependencias mediante un archivo muy sencillo, de modo que el gestor de paquetes las instala automáticamente.
- Para salir de cualquiera de los modos basta tipear `backspace` (borrar).


# Primeros pasos

Para empezar a familiarizarse con la consola y con el lenguaje, corramos las siguientes líneas y observemos el resultado. 

```julia
  julia> 1 + 2  
  julia> 2/2
```

```julia
  julia> x = 2
  julia> x^2
  julia> y = 3(2x+5); 
  julia> y 
  julia> x*y 
  julia> z = y/x
  julia> typeof(x)
  julia> typeof(z)
``` 

```julia
  julia> x<y
  julia> x>y
  julia> x==y
  julia> x!=y
  julia> w = x<y
  julia> typeof(w)
```

```julia
  julia> texto = "esta es una palabra";
  julia> println(texto[2])
  julia> println(texto[3:8])
  julia> println(texto[5:end])
  julia> typeof(texto)
  julia> texto[4] = "o" 
```



```julia
  julia> a = [1,2,3]
  julia> typeof(a)
  julia> length(a)
  julia> size(a)
  julia> a[2] = 8
  julia> a
  julia> a[3] = 9.5
```

```julia
  julia> b = [1,2.5]
```

## Pasando en limpio

Hasta aquí todo muy sencillo, pero vale la pena remarcar algunos detalles.

- Podemos ejecutar funciones matemáticas básicas y obtener el resultado. 
- Notar que `2/2` da como resultado `1.0`. Es decir: la división `/` devuelve siempre un flotante, incluso si se trata de una división exacta entre enteros. 
- El `;` al final de una sentencia sirve para que la consola no muestre el resultado. Esto es así sólo en la sesión interactiva. En los archivos `.jl` no es necesario utilizar `;`. 
- En `Julia` la multiplicación por un escalar se escribe `*`, pero el símbolo puede omitirse cuando no haya peligro de ambigüedad.
- `Julia` tiene variables de tipo booleano (`true` o `false`). Los operadores `==` (igual), `!=`(distinto), `>`, `<` y varios otros que veremos permiten hacer comparaciones y devuelven un booleano.
- Las comillas dobles `"` permiten definir `Strings`.
- Las `Strings` y los vectores (y muchas otras colecciones) son indexables, pero la indexación comienza en `1` (como en `Matlab` y `Fortran` y al contrario de `C` y `Python`, que empiezan en `0`).
- Se puede indexar usando rangos: `3:8` devolverá todos los casilleros desde el tercero hasta el octavo _inclusive_. 
- Para indexar se usan corchetes `[ ]`, como en `Python` (y no paréntesis como en `Matlab`). 
- No es necesario indicar el tipo de dato de una variable. `Julia` lo infiere (como `Matlab`, `Python` o `R`). La función `typeof()` nos permite conocer el tipo de una cierta variable. En el caso de una colección (como un vector), nos indica el tipo de la colección en sí pero también el tipo de los elementos, e.g.: `Vector{Int64}`.
- Los `Strings` son inmutables: no podemos modificarlos.
- Los vectores son mutables: podemos modificarlos parcial o totalmente. 
- Sin embargo, `Julia` hace lo posible por _respetar_ el tipo de dato con el que la colección fue definida. En el ejemplo, no nos deja cambiar el tipo de dato del vector `a`. Si queremos hacer esto debemos forzar la conversión de `a` a `Vector{Float64}` o realizar alguna otra operación similar.
- Si desde el momento de su creación un vector contiene datos heterogéneos, `Julia` considerará que el tipo de los elementos es el más general (en algún sentido que precisaremos más adelante).

# Segundos pasos

Una de las preocupaciones de `Julia` es la expresividad. La idea es que la matemática se exprese en el código de la manera más sencilla posible. Un pequeño truquito para facilitar esa expresividad es la admisión de caracteres Unicode. Por ejemplo, en `Julia` podemos tener una variable llamada `α`. Para escribirla, basta tipear `\alpha` y luego presionar la tecla `tab`. 

Probar las siguientes sentencias:


```julia
  julia> α = 2//3; β = 1//6;
  julia> α + β
  julia> typeof(α)  
```


```julia
  julia> c = 2+3im
  julia> abs(c) 
```

```julia
  julia> 2÷2
  julia> 7÷3
  julia> 7%3
```
(para obtener `÷`, tipear `\div`+`tab`). 

```julia
  julia> x = 1:10
  julia> typeof(x)
  julia> y = 3:2:1000
  julia> typeof(y)
  julia> length(y)
  julia> collect(x)
  julia> z = collect(y)
  julia> typeof(z) 
  julia> Base.summarysize(z)
  julia> Base.summarysize(y)
```

```julia
  julia> x = collect(x);
  julia> push!(x,2.3)
  julia> x
  julia> typeof(x)
  julia> valor = pop!(x)
  julia> valor
  julia> x
```

```julia
  julia> t= (3,4,7);
  julia> typeof(t)
  julia> t[2]
  julia> t[1:end-1]
  julia> t[1] = 5
```

```julia
  julia> D = divrem(13,5)
  julia> d,r = divrem(13,5)
  julia> d
  julia> r 
  julia> (dd,rr) = divrem(13,5)
  julia> dd
  julia> rr
  julia> r,d = d,r
  julia> print("d:",d,"r:",r)
```


## Pasando en limpio

- `Julia` incorpora caracteres Unicode que suelen tipearse con una sintaxis similar a la de `Latex` (y luego `tab`). Hay que tener en cuenta que cada caracter es independiente de los demás, por lo tanto un subíndice puede escribirse por ejemplo: `\_0`+`tab`. 
- `Julia` tiene números racionales, creados mediante `//`.
- Los números complejos se escriben indicando la unidad imaginaria como `im`.
- `n:m` indica el _rango_ de enteros: `n,n+1,...,m`. Si se intercala otro número, es el paso: `inicio:paso:fin`. En este caso, los números pueden ser flotantes, por ejemplo: `0:0.1:1`. 
- `collect()` convierte el _rango_ (y casi cualquier otra colección) en un vector.
- La función `sizeof()` devuelve el tamaño en bytes que ocupa una variable. Sin embargo, esto encierra una pequeña trampa: un objeto compuesto como un vector tiene una estructura externa (_vector de 10 casilleros_), los elementos que lo componen y eventualmente algunas cosas más (como relaciones entre los elementos, por ejemplo para indexar). La función `sizeof()` sólo devuelve el tamaño de la estructura externa. En cambio `Base.summarysize()` calcula recursivamente el tamaño de toda la estructura. 
- Los _rangos_ se almacenan de manera _lazy_: se guarda la instrucción para construir el rango, pero no los números que lo forman. Por eso ocupa mucho menos espacio que el vector correspondiente.
- Las funciones `push!()` y `pop!()` permiten poner y sacar elementos de un vector (al final). También existen funciones `pushfirst!()` y `popfirst!()`. En este sentido, los vectores puede funcionar como las listas en `Python`. Sin embargo, para otros usos son _vectores_ en el sentido matemático del término. 

<div class="notebox">
<span style="font-weight:bold;color:#0A9090;">Nota:</span>

 El <code>!</code> en el nombre de la función no tiene valor sintáctico. Es sólo una (buena) convención de <code>Julia</code>. Las funciones cuyo nombre termina en <code>!</code> modifican su argumento. Es bueno tenerlo en cuenta y respetar la convención cuando uno escribe sus propias funciones. 

Muchas funciones admiten variantes con y sin <code>!</code>. Por ejemplo: <code>sort</code> recibe un vector y devuelve una copia ordenada, preservando el original. En cambio <code>sort!</code> recibe el vector y lo altera de modo que quede ordenado.
</div>

- En `Julia` hay tuplas, como en `Python`. Se crean con paréntesis, son indexables e **inmutables**. El tipo de una tupla está determinado por los tipos de sus elementos. 
- Hay funciones que devuelven varias cosas. En tal caso, se empaquetan en una tupla. 
- Una tupla puede descomponerse en variables individuales haciendo: `a,b = tupla` o `(a,b)=tupla`. 
- De manera similar se pueden hacer asignaciones simultáneas vía: `a,b = c,d`: el miembro derecho se interpreta como una tupla que se descompone en `a` y `b`. En particular esto puede usarse para intercambiar el valor de dos variables sin necesidad de crear una variable auxiliar intermedia.

# Terceros pasos 

Probemos un poco más de código: 

```julia
  julia> z = begin 
              x = 2
              y = 3
              x*y
            end
  julia> z
  julia> w = (x=5;y=1;x+y)
  julia> w
```

`begin ... end` define un bloque de código. En `Julia` los bloques devuelven el valor de su última expresión. Por eso se asigna a `z` el valor de `x*y`. Lo mismo puede hacerse más compacto separando las expresiones con `;`.



```julia
  julia> f(x) = 2x^2+1
  julia> z = f(2)
  julia> typeof(z)
  julia> w = f(1e-2)
  julia> typeof(w)
```

```julia
  julia> v = [1,2,3]
  julia> f(v)  
```

Definir funciones matemáticas en `Julia` es **muy fácil**. Se puede ver que el código es casi idéntico a lo que escribiríamos en papel. Al evaluar la función, `Julia` se encarga de manejar los tipos de dato adecuadamente. 

Sin embargo, vemos que no se puede evaluar `f` en un vector. A diferencia de lo que ocurre en `Python` o `Matlab`, ninguna operación está definida por defecto para operar casillero a casillero. Es decir que en el ejemplo tenemos problemas por culpa de la operación `^` pero también por culpa de la suma: `+ `. Como veremos en breve, esto es intencional, porque `Julia` tiene una sintaxis muy poderosa para hacer operaciones casillero a casillero. 

Antes de investigar la evaluación casillero a casillero, intentemos graficar `f`. Para ello, usamos el paquete `Plots` que es el estándar para gráficos (hay otros). Para ello corremos: 

```
  julia> using Plots
```

<div class="notebox">
<span style="font-weight:bold;color:#0A9090;">Nota:</span>

 Hay dos comandos para importar paquetes. Uno es <code>import</code>, que es similar al <code>import</code> de <code>Python</code>. Si uno usa <code>import</code> es necesario usar el nombre del paquete como prefijo cada vez que se corre una función: <code>Plots.plot()</code>. El otro es <code>using</code> que trae todas las funciones y no requiere del uso del prefijo (podemos correr directamente <code>plot()</code>). En general en <code>Julia</code> se prefiere <code>using</code>. El principal riesgo de `using` es que como `using` trae todos los _nombres_ del paquete, podría ocurrir que uno quiera usar dos paquetes distintos que repiten el nombre de una función y generar un conflicto. Esta es la razón por la cual `Python` no tiene una sentencia de este tipo y prefiere `import`, que al obligar a usar el nombre del paquete como prefijo permite identificar <i>cuál</i> de las funciones con idéntico nombre se quiere correr. En `Julia` este es un problema  muy improbable y por lo tanto se prefiere `using`. En el caso de haber algún conflicto, `Julia` mostrará un <i>warning</i> indicando exactamente qué funciones se pisan. 
</div>

El primer dibujo simplón se puede hacer simplemente con: 

```
  julia> plot(f)
```

Esto grafica en un dominio asumido por defecto. Si queremos un dominio diferente, necesitamos dar los valores de `x` sobre los que queremos evaluar la función:

```
  julia> plot(-1:0.1:1,f)
```

Notar que en general en otros lenguajes una función como `plot()` requiere dos secuencias de datos: una con valores de `x` y otra con valores de `y`. Aquí le estamos pasando un _rango_ (una forma de vector, digamos) y una _**función**_. 

También funciona en el formato usual. Para ello tendríamos que generar un vector de evaluaciones de `f`. Podríamos hacer esto con un `for`:

```
  julia> x = -1:0.1:1
  julia> y = zeros(length(x))
  julia> for i in 1:length(x)
             y[i] = f(x[i])
         end
  julia> plot(x,y)              
```

En `Julia` todos los bloques de código se cierran con `end` (como en `Matlab`). `i in 1:length(x)` indica que el índice `i` debe moverse dentro del rango de índices de `x`. Una alternativa piola es:

```
  julia> for i in eachindex(x)
  ...
```

La función `eachindex()` devuelve la secuencia de índices de `x` esto tiene varios sentidos: 
- No necesitamos conocer previamente la longitud de `x`. 
- Si bien el estándar es indexar desde 1, `Julia` admite _offset arrays_ (indexados arbitrariamente). `eachindex()` es automáticamente compatible con estos arrays.
- Al recorrer un array se realiza una verificación de que los índices son admisibles. `eachindex()` permite saltearse ese proceso, dado que por definición se correrán índices válidos (de `x`).
- Para codificar caracteres Unicode `Julia` usa el estandar `UTF-8` que es un sistema de longitud variable: los caracteres pueden ocupar entre 1 y 4 bytes. Los índices de un `String` cuentan bytes:
```julia
  julia> a = "αβ∀x"
  julia> length(a)
  julia> a[2]
  julia> for k in eachindex(a)
             println(k)
         end
```
Si en este último ejemplo usáramos `for i in 1:4`, habría un error, pues el índice `2` no existe.


También hay una alternativa más compacta: 

```julia
  julia> y = [f(xx) for xx in x]
  julia> plot(x,y)              
```

Es decir: `Julia` admite definiciones por comprensión, como `Python`. 

## Broadcasting

Sin embargo, el mecanismo más natural para evaluar una función sobre un vector casillero a casillero no es ninguna de las anteriores, sino lo que se llama **broadcasting**: 

```
  julia> y = f.(x)
```

El `.` indica que la función debe aplicarse lugar a lugar. Esto luce similar a `Matlab`, pero en realidad es **considerablemente más poderoso**, como iremos viendo a lo largo del curso. Por ahora observemos que en `Matlab` el `.` debe aplicarse sobre cada operación problemática: `y = x.^2+x.^3`. En `Julia` la sintaxis es general y se aplica a todo el lenguaje. En particular, en este caso lo podemos aplicar directamente a cualquier función: 

```julia
  julia> g(x) = cos(x^2)-exp(x+1)
  julia> y = g.(x)
```

Ni el cuadrado, ni sumar uno, ni la exponencial ni el coseno son funciones admisibles sobre vectores. Sin embargo aplicamos el `.` sólo cuando evaluamos `g`. No se realiza cada operación por separado casillero a casillero, sino que directamente se evalúa `g` en cada lugar. La notación `g.(x)` es equivalente a `broadcast(g,x)`. Volveremos sobre esto más adelante, porque esta sintaxis resulta sumamente poderosa. Por ahora, basta notar que el `.` nos permite aplicar _cualquier función_ casillero a casillero.

Por último, ¿Cómo hacemos dos gráficos juntos?

```julia
  julia> plot(x,f.(x))
  julia> plot!(x,g.(x))
```

Hay dos versiones de `plot`: `plot` y `plot!`. La segunda _modifica_ el gráfico existente y por lo tanto hace el segundo gráfico sobre el primero. 

# JIT

Una de las razones primordiales que hacen de `Julia` un lenguaje muy veloz es que utiliza un mecanismo denominado _just in time compilation_. La primera vez que se ejecuta una función, se la compila. Es decir: se traduce el código a lenguaje de máquina y se lo almacena en memoria. Las siguientes ejecuciones de la misma función serán muchísimo más veloces. 

Pongamos esto a prueba. Cerremos la sesión (`exit()`) y abramos una nueva. Luego ejecutemos el siguiente código:
```julia
  julia> using Plots
  julia> x = 0:0.1:1; y = x.^2; z = cos.(x);
  julia> @time plot(x,y)  
```

`@time` nos permite calcular el tiempo que demora la ejecución de una función (y algunas cosas más). Se observa que el gráfico demora una fracción de segundo bastante perceptible, pero `@time` nos indica que la mayor parte de ese tiempo fue `compilation time`. 

Corramos ahora: 

```julia
  julia> @time plot(x,z)
```

Se observa que la ejecución es mucho más veloz y `@time` ya no reporta tiempo destinado a compilación. 

<div class="importantbox">
<span class="importantit">Importante:</span>

La <code>JIT compilation</code> le permite a <code>Julia</code> alcanzar velocidades cercanas (¡o mayores!) a las de lenguajes compilados <i>ahead of time</i> como <code>C</code> o <code>Fortran</code>. Sin embargo, tiene el pequeño costo de que la <i>primera</i> ejecución de una función incluye el proceso de compilación. A esto se lo conoce como <i>problema del primer plot</i> justamente porque los <i>plots</i> suelen ser costosos y es una de las operaciones <i>simples</i> en las que el fenómeno resulta más notorio. Este problema puede eludirse haciendo compilación <i>ahead of time</i> (hay un paquete para eso). Los paquetes también tienen instrucciones de <i>precompilación</i>, es decir que cuando uno los importa usando `using` ya compilan algunas de sus funciones para tipos de datos usuales, acelerando el tiempo incluso de la primera corrida. Pero además cada nueva versión de <code>Julia</code> mejora el compilador y por lo tanto achica los tiempos de espera de las primeras corridas. Por último: veremos más adelante que uno puede hacer algunas cosas al programar para minimizar el impacto de este problema. 
  </div>

<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/"> << Volver al índice</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-1/clase-1-2"> >> Ir a la parte 2</a> 
</div>
