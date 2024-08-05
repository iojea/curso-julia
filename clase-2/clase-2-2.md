---
layout: default
title: "Clase 2 - Segunda parte - Multiple Dispatch"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Multiple Dispatch

Ya hablamos del mecanismo de _Just in time compilation_, que es una de las razones que dan lugar a la gran performance de `Julia`. El otro elemento fundamental del mix es la técnica de _multiple dispatch_. Veamos en qué consiste. 

Ya vimos que las siguientes variantes son todas admisibles:
```julia
  julia> using Plots
  julia> f(x) = 2x^2+3cos(x)
  julia> plot(f)
  julia> x = -1:0.1:1
  julia> y = f.(x)
  julia> plot(x,f)
  julia> plot(x,y)
  julia> plot(collect(x),y)
```

El primer `plot` recibe una función. El segundo un rango y una función. El tercero, un rango y un vector. El cuarto, dos vectores. Esto no es habitual. En lenguajes como `C`, cuando uno declara una función debe indicar los datos que recibe, junto con su tipo y la función sólo podrá aplicarse a datos de ese tipo. En `Python` no hace falta aclarar los tipos, y para ciertas cosas hay tipos que pueden ser intercambiables (por ejemplo: si uno itera a lo largo de un objeto es indistinto si el objeto es un array, una lista o un rango). Sin embargo, una función y un vector no se parecen de modo en `Python` difícilmente podrían ocupar el mismo lugar en el llamado a una función. Es decir: si se usa el nombre `plot` para indicar el gráfico de un vector vs otro vector, habrá que usar _**otro**_ nombre para la función que reciba un vector y una función. En `Python` (y todos los lenguajes orientados a objetos, como `C++`), se pueden definir funciones dentro de un objeto, que le pertenecen. Esto permite repetir nombres. Por ejemplo, tanto una lista como un array pueden tener una función `append`. La sintaxis para aplicar la función es `lista.append(elemento)` o `array.append(elemento)`. `Python` sabe qué función debe ejecutar porque la sintaxis `objeto.` le indica dentro de qué objeto está la definición de la función. A esto se lo llama _single dispatch_. Es decir: el intérprete o el compilador sabe qué función `append` ejecutar mirando un único tipo: el del objeto que llamó a la función. 

`Julia` no es un lenguaje orientado a objetos. Las funciones son externas y no le pertenecen a ningún objeto. Pero implementa un sistema de _multiple dispatch_ que permite definir muchas funciones con el mismo nombre. Para decidir cuál función correr, `Julia` mira los tipos de datos que se le dieron a la función y elige el método más adecuado. Para poner en marcha este mecanismo es necesario _anotar_ los tipos de datos al definir una función. 

Veamos un ejemplo: 

```julia
  julia> g(x::Int64) = println("recibí un entero")
  julia> g(x::Float64) = println("recibí un flotante")
  julia> g(2)
  julia> g(2.5)
```

<div class="importantbox">
<span class="importantit">Importante:</span>

El término correcto para denominar las distintas versiones de una función es <i>método</i>. Decimos que `g` es <b>una</b> función con dos métodos. 
</div>

Esta es la **principal** aplicación de las anotaciones de tipo en `Julia`. 


<div class="importantbox">
<span class="importantit">Muy importante:</span>

El <i>multiple dispatch</i> <b>no es sólo</b> un chiche. Permite la repetición de nombres de funciones y le simplifica la vida al usuario que sabe que si tiene que hacer un <code>plot</code> seguramente tendrá que usar el comando <code>plot</code>, independientemente de qué es lo que quiera graficar. 

La principal ventaja del <i>multiple dispatch</i> es que le permite al compilador decidir qué método quiere aplicar y usar el más adecuado al tipo de dato ingresado. Esto, a su vez, hace que el compilador pueda aplicar una serie de optimizaciones específicas para ese tipo de dato, lo que redunda en una mejor performance. Lo que hace que <code>Julia</code> pueda competir con <code>Fortran</code> o `C` es la <b>combinación</b> de <b>just in time compilation</b> con un muy buen sistema de <b>multiple dispatch</b>.
</div>

Veamos un ejemplo apenas más sofisticado:

```julia
  julia> h(x) = println("Esta es la función por defecto") 
  julia> h(x::Number) = println("Recibí un número")
  julia> h(x::String) = println("Recibí una cadena de caracteres")
  julia> h(2)
  julia> h(2.5)
  julia> h(2//3)
  julia> h("palabra")
  julia> h([1,2,3])
  julia> h((1,2))
  julia> h(1,2)
  julia> h(x::Rational) = println("Recibí un número racional")
  julia> h(3//4)
  julia> h(2.5)
```

