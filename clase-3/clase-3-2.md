---
layout: default
title: "Clase 3 - Segunda parte - Explorando el sistema de tipos"
#permalink: https://iojea.github.io/curso-julia/clase-
---

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


