---
layout: default
title: "Clase 4 - Primera parte - Definiendo tipos propios"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Implementado tipos propios:

La idea de esta clase va a ser implementar un tipo de dato propio y agregarle algunas funcionalidades. Como ejemplo, vamos a implementar polinomios.

## Polinomios

Para definir un polinomio sólo necesitamos sus coeficientes. Podemos empaquetar los coeficientes dentro de un vector. Fijamos la convención de que el vector comienza por el término independiente y concluye en el coeficiente principal.
Con esta idea implementamos una estructura que contiene un único atributo, que es un vector. Podríamos escribir: 

```julia
struct Polinomio
  coef::Vector
end
```

La anotación de tipo `::Vector` no es imprescindible. Escribir un archivo con esta definición y cargarlo en una consola. Luego, podemos probar nuestra estructura: 

```julia
  julia> Polinomio([2,3,4])
```

Vemos que al generar una estructura inmediatamente tenemos un método para crear instancias de esa estructura. `Polinomio` es el nombre del tipo de dato, pero también es el nombre de la función que permite construir un `Polinomio`. 

Hasta aquí vamos bien. Pero...

```julia
  julia> Polinomio(["este","es","un","polinomio"])
```

Esta operación es perfectamente legítima, porque nuestro constructor de polinomios sólo requiere un vector. Aquí le dimos un vector de `String`s, cosa que tiene sentido para el código, pero no matemáticamente. Si queremos impedir este comportamiento, tenemos que ser más precisos con nuestro código. Reformulamos la definición del siguiente modo: 

```julia
struct Polinomio{T<:Number}
  coef::Vector{T}
end
```

`Julia` **no** nos permite recargar el archivo. Esto es porque crear una nueva `struct` altera el árbol de tipos y esta alteración no es reversible dentro de la sesión. Hay que cerrar y reabrir la sesión de la consola para poder cargar el archivo nuevamente.

Probemos ahora: 
```julia
  julia> p = Polinomio([1,2,3])
  julia> q = Polinomio([2.4,1,2])
  julia> typeof(p)
  julia> typeof(q)
  julia> supertype(Polinomio)
  julia> Polinomio(3,5,1)
```

Vemos que `Julia` infiere el valor del parámetro `T` en función de los datos con los cuales creamos el polinomio. Sin embargo, no es capaz de crear un polinomio a partir de números sueltos. El constructor por defecto espera recibir variables que le permitan cubrir los campos respetando sus tipos. Podemos definir constructores nuevos que faciliten la tarea. Por ejemplo: 

```julia
Polinomio(x...) = Polinomio([x...])
```
El operador _splat_ `...`  sirve en este caso para representar un número indefinido de parámetros. Es decir que `x...` juega el papel de `x1,x2,x3,...`. La definición indica que si `Polinomio` recibe un número indefinido de variables sueltas, debe encapsularlas en un vector y ejecutar el constructor por defecto. Es decir, creamos un nuevo método para el constructor que llama al método original. Cargar esta función en el archivo, recargarlo (ahora no hace falta reiniciar) y volver a probar: 
```julia
  julia> p = Polinomio(3,5,1)
  julia> q = Polinomio([3,5,1])
  julia> p === q
  julia> Polinomio(3,0,0)
```

Vemos que aún perdura algún pequeño inconveniente para la buena definición de un polinomio: nuestro constructor admite ceros en los coeficientes más grandes. Para evitar este problema necesitamos _pulir_ nuestro constructor _interno_ (es decir, el que se ejecuta por defecto). Eso lo podemos hacer definiendo un constructor especial dentro de la definición de la estructura: 

```julia
struct Polinomio{T<:Number}
    coef::Vector{T}
    function Polinomio(v)
        while v[end] == 0 && length(v)>1
          pop!(v)
        end
        new{eltype(v)}(v)
    end
end
```

