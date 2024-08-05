---
layout: default
title: "Clase 3 - Segunda parte - Explorando el sistema de tipos"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Jugando al multiple dispatch

Recordemos algunos experimentos con _multiple dispatch_.

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

Notemos: 
+ Estamos _anotando_ el tipo de dato que recibe la función `h`. Esto define nuevos _métodos_ para la misma función. 
+ Existe un tipo de dato `Number` (?). 
+ Al evaluar `h` sobre valores numéricos caemos siempre en el método definido para `Number`. Es decir `Number` cobija en su interior a cosas de tipo `Int64`, `Float64`, `Rational`, etc. 
+ Al evaluar sobre un `String` se llama al método específico para `String`.
+ Al evaluar sobre cosas que no sean números ni cadenas de caracteres, caemos en la definición genérica, que no aclara tipos. 
+ Si luego definimos una versión específica para `Rational`, `Julia` usará este método cuando le toque un racional, pero volverá a caer en el método genérico para `Number` si se le pasan otros tipos numéricos. 

# Supertipos y subtipos

Ya vimos que el sistema de multiple dispatch es capaz de elegir qué método usar en función de la combinación de tipos de los parámetros. Vimos también que además de `Int64` y `Float64` existen tipos como `Number`. Exploremos un poco esto: 

```julia
  julia> T = typeof(3)
  julia> supertype(T)
  julia> subtypes(T)
  julia> subtypes(supertype(T))
```

Vemos que `Int64` tiene como _supratipo_ a `Signed` y no tiene _subtipos_. Los _subtipos_ de `Signed` son `BigInt`, `Int128`, `Int64`, `Int32`, `Int16`, `Int8`. 

Continuemos investigando hacia arriba:

```julia
  julia> for i in 1:7
            println(T)
            T = supertype(T)
         end  
```

Vemos una secuencia de que llega a `Any` y se estanca allí. Es decir: `Any` se tiene por _supratipo_ a sí mismo. Con esto en mente podemos hacer una función que haga lo que hicimos recién:

```julia
function supertipos(T)
    sup = [T]
    while T != Any
        T = supertype(T)
        push!(sup,T)
    end
    for i in length(sup):-1:1
        println(" "^(length(sup)-i),sup[i])
    end
end
```
El operador `^` aplicado a un `String` lo reitera tantas veces como indica la potencia. Es decir que `" "^(length(sup)-1)` pone una cantidad espacios delante del tipo (empezando por ninguno y agregando uno en cada iteración). 

Usar esta función para explorar la cadena de tipos que conduce a alguno de los tipos conocidos: `Float64`, `Bool`, `Int64`, `UInt64`, `String`. 

Observamos que todos los tipos numéricos  derivan de `Real`, pero el único _antepasado_ común de éstos con `String` es `Any`. 

De manera similar podemos hacer una exploración _hacia abajo_, mirando los subtipos. 

```julia
function subtipos(T,nivel=0)
    println("  "^nivel,T)
    for S in subtypes(T)
        subtipos(S,nivel+1)
    end
end
```

<div class="notebox">
<span class="notetit">Recursividad: </span>

Acabamos de implementar nuestra primera función recursiva. `subtipos` se llama a sí misma para calcular los subtipos de los subtipos, etc. El parámetro opcional `nivel` nos sirve para indicar la cantidad de espacios que usamos y nos permite mostrar la información de manera que se vea quién es subtipo de quién. 
</div>

Probemos nuestra función calculando los subtipos del misterioso `Number`. Vemos que de `Number` se desprenden `Complex` y `Real` y de `Real` derivan distintas variantes de flotantes  y enteros y enteros, los racionales y ... los irracionales. A modo de ejemplo, probar: 

```julia
  julia> sqrt(2)
  julia> π
```

`Julia` sabe que `π` es irracional. Al menos en principio, no sabe que la raíz de dos también.

Calculemos también los subtipos de `AbstractVector`. Si se animan, calculen los subtipos de `Any` (se recomienda cerrar y abrir `Julia` antes de hacer esta operación, para mostrar sólo los tipos incluidos en la instalación básica del lenguaje). Advertencia: esto puede llevar **mucho** tiempo. 

# La estructura de tipos de Julia