Aquí se observan varias cosas: 

- Existe un tipo de dato `Number` que de alguna manera alberga a enteros, flotantes, racionales, etc. Presumiblemente, a todo lo que de verdad sea un número. 
- `Julia` _elige_ qué método ejecutar en función del tipo de dato que recibe. En particular, elige el método cuya definición **que mejor se ajusta** al dato recibido. En el primer tramo de código, cualquier número cae bajo el método definido para `Number`. Como no hay método específico para vector o tupla, se aplica el método más general (el que no tiene ninguna anotación). Sin embargo, luego de definir un método específico para `Rational`, al recibir números racionales aplica éste, que es más preciso que el genérico para `Number`, mientras que para el dato `2.5` sigue aplicando el método de `Number`, que es el más ajustado para un flotante. 

Veamos un ejemplo concreto de uso del _multiple dispatch_. Probar lo siguiente: 

```julia
  julia> using BenchmarkTools
  julia> x = rand(10_000_000);
  julia> @benchmarck sort($x)
  julia> @benchmark sort(1:10_000_000)
  julia> @benchmark sort(10_000_000:-1:1)
  julia> y = sort(x);
  julia> @benchmark sort($y)
  julia> sort(10_000_000:-1:1)
```

`BenchmarkTools` es un paquete que contiene algunas herramientas para testear performance, más sofisticadas que `@time`. En particular, `@benchmark` corre muchas veces la función que le pasamos, y nos devuelve información diversa acerca de todas las corridas, incluido un histograma de tiempos. Conviene poner `$` antes del nombre de la variable que le pasamos a la pasamos porque estamos usando variables globales que son más difíciles de gestionar para el compilador. Al usar `$` pasamos el valor de la variable como si fuera una variable local, lo que da mediciones más confiables (y más parecidas a lo que se obtiene en un uso realista de la función).

Observamos que ordenar _rangos_, sean crecientes o decrecientes, es mucho más rápido que ordenar vectores, incluso cuando los vectores ya están ordenados. ¿Por qué será así?  Investiguemos. Si corremos: 

```julia
  julia> sort
  julia> methods(sort)
```

Vemos que `sort` es una función con 4 métodos (5, si tenemos `BenchmarkTools` cargada, y quizá más si ya cargamos otros paquetes, porque los paquetes pueden definir nuevos métodos para la misma función). En particular, la función `methods` nos indica cuáles son estos métodos: 

```julia
  julia> methods(sort)
 [1] sort(r::AbstractUnitRange)
     @ range.jl:1410
 [2] sort(r::AbstractRange)
     @ range.jl:1413
 [3] sort(v::AbstractVector; kws...)
     @ Base.Sort sort.jl:1489
 [4] sort(A::AbstractArray{T}; dims, alg, lt, by, rev, order, scratch) where T
     @ Base.Sort sort.jl:1783
```

Sin adentrarnos demasiado en la notación, es fácil interpretar que tenemos: 

- Un método que funciona simultáneamente para orderar `AbstractUnitRange`: aún no está claro qué significa `Abstract`, pero `UnitRange` son rangos que saltan de a `1`, es decir, los que se crean por defecto cuando uno no aclara el paso. 
- Un método para `AbstractRange` (suponemos que serán _rangos_, en general)
- Un método para `AbstractVector` (suponemos que serán _vectores_, en general)
- Un método para `AbstractArray{T}`. De nuevo, no está claro que significa la notación `{T}`, pero parece referir a `Arrays` en general (por ejemplo: matrices).

Además, `methods` nos informa **dónde** están definidos los métodos. Por ejemplo, el método para `AbstractUnitRange` está en el archivo `range.jl` en la línea 1410 y el de `AbstractRange` en el mismo lugar, en la línea `1413`. Al no haber aclaraciones sabemos que `range.jl` está en el núcleo de `Julia`. Los métodos para `AbstractVector` y `AbstractArray` pertenecen al módulo interno `Base.Sort` (o sea: están en la instalación básica, pero tiene a un submódulo destinado a `Sort`), en el archivo `sort.jl` y en las líneas `1489` y `1783`, respectivamente. 