La función `Polinomio` definida dentro de la estructura es un _constructor interno_. Dado que  puede ser problemática llamar a la función `Polinomio` dentro de la definición de `Polinomio`, para esta situación especial existe la función `new`. `new` debe usarse poniendo entre llaves los tipos de dato que definen la estructura (en este caso `T`) y pasándole como variables los valores que deben asignarse a los campos definidos internamente. En este caso, extraemos de `v` todos los ceros del final y recién después creamos el nuevo `Polinomio`. La condición `length(v)>1` hace que al finalizar el `while` `v` tenga al menos longitud `1`. De esta manera admitimos la construcción del polinomio nulo. 

Nuevamente tenemos que reinciar la consola, dado que alteramos un tipo de dato. 

Al recargar nuestro archivo podemos crear polinomios tanto con vectores como con tiras de coeficientes. Si quisiéramos algún otro mecanismo cómodo para crear un polinomio (e.g.: dándole una `Tuple` de coeficientes), podemos definir un constructor específico. 

Hagamos algo más divertido: al crear un polinomio obtenemos algo del estilo: 
```julia
Polinomio{Int64}([1,2,3])
```
Sería mejor ver el polinomio como lo escribimos matemáticamente. Para mostrar una variable la consola ejecuta la función `show` que está definida en `Base` (la instalación base de `Julia`). Para definir nosotros cómo queremos mostrar un polinomio debemos agregar un nuevo método a la función `show`. Además, necesitamos indicar que cuando hablamos de `show` no estamos definiendo una función nueva sino un nuevo método para `Base.show`. Esto se hace así: 


```julia
import Base: show

function show(io::IO,mime::MIME"text/plain",p::Polinomio)
    c = p.coef
    print(c[1])
    for i in 2:length(c)
        if c[i] != 0
            print(" + ",c[i],"x^",i-1)
        end
    end
end
```
+ El `import` conviene ponerlo en la primera línea del archivo, para que todos lo que se importe quede claro desde el arranque y no se pierda en el medio del código. 
+ `show` debe recibir un objeto de tipo `IO` (input-output) y otro de tipo `MIME"text/plain"` y  el dato que querramos mostrar. No hace falta usar `io` ni `mime` para nada. En el uso normal, estos parámetros estarán definidos por la consola.
+ Imprimimos el primer coeficiente y luego imprimimos los siguientes siempre que sean no nulos. cada coeficiente va acompañado de `x^` y la potencia correspondiente.  

Una vez implementada esta función, podemos volver a cargar el archivo y crear un nuevo polinomio. Lindo, ¿no? Por supuesto, la función se puede pulir un poquito más, por ejemplo: para que no escriba el coeficiente si es un `1`. 


Ahora empieza la diversión: 

**Ejercicio:** Implementar la función `coeficientes`, que devuelva un vector con los coeficientes del polinomio. 

**Ejercicio:** Implementar la función `grado` que devuelva el grado del polinomio.

**Ejercicio:** Queremos sumar polinomios. Para ello, necesitamos implementar un método para la función suma. Como en el caso de `show`, lo que queremos es implementar un nuevo método para `Base.+`. En la primera línea del archivo podemos poner: 
```julia
import Base: +
```
También podemos combinar todos estos imports en una sola línea: 
```julia
import Base: +,show
```

Hecho esto, podemos implementar la función `+(p::Polinomio,q::Polinomio)`. Esta función debe tomar los coeficientes de `p` y `q`, crear un nuevo vector `r` para los coeficientes del resultado (tan largo como el más largo entre `p` y `q`), rellenar este vector con la suma coeficiente a coeficiente de `p` y `q`  y devolver un nuevo polinomio creado a partir de `r`.