+ Los tipos en `Julia` forman un árbol. La raíz de ese árbol es `Any`. 
+ Todos los tipos son _descendientes_ (es decir: subtipos directos o subtipos de subtipos de subtipos...) de `Any`.  
+ Los tipos intermedios (como `Number`, `Real`, `Signed`, etc) son abstractos. Tienen una posición en el árbol para indicar que ciertos tipos descienden de otros, pero no existen ejemplos concretos. Es decir: nunca definiremos una variable cuyo tipo sea `Number`. Podemos definir variables de **tipos concretos**: `Int64` o `UInt16` o `Float32`, y todos ellos caeran bajo el paraguas de `Number`.
+ Al evaluar una función, el sistema de _multiple dispatch_ navega este árbol para buscar el método más ajustado a los parámetros. En nuestro ejemplo, luego de definir `h` para `Rational`, `Julia` distingue que `2//3` es un racional y aplica esa versión. En cambio, al aplicar la función a `2.5` se encuentra con un `Float64`, para el cual no tiene método específico. Entonces sube un nivel y pasa a `AbstractFloat`, para el cual tampoco tiene método específico. Entonces sube otro nive, hasta `Real` y finalmente uno más hasta `Number`. Allí encuentra un método y lo aplica.  

Las relaciones entre los tipos pueden constatarse con una sintaxis muy elegante:

```julia
  julia> Int64 <: Signed
  julia> Int32 <: Number
  julia> Int64 <: Float64
  julia> Int8 <: Int16
  julia> Integer :> Int16
  julia> Integer <: AbstractFloat
  julia> Integer <: Number
```

# Tipos paramétricos

Considerar lo siguiente: 

```julia
  julia> x = 2//3
  julia> typeof(x)
  julia> y = Rational(2,3)
  julia> typeof(y)
  julia> z = Rational(UInt8(2),UInt8(3))
  julia> typeof(z)
  julia> w = Rational{Int16}(2,3)
  julia> typeof(w)
  julia> c = 2 + 4im
  julia> d = 2.5 + 2im
```

Estos ejemplos nos muestran que `Rational` y `Complex` **no son** _tipos concretos_ en el sentido de tener una representación de máquina predeterminada. El tipo de racional que definimos depende del tipo de enteros que usamos para el numerador y el denominador. Algo similar ocurre con la parte real y compleja de los complejos. 

Por ejemplo, un racional definido de manera estandar (`2//3`) es de tipo `Rational{Int64}`. Es decir que tenemos un _tipo paramétrico_. Si usamos `@edit` o `@less` para ver cómo se define un racional vemos lo siguiente: 

```julia
struct Rational{T<:Integer} <:Real
   num::T
   den::T
end
```
(omitimos sólo una línea que contiene un constructor para `Rational`). 

¿Qué nos dice esto?

+ `Rational` es un nuevo tipo de dato, que se define con la sentencia `struct`. En un **tipo compuesto** porque se define a través de otros datos que se indican en el interior de la cláusula `struct`: `num` (numerador) y `den` (denominador). 
+ La indicación `<: Real` a la derecha de la definición ubica a `Rational` dentro del árbol de tipos. Esto será usado a la hora de aplicar _multiple dispatch_, para buscar el método más apropiado de una función cuando se llame con un dato de tipo `Rational`.
+ La sintaxis `Rational{T<:Integer}` indica que el tipo `Rational` tiene un parámetro `T`, que en este caso se aclara que debe descender de `Integer` (`T<:Integer`). Esto puede indicarse también usando la palabra clave `where`. La sintaxis (equivalente) sería: 
```julia
struct Rational{T} <: Real where T<:Integer
  num::T
  den::T
end
```
+ Los _atributos_ internos `num` y `den` deben ser ambos de tipo `T`. 

De esto podemos inferir algunas conclusiones iniciales: 
+ Sólo podremos construir un `Rational` si le pasamos dos enteros. Pueden ser cualquier clase de enteros, pero no pueden ser otra cosa. 
+ `num` y `den` serán siempre del mismo tipo. Es decir que, por ejemplo, no podremos construir racionales cuyo denominador sea `Int64` y cuyo numerador sea `UInt8`.
+ En realidad `Rational` no es **un** tipo, sino una **familia** de tipos. `Rational{Int64}`, `Rational{Int32}` o, dicho más apropiadamente: 
```julia
Rational{T} where T<:Integer
```
son todas variantes de `Rational`. Cuando creamos un número racional no es de tipo `Rational`, sino de alguno de los tipos concretos (por defecto `Rational{Int64}`).

Consideremos lo siguiente: 

```julia
  julia> Rational{Int64} <: Rational
  julia> Rational{UInt16} <: Rational
  julia> Rational{Signed} <: Rational
  julia> Rational{Int64} <: Rational{Signed}
```

