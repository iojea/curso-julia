---
layout: default
title: "Clase 2 - Primera parte - Jugando a Cálculo Numérico"
#permalink: https://iojea.github.io/curso-julia/clase-
---

# Punto flotante

`Julia` tiene algunas lindas funciones para explorar el sistema de punto flotante. 

**Ejercicio 1:** Mirar el `help` de las funciones `eps`, `nextfloat` y `prevfloat`. 
**Ejercicio 2:** Graficar la función `eps`.

# Matrices
Probar los siguientes comandos:

```julia
  julia> A = [1 2 3;4 5 6;7 8 9]
  julia> B = [-1 -2;-3 -4]
  julia> C = [A zeros(3,2);
              zeros(2,3) B]
  julia> C[2,3]
  julia> C[:,4]
  julia> C[3,:]
  julia> A[:]
  julia> z = ones(5)
  julia> C*z
  julia> z*C
  julia> z'*C*z
```

Sacar conclusiones. 

<div class="importantbox">
<span class="importantit">Importante:</span>

En `Julia` las matrices se almacenan _por columna_ (al revés que en `Python`). Esto puede observarse al ejecutar `A[:]` que _lee_ todos los casilleros de `A`. Por lo tanto es más eficiente operar por columnas y cuando se recorre una matriz es más eficiente leer por columnas.
</div>


# Resolviendo ecuaciones

El primer método de un paso para resolver ecuaciones en derivadas parciales es el método de Euler. Dada la ecuación `ẋ = f(x,t)` con condición de contorno `x(t₀) = x₀`, la iteración de Euler construye la sucesión: `xₙ₊₁ = xₙ + f(xₙ,tₙ)`, donde `tₙ = t₀ + nh` para algún paso `h`. 
Una implementación posible del método de Euler es la siguiente: 

```julia
function euler(f,x₀,tspan,N)
    t0,tf = tspan
    t     = range(t0,tf,length=N)
    h     = t[2]-t[1]
    x     = zeros(N)
    x[0]  = x₀
    for n in 1:N-1
        x[n+1] = x[n] + h*f(x[n],t[n])
    end
    return t,x
end
```

Esta función recibe la función que define la ecuación diferencial, el dato inicial, un vector o una tupla de dos casilleros con el tiempo inicial  y el final y el número de puntos que se desea calcular. `r` es un rango de valores que comienza en `t0`, termina en `tf` y tiene en total `N` casilleros. El valor de `h` se infiere de este rango. 

**Ejercicio 3:** Crear un archivo con esta función. Crear algún set de datos `f` y `x₀` y usar `euler` para resolver la ecuación. Graficar el resultado.

El código anterior funciona sólo para ecuaciones escalares, pero no para sistemas. En un sistema `x` es un vector y `f` es un campo vectorial. En principio esto no depende directamente de la función `euler`, sino del usuario que debe generar datos `f` y `x₀`adecuados. El problema del código es que para un sistema la variable `x` debería ser una matriz en donde cada columna o cada fila represente el vector solución en un tiempo dado. 

**Ejercicio 4:** Modificar la función `euler` de modo que sirva también para sistemas. La función debe: deducir la dimensión `d` del problema del dato inicial y llenar una matriz `x` de `d×N` en donde cada columna corresponde a la solución en un instante. Probar la función con datos de un sistema de dimensión `2`. Graficar.

