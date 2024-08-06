---
layout: default
title: "Clase 3 - Primera parte - Jugando a Cálculo Numérico"
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

En <code>Julia</code> las matrices se almacenan <i>por columna</i> (al revés que en <code>Python</code>). Esto puede observarse al ejecutar <code>A[:]</code> que <i>lee</i> todos los casilleros de <code>A</code>. Por lo tanto es más eficiente operar por columnas y cuando se recorre una matriz es más eficiente leer por columnas.
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

**Ejercicio 4:** Modificar la función `euler` de modo que sirva también para sistemas. La función debe: deducir la dimensión `d` del problema del dato inicial y llenar una matriz `x` de `d×N` en donde cada columna corresponde a la solución en un instante. Probar la función resolviendo las ecuaciones de Lotka-Volterra: `ẋ=ax-bxy, ẏ=-cy+dxy`, tomando `a=2/3`, `b=4/3`, `c=d=1`. Si `t` es el vector de tiempos y `x` es la matriz solución, ejecutar el siguiente código: 
```julia
  julia> p1 = plot(t,x',label=["Predador" "Presa"], title="Evolución de las poblaciones")
  julia> p2 = plot(x[1,:],x[2,:],title="Diagrama de fases")
  julia> plot(p1,p2,layout=(2,1))
```

**Ejercicio 5:** Hagamos algo un poquito más divertido. Tomemos las poblaciones obtenidas en el ejercicio anterior (las filas de la matriz `x`), y hagamos una película mostrando la evolución de una respecto de la otra. Para ello queremos hacer una sucesión de plots con graficos parciales y cada vez más completos. Hecho esto, generar una animación usando `Plots` es trivial:
```julia
  julia> anim = @animate for i in 1:size(x,2)
                             plot(x[1,1:i],x[2,1:i])
                         end
  julia> mp4(anim,"pred_presa.mp4")
```
Además de la función `mp4` también hay una función `gif` que genera un `.gif`. A estas funciones se les puede pasar un argumento `fps` para indicar el número de cuadros por segundo. (por ejemplo `mp4(anim,"pred_presa.mp4",fps=24)`). 

Realizar una animación que muestre la evolución de ambas poblaciones variando a lo largo del tiempo. 

# Un poco de Álgebra Lineal

La instalación básica de `Julia` incluye la librería `LinearAlgebra`, que tiene todo lo necesario para hacer operaciones de Álgebra Lineal sobre matrices _densas_. Probar los siguientes fragmentos: 

```julia
 julia> using LinearAlgebra
 julia> A = rand(-3:3,3,3)
 julia> b = rand(-3:3,3)
 julia> c = rand(-3:3,3)
 julia> b*c
 julia> b⋅c # \cdot + tab
 julia> b'*c
 julia> x = A\b
 julia> A*x-b
 julia> det(A)
 julia> tr(A)
 julia> inv(A)
 julia> A + I
 julia> eigvals(A)
 julia> eigvecs(A)
 julia> I(5)
```

```julia
  julia> function cambiouno!(A)
             A[1,1] = 1
         end
  julia> B = rand(5,5)
  julia> cambiouno!(B)
  julia> B
  julia> cambiouno!(B[2:4,3:5])
  julia> B
  julia> vista = view(B,2:4,3:5)
  julia> cambiouno!(vista)
  julia> B
```

Hasta aquí lo esperable. Tenemos funciones para todas las operaciones básicas sobre matrices. Cabe resaltar: 
+ El operador `\cdot` es el producto escalar (`b⋅c` es lo mismo que `b'*c`).
+ El operador `\` resuelve el sistema `Ax=b` 
+ `Julia` tiene la amabilidad de permitirnos usar el símbolo `I` para representar la identidad. Si usamos `I` entre otras matrices (`A+I`), `Julia` deduce su tamaño. En caso contrario `I(n)` devolverá la identidad de tamaño `n`.
+ Cuando le pasamos a una función un fragmento de matriz (por ejemplo `B[2:4,3:5]`), `Julia` realiza una copia de ese fragmento. Por lo tanto, si la función cambia lo que recibe, igualmente la matriz original sigue intacta. 
+ Podemos tomar una `view` de un fragmento de matriz. Esto _mira_ directamente el fragmento tal como está almacenado **en** la matriz. Por lo tanto si le pasamos esta _vista_ a una función que modifica su argumento, se modifica la matriz original.

Al ejecutar `I(5)` obtenemos `5×5 Diagonal{Bool,Vector{Bool}}` y `Julia` nos muestra la matriz poniendo puntos en donde irían los ceros. Esto es un indicador de que **no** se está almacenando toda la matriz. En particular, no se almacenan los ceros. Podemos constatar que `I(5)` ocupa mucho menos lugar que una matriz llena del mismo tamaño.

```julia
 julia> Base.summarysize(I(5))
 julia> Base.summarysize(rand(-3:3,5,5))
