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
  julia> Polinomio(3,5,1)
```