En nuestro caso no es difícil inferir qué método está aplicando `Julia` en cada caso (`AbstractVector` para `x`, `AbstractUnitRange` para `1:10_000_000` y `AbstractRange` para `10_000_000:-1:1`). Sin embargo, si estamos en duda, pordemos usar `@which`:

```julia
  julia> @which sort(1:10_000_000)
```
Esto nos devuelve exactamente qué método está usando para la aplicación concreta de la función. 

Queremos ver qué hace exactamente el `sort` cuando lo aplicamos a un _rango_. Podemos ir a buscar estos archivos explorando _a mano_ la carpeta de instalación de `Julia` (en `Unix` típicamente es `/home/nombre_de_usuario/.julia/`). Pero no hace falta. `Julia` nos provee de herramientas para inspeccionar su código directamente desde la consola. Tenemos dos opciones: 

- `@edit`: aplicado del mismo modo que `@which` nos abre el archivo en el que se encuentra definido el método, posicionado sobre el método, en nuestro editor de código por defecto. **Importante:** esto requiere que haya un editor por defecto definido en el sistema, o más específicamente, que esté definida la variable de entorno `JULIA_EDITOR`. Si esto no es así, seguramente `@edit` dará un error indicando este problema. En sistemas `Unix`, dentro del `home` del usuario (`/home/nombre_de_usuario/` o simplemente `~/`) hay un archivo de configuración de la shell por defecto: típicamente `.bashrc` o `.zshrc`). Podemos definir el editor por defecto abriendo ese archivo y tipeando (al final): `export EDITOR = vscode` (donde `vscode` puede reemplazarse por el comando que abre el editor de preferencia). Podemos también definir: `export JULIA_EDITOR = vscode`. Guardamos el archivo y en una nueva sesión de `Julia` `@edit` debería funcionar correctamente. 
- `@less`: Hace lo mismo que `@edit`, pero en lugar de abrir nuestro editor por defecto abre un _paginador_ que cuyo nombre es `less`. Este paginador nos permite navegar el archivo, pero no editarlo. Podemos subir y bajar con las flechas o con `k` y `j`. Para salir del paginador basta presionar `q`. 
- Además, si estamos en `VSCode` y tenemos un archivo que contiene una llamada a una función, como `sort(1:10_000_000)`, podemos posicionarnos sobre esta línea y click derecho y luego seleccioar `Go to Definition`, y nos despliega la definición del método. 

Al hacer esto, vemos que la definición de `sort` para `AbstractUnitRange` es simplemente 
```julia
  julia> sort(r::AbstractUnitRange) = r
```
Es decir, como `Julia` sabe que, por definición, un `AbstractUnitRange` está ordenado, cuando alguien intenta ordenarlo, `Julia` simplemente devuelve lo mismo que recibió y no hace **ninguna** operación. Por eso es tan rápido. Además, tenemos que la definición para `AbstractRange` también es muy sencilla:
```julia
sort(r::AbstractRange) = issorted(r) ? r : reverse(r)
```
Aquí `Julia` verifica si el rango está ordenado, en cuyo caso devuelve `r`. En caso contrario, devuelve `reverse(r)`, es decir, el rango dado vuelta. Unas líneas podemos ver que `issorted` también tiene un método especialmente definido para `AbstractRange` que lo único que hace es fijarse si el `step` que define el rango es positivo o negativo. 

La arquitectura del método de `sort` para `AbstractVector` es bastante más compleja (previsiblemente), pero podríamos explorarla usando el mismo mecanismo. Observamos que todas estas funciones están escritas _in plain Julia_ y podemos acceder a ellas sin problema. 

<div class="notebox">
<span class="notetit">Nota:</span>

Cuando hablamos de `using`  e `import` mencionamos que en `Julia` suele usarse `using`, porque es poco probable que un paquete _pise_ el nombre de una función definido en otro paquete. La razón es que en realidad _pisar_ un nombre no es un pobrema, si se lo hace declarando adecuadamente el tipo de dato: esto sólo crea un **nuevo método** para la misma función. De modo que muchos paquetes pueden volver a definir la misma función, incluso aunque esa función esté definida en el núcleo de `Julia`. Más adelante veremos que la posibilidad de agregar métodos a funciones definidas en otras librerías o en el núcleo de `Julia` es un instrumento **muy** poderoso. 
</div>


<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-2/clase-2-1"> << Volver a la primera parte</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-3/clase-3-1"> >> Ir a la clase 3</a> 
</div>