```


```julia
    julia> diag(A)
    julia> diag(A,1)
    julia> diag(A,-2)
    julia> diagm([1,2,3])
    julia> diagm(1=>[1,2])
    julia> diagm(0=>-1:1,2=>ones(1))
```

```julia
  julia> D = Diagonal([1,2,3])
  julia> T = Tridiagonal(-ones(9),2ones(10),-ones(9))
  julia> A = rand(1:5,4,4)
  julia> Tridiagonal(A)
  julia> Diagonal(A)
  julia> SymTridiagonal([1,2,3,4],[1,2,3])
  julia> SymTridiagonal(A)
  julia> Symmetric(A)
  julia> Symmetric(A, :L)
  julia> SymTridiagonal(Symmetric(A))
  julia> :pera
  julia> typeof(:pera)
```

Pasando en limpio: 

+ `diag(A)` extrae la diagonal principal de una matriz y devuelve un vector. `diag(A,k)`, devuelve la `k`-ésima diagonal, donde las superiores se numeran positivamente y las inferiores con negativos. 
+ `diagm(v)` crea una matriz con `v` en la diagonal. En general, permite crear matrices _por_diagonales. La sintaxes `diagm(0=>2ones(3),1=>-ones(2),-1=>ones(2))` crea la matriz que tiene `2` en la diagonal principal, `-1` en la superior y `1` en la inferior. Notar que `diagm` produce matrices _llenas_ (no como `I(5)`), que de hecho son de tipo `Matrix`. 
+ `Diagonal` permite crear matrices diagonales (sólo tienen números en la diagonal principal). Puede aplicarse a un vector o a una matriz. Notar que `D` es de tipo `Diagonal`, como ocurre con `I(5)`. 
+ `Tridiagonal` crea matrices tridiagonales. Recibe tres vectores: la digonal inferior, la principal y la superior. También puede aplicarse a una matriz preexistente. 
+ `SymTridiagonal` crea matrices que son tridiagonales y simétricas. Recibe primero la diagonal principal y luego la otra. Puede funcionar sobre una matriz, pero sólo si ésta es simétrica.
+ `Symmetric` crea matrices simétricas. Se aplica sobre una matriz. Por defecto _simetriza_ respetando la parte superior. Poniendo en el segundo parámetro `:L` se respeta la parte inferior (_lower_). 

<div class="notebox>">
<span class="notetit">Símbolox: </span>

Todo nombre precedido de `:` (como `:L`) es un _símbolo_ (de tipo `Symbol`). Para crear un símbolo, basta con escribir una palabra precedida por `:`. Los símbolos suelen servir como reemplazo de las cadenas de caracteres. En otros lenguajes para identificar si uno quiere tomar la _parte inferior_ habría que usar un código (-1, por ejemplo) o un `String`, por ejemplo `"lower"`. Los símbolos sirven de atajo para este tipo de usos. 
</div>

<div class="notebox">
<span class="notetit">Nota: </span>

Según las convenciones de <code>Julia</code> los nombres de las funciones se escriben con <b>minúscula</b> y los tipos de dato (<code>Int64</code>, <code>Float64</code>, etc.) con <b>mayúscula</b>. <code>Diagonal, Tridiagonal</code>, etc. son funciones especiales: son  <b>constructores</b> de un tipo de dato particular (el de las matrices diagonales, tridiagonales, etc.). Por lo tanto, tienen el mismo nombre que el tipo de dato que crean.
</div>

Al definir un tipo de dato especial `Julia` distingue una matriz de otra y puede aplicar algoritmos especializados. A modo de ejemplo sencillo, probemos lo siguiente: 

```julia
  julia> using BenchmarkTools
  julia> v = rand(1000);
  julia> Dd = diagm(v);
  julia> Dr = Diagonal(v);
  julia> @benchmark det($Dd)
  julia> @benchmark det($Dr)