**Ejercicio:** Un polinomio es una función. Nos gustaría poder evaluarla. Para ello, implementar la función correspondiente. La sintaxis del encabezado debe ser:
```julia
function (p::Polinomio)(x::Number)`
```

**Observación:** Por el momento, nos conformamos con evaluar el polinomio de la manera _ingenua_. En la práctica se usa el método de Horner, que es un algoritmo optimizado para evaluar un polinomio minimizando el número de productos y sumas a realizar.  

**Ejercicio:** Si las funciones anteriores están bien, las siguientes pruebas deberían funcionar según lo esperado

```julia
  julia> p = Polinomio(2,3,1)
  julia> q = Polinomio(1,-3)
  julia> r = p+q
  julia> q(2)
  julia> r(2.5)
  julia> r(1//2)
  julia> v = [p,q,r]
  julia> s = sum(v)
  julia> w = rand(5)
  julia> s.(w)
  julia> using Plots
  julia> x = -1:0.01:1
  julia> plot(x,p.(x))
```

Aquí graficamos aprovechando que podemos evaluar `p`.  Antes vimos que podíamos graficar una función haciendo simplemente `plot(f)`. Si queremos hacer reproducir este comportamiento con los polinomios, tenemos dos opciones:

+ Implementar métodos especializados para la función `plot`:
```julia
import Plots.plot
```julia
plot(x,p::Polinomio) = plot(x,p.(x))
plot(p::Polinomio) = plot(-5:0.01:5,p) 
```
El primer método indica que si recibo un `x`, debemos evaluar el polinomio en `x` para graficar. El segundo fija un intervalo por default en el caso en que `plot` se llame directamente sobre `p`. 
+ También podemos definir `Polinomio` como subtipo de `Function`. Es decir, modificar la definición de nuestra estructura por:
```julia
  struct Polinomio{T<:Number} <: Function
```
De este modo, aún sin haber dado definiciones especiales para `plot`, cuando se ejecute `plot(p)` o `plot(x,p)`, `Julia` no encontrará un método especial para ejecutar `plot` sobre un `Polinomio`, y entonces buscará el método para el supertipo de `Polinomio`, es decir `Function`. Encontrará tal método y lo ejecutará. Muy posiblemente, esta segunda variante nos permitirá heredar automáticamente otros comportamientos que estén definidos para `Function`. En general, cualquier método que exista para `Function` y que sólo requiera evaluar la función será **automáticamente** válido para nuestros polinomios. 


Cargando nuevamente el archivo podemos correr: 

```julia
  julia> plot(p)
```
y funcionará, cualquiera sea la alternativa que hayamos usado. 


Para agregar la resta de polinomios debemos definir un método para `-`. Agregamos: 
```julia
import Base:-
```
`-` cumple dos funciones: es la resta (operador binario, aplicado a dos cosas), pero también es el negativo (operador unario, aplicado a una sola cosa). Podemos definir ambas: 
```julia
-(p::Polinomio) = Polinomio(-coeficientes(p))
-(p::Polinomio,q::Polinomio) = p + (-q)
```

Cabe remarcar la elegancia de estas definiciones que semejan las correspondientes definiciones matemáticas y nos permiten **no** escribir un algoritmo completo para la resta, sino sólo ejecutar el que ya escribimos para la suma. 

Con esto queda bien definida la resta de polinomios, pero también la expresión:
```julia
  julia> -p
```

Algunos ejercicios extra para entretenerse: 

**Ejercicio:** Implementar el producto entre un escalar y un polinomio. 

**Ejercicio:** Implementar el producto entre dos polinomios. 

**Ejercicio:** Implementar una función `desdeRaices` que reciba las raíces del polinomio y construya el polinomio. 

**Ejercicio:** Implementar una función `derivar(p::Polinomio)` que devuelva un polinomio con los coeficientes correspondientes al derivado de `p`. Tener en cuenta que en general el polinomio derivado tendrá un coeficiente menos que el original, salvo en el caso en que `p` sea constante. En esta situación queremos obtener el polinomio nulo (con un coeficiente, igual a `0`). 

**Ejercicio:** Implementar una función `integrar(p::Polinomio,a,b)` que integre el polinomio `p` en el intervalor `[a,b]`.

**Ejercicio:** Implementar un método para la función `divrem(p::Polinomio,q::Polinomio)` que calcule la división y el resto de `p` dividido `q`. (Hay que agregar: `import Base: divrem`).

Hay muchísimas más cosas que podrían implementarse (algoritmos especializados para buscar raíces, expansiones en bases de polinomios conocidas, etc..). 

Por supuesto, todo esto ya existe, en la librería `Polynomials`. 

<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-3/clase-3-2"> Volver a la clase 3</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-4/clase-4-2"> Ir a la segunda parte</a> 
</div>
