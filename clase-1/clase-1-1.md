# Intro a `Julia`

## Clase 1: Parte 2

### Instalación

`Julia` es gratuito y de código abierto (no sólo eso sino que, como remarcaremos reiteradamente, la mayor parte del código ¡está escrito en `Julia`!). La instalación es muy sencilla, siguiendo las instrucciones en el sitio de [Descargas](https://julialang.org/downloads/). La opción recomendada es abrir una terminal y correr el siguiente código (requiere conexión a internet):

##
    curl -fsSL https://install.julialang.org | sh

Esto instala `juliaup` que es una aplicación para mantener y actualizar `Julia` y además corre `juliaup` instalando la versión actual de `Julia`. En el futuro se podrá actualizar a la versión más reciente de `Julia` corriendo en una terminal: 

```
> juliaup update
```

La segunda alternativa es bajar un instalador o un binario específico para el sistema operativo en el que se quiera instalar (más abajo, en la misma página). Esto sólo instala `Julia`.

En cualquiera de los casos se obtendrá una instalación del núcleo de `Julia` (lo que se llama `Julia Base`) más algunas librerías consideradas básicas (`Statistics`, `LinearAlgebra`, etc.) que se incluyen en el paquete básico pero deben importarse en caso de querer usarlas. Existen muchísimos otros paquetes, que pueden instalarse aparte (desde `Julia`). 

### La (o el?) REPL

Una vez realizada la instalación lo más común (y recomendable) es usar `Julia` a través de la REPL (Read, Eval, Print Loop), a la que llamaremos simplemente "consola". En Windows probablmente se genere un ícono de `Julia`, que permitirá abrir la consola. En Linux y MacOS debería bastar correr el comando `julia` en una terminal.

La REPL es una consola interactiva que nos permite realizar escribir código (en pocas líneas) y ejecutarlo, correr archivos de código `Julia`, importar módulos, instalar módulos, acceder a un help y algunas cosas más. Un archivo con código `Julia` puede también ejecutarse de manera directa, sin consola interactiva. También puede usarse `Julia` en una `jupyter-notebook`. Y `Julia` cuenta también con su propio sistema de notebooks (`Pluto`) que es un poco distinto de `jupyter`. Por ahora nos concentraremos en la consola. 

La consola nos muestra inicialmente un banner que nos da algo de información sobre la instalación y nos da un _prompt_:

```julia
  julia>
```

Allí podemos escribir código y ejecutarlo (apretando enter). Para salir de la consola de `Julia` basta con correr la función: 

```julia
  julia> exit()
```

### Primeros pasos

Para empezar a familiarizarse con la consola y con el lenguaje, sugiero correr las siguientes líneas y observar el resultado. 

```julia
  julia> 1 + 2  
```

```julia
  julia> 2/2
```

```julia
  julia> x = 2
```
```julia
  julia> y = 5;  
```

```julia
  julia> x*y 
```

```julia
  julia> texto = "esta es una palabra";
```

```julia
  julia> println(texto[2])
```

```julia
  julia> println(texto[3:8])
```

```julia
  julia> println(texto[5:end])
```

```julia
  julia> texto[4] = "o" 
```

```julia
  julia> z = y/x
```

```julia
  julia> typeof(x)
```

```julia
  julia> typeof(z)
```

```julia
  julia> typeof(texto)
```

```julia
  julia> a = [1,2,3]
```

```julia
  julia>  typeof(a)
```

```julia
  julia> length(a)
```

```julia
  julia> size(a)
```

```julia
  julia> a[2] = 8
```

```julia
  julia> a
```


#### Pasando en limpio

Hasta aquí todo muy sencillo, pero vale la pena remarcar algunos detalles.

- Podemos ejecutar funciones matemáticas básicas y obtener el resultado. 
- Notar que `2/2` da como resultado `1.0`. Es decir: la división `/` devuelve siempre un flotante, incluso si se trata de una división exacta entre enteros. 
- El `;` sirve para que la consola no muestre el resultado de la operación. Esto es así sólo en la sesión interactiva. En los archivos `.jl` no es necesario utilizar `;`. 
- Las comillas dobles `"` permiten definir `Strings`.
- Las `Strings` y los vectores (y muchas otras colecciones) son indexables, pero la indexación comienza en `1` (como en `Matlab` y `Fortran` y al contrario de `C` y `Python`, que empiezan en `0`).
- Se puede indexar usando rangos: `3:8` devolverá todos los casilleros desde el tercero hasta el octavo _inclusive_. 
- Para indexar se usan corchetes `[ ]`, como en `Python` (y no paréntesis como en `Matlab`). 
- No es necesario indicar el tipo de dato de una variable. `Julia` lo infiere (como `Matlab`, `Python` o `R`). La función `typeof()` nos permite conocer el tipo de una cierta variable. En el caso de una colección (como un vector), nos indica el tipo de la colección en sí pero también el tipo de los elementos: `Vector{Int64}`.
- Los `Strings` son inmutables: no podemos modificar un caracter. 
- Los vectores son mutables: podemos modificarlos parcial o totalmente. 

### Segundos pasos

Una de las preocupaciones de `Julia` es la expresividad. La idea es que la matemática se exprese en el código de la manera más sencilla posible. Un pequeño truquito para facilitar esa expresividad es la admisión de caracteres unicode. Por ejemplo, en `Julia` podemos tener una variable llamada `α`. Para escribirla, basta tipear `\alpha` y luego `tab`. 

Probar las siguientes sentencias:


```julia
  julia> α = 2//3; β = 1//6;
  julia> α + β
  julia> typeof(α)  
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
  julia> sizeof(z)
  julia> sizeof(y)
```

> [!Pequeñas magias de la REPL, capítulo 1]
> ¿Qué hace la función `sizeof()` y por qué da distinto en `y` y en `z`? 
> Si tipeamos `?`:
> ```julia
>   julia>? 
> ```
> la consola de `Julia` pasa a modo **help**. Allí podemos tipear el nombre de la función que nos interesa, en este caso `sizeof`, y obtener una descripción de lo que hace la función. 
> `sizeof` nos devuelve el espacio en bytes que ocupa la variable. 
> Para salir del modo **help** basta con teclear `backspace` (borrar). 