```

En `LinearAlgebra` hay tipos especiales para diversas clases de matrices, incluyendo `Symmetric`, `Hermitian`, `Tridiagonal`, `SymTridiagonal`, `UpperTriangular`, `LowerTriangular`, etc. 

Experimentemos un poco más:

```julia
  julia> A = rand(1:5,5,5)
  julia> luA = lu(A)
  julia> typeof(luA)
  julia> A = rand(1000,1000);
  julia> b = rand(1000);
  julia> luA = lu(A);
  julia> qrA = qr(A);
  julia> typeof(qrA)
  julia> @benchmark $A\$b
  julia> @benchmark $luA\$b
  julia> @benchmark @qrA\$b  
```

Pasando en limpio: 
+ El sistema de _multiple dispatch_ permite re-definir funciones usando algoritmos especializados según el tipo. Así, calcular el determinante de una matriz de tipo `Diagonal` es mucho más veloz que calcular el determinante que una matriz de tipo `Matriz` que puede estar llena. 
+ las funciones `lu` y `qr` calculan las descomposiciones LU y QR de una matriz, respectivamente. Como resultado no devuelven una simple tupla con dos matrices sino objetos con un tipo de dato específico para cada descomposición. 
+ las descomposiciones pueden usarse directamente para resolver un sistema mediante el operador `\`.
+ Naturalmente, si se cuenta con una descomposición, la resolución del sistema es mucho más veloz. Por defecto `A\b` triangula el sistema extendido `A|b` realizando las operaciones que sirven para calcular la descomposición LU. Una vez triangulado el sistema, se despeja. Al aplicar `\` directamente sobre la descomposición: `luA\b` `Julia` sólo despeja. 

**Ejercicio:** Consideremos la ecuación del calor en el `[0,,1]`: 

    uₓₓ(x,t) &= uₜ(x,t)
    u(x,0) &= u₀(x) 
    u(0,t) & 0 ∀t    
    u(1,t) & 0 ∀t

Para resolverla, discretizamos el problema tomando un vector `x` de `n` casilleros (`x=range(0,1,length=n)`). Notamos `h` al paso del vector `x`. De manera similar definimos un vector `t` que vaya de `0` a un tiempo final con paso `Δt`. Llamamos `m` a la longitud de `t`. Definimos una matriz `u` de `n×m` en donde cada columna representará la solución para un tiempo fijo. Es decir `u[:,i]` es la solución a tiempo `t[i]`. A su vez, los valores de la primera y la última fila de `u` son ceros, dadas las condiciones de contorno del problema. 

Aplicando un esquema implícito de diferencias finitas tenemos el siguiente sistema de ecuaciones para la matriz `u`:

    -r u[j-1,k+1] + (1-2r) u[j,k+1] + r u[j+1,k+1] = u[j,k]

donde `r = Δt/h^2` y `j` debe tomarse en el rango `2:end-1`, pues no queremos operar sobre los valores de borde, que deben mantenerse en `0`, para todo tiempo. Escribiendo este sistema matricialmente tenemos que: 

    A u[2:end-1,k+1] = u[2:end-1,k] 

donde `A` es la matriz tridiagonal que tiene `(1-2r)` en la diagonal principal y `-r` en las diagonales inferior y superior. Es decir: la columna `k+1` (la solución a tiempo `t[k+1]`) depende de la columna `k` (la solución a tiempo `t[k]`). Dado que el dato inicial nos da la solución a tiempo `t[0]`, necesitamos resolver iterativamente el sistema para ir rellenando las siguientes columnas de `u`.

Implementar una función que reciba como datos: la función que define el dato inicial `u₀`, `n`, el tiempo final `Tf` y el paso temporal `Δt`. La función debe: 
  - Generar los vectores `x` y `t` y la matriz `u`, y rellenar su primer columna con la evaluación de `u₀` en `x`. 
  - Generar la matriz `A` y calcular su descomposición LU.
  - Rellenar iterativamente la matriz `u` resolviendo en cada paso el sistema correspondiente (aprovechando la descomposición LU calculada).
  - Devolver `t`, `x` y `u`.

Implementar una segunda función que reciba como input `x` y `u` y realice una película que en cada cuadro contenga la solución en un instante de tiempo. Al ver la película vemos la evolución temporal de la temperatura sobre el segmento. 


<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-2/clase-2-1"> << Volver a la primera parte</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-3/clase-3-1"> >> Ir a la clase 3</a> 
</div>
