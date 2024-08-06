---
layout: default
title: "Clase 4 - Primera parte - Definiendo tipos propios"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Implementado tipos propios:

La idea de esta clase va a ser implemtentar un tipo de dato propio y agregarle algunas funcionalidades. Como ejemplo, vamos a implementar polinomios.

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

Esta operación es perfectamente legítima, porque nuestro constructor de polinomios sólo requiere un vector. Aquí le dimos un vector de `String`s, cosa que tiene sentido para el código, pero no matemáticamente. Si queremos impedir este comportamiento, tenemos que ser más precisos con nuestro código. Reformulamos la defición del siguiente modo: 

```julia
struct Polinomio{T<:Number}
  coef::Vector{T}
end
```
o, equivalentemente
```julia
struct Polinomio{T} where T<:Number
  coef::Vector{T}
end
```
`Julia` no nos permite recargar el archivo. Esto es porque crear una nueva `struct` altera el árbol de tipos. Hay que cerrar y reabrir la sesión. 

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
El operador _splat_ `...` cumple sirve en este caso para representar un número indefinido de parámetros. Es decir que `x...` juega el papel de `x1,x2,x3,...`. La definición indica que si `Polinomio` recibe un número indefinido de variables sueltas, debe encapsularlas en un vector y ejecutar el constructor por defecto. Es decir, creamos un nuevo método para el constructor que llama al método original. Cargar esta función en el archivo, recargarlo (ahora no hace falta reiniciar) y volver a probar: 
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

La función `Polinomio` definida dentro de la estructura es un _constructor interno_. Dado que  puede ser problemática llamar a la función `Polinomio` dentro de la definición de `Polinomio`, para esta situación especial existe la función `new`. `new` debe usarse poniendo entre llaves los tipos de dato que definen la estructura (en este caso `T`) y pasándole como variables los valores que deben asignarse a los campos definidos internamente. En este caso, extraemos de `v` todos los ceros del final y recién después creamos el nuevo `Polinomio`. Pedimos que `length(v)>1` para admitir la construcción del polinomio nulo. 

Nuevamente tenemos que reinciar la consola, dado que alteramos un tipo de dato. 

Al recargar nuestro archivo podemos crear polinomios tanto con vectores como con tiras de coeficientes. Si quisiéramos algún otro mecanismo cómodo para crear un polinomio (e.g.: dándole una `Tuple` de coeficientes), podemos definir un constructor específico. 

Hagamos algo más divertido: al crear un polinomio obtenemos algo del estilo: 
```julia
Polinomio{Int64}([1,2,3])
```
Sería mejor ver el polinomio como lo escribimos matemáticamente. Para esto tenemos que definir un nuevo método para la función `show`.

```julia
function Base.show(io::IO,p::Polinomio)
    c = p.coef
    print(c[1])
    for i in 2:length(c)
        if c[i] != 0
            print(" + ",c[i],"x^",i-1)
        end
    end
end
```

+ La definición de la función es `Base.show` porque debemos indicar que estamos definiendo un nuevo método de la función `show` que está definida en la instación básica de `Julia` (y no una nueva función `show` en un entorno diferenciado).
+ `Base.show` debe recibir un objeto de tipo `IO` (input-output) y el dato que querramos mostrar. No hace falta usar `io` para nada. Por defecto, `io` será la consola. 
+ Imprimimos el primer coeficiente y luego imprimimos los siguientes siempre que sean no nulos. cada coeficiente va acompañado de `x^` y la potencia correspondiente.  

Ahora empieza la diversión: 

**Ejercicio:** Implementar una función que se llame `_completar` que reciba dos vectores `v` y `w`. Si tienen la misma longitud, los debe devolver tal como los recibió. Si hay uno más corto que el otro (digamos `v` es más corto que `w`), debe crear una copia del más corto (`v2 = copy(v)`) y agregarle ceros hasta que tenga la misma longitud que `w` y devolver `v2` y `w`. 

