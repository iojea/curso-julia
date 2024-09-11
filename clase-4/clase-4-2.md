---
layout: default
title: "Clase 4 - Segunda parte - Cosas en el tintero"
#permalink: https://iojea.github.io/curso-julia/clase-
---

Hay muchos aspectos interesantes que quedaron sin mencionar. Aquí un rápido resumen: 

# Librerías interesantes

En [`Julia Packages`](https://juliapackages.com/) se puede buscar entre todos los paquetes registrados de `Julia`. Sin embargo, también hay paquetes no registrados, subidos a github. Para instalarlos, basta poner, en una consola: `] add ` seguido de la dirección al repositorio. Mencionamos algunos ejemplos: 

## Álgebra Lineal
+ `StaticArrays.jl`: introduce vectores y matrices de tamaño fijo. Esto le permite a la máquina guardar estas matrices de una forma especial que no requiere del uso del `Garbage Collector`. Es especialmente eficiente para el manejo de matrices pequeñas. Es decir: cualquier código que realice muchas operaciones sobre matrices de tamaño pequeño, le puede sacar el jugo a esta librería. 
+ `SparseArrays.jl`: incluye distintos tipos de matrices ralas y funciones especializadas para operar sobre ellas. 

## Gráficos
Si bien `Plots.jl` es la librería estándar para dibujar, hay varios paquetes que hacen uso de librerías externas o agregan ciertas funcionalidades. 
+ `Plotly.jl`: usa la librería externa del mismo nombre. 
+ `PyPlot.jl`: usa `Matplotlib`, de `Python`.
+ `Makie.jl`: librería para gráficos de alta performance. Es un poco más difícil de usar que `Plots`, pero puede hacer cosas extraordinarias. 

## Ecuaciones diferenciales
+ `DifferentialEquations.jl` aloja a muchas librerías más pequeñas. Resuelve ODEs, ecuaciones estocásticas, ecuaciones con delay, etc. etc. Tiene muchísimos solvers incorporados (incluyendo de alto orden), pero además es capaz de conectar con solvers ya establecidos escritos en otros lenguajes. Se puede importar la librería completa o sólo alguna de las sublibrerías (más livianas).
+ `Gridap.jl` y `Ferrite.jl` son librerías de elementos finitos de tipo _multiphysics_. Conectan con malladores sofisticados, como `Gmsh` y grafican con `Makie`.
+ `Triangulate.jl` y `TetGen.jl` son wrapers a las librerías del mismo nombre para construir o mejorar mallas triangulares o tetraedrales. Hay también muchos malladores escritos en `Julia`, includa una versión de `DistMesh`, implementada originalmente para `Matlab`.

## Análisis de datos
+ `DataFrames.jl` es la librería con funcionalidades generales para dataframes. `DataFramesMeta.jl` agrega operaciones de alto nivel sobre dataframes. 
+ `CSV.jl` y `XLSX.jl` dan funcionalidad para lectura, y escritura de este tipo de archivos. 

## Imágenes
+ `Colors.jl` define los colores y da la posibilidad de operar con las distintas representaciones de color. 
+ `Images.jl`: Manipulación básica de imágenes. Una imagen es una matriz que contiene colores :).
+ `JuliaImages` no es una librería, sino un proyecto que incluye varios paquetes para procesamiento de imágenes: filtrado, transformación, etc.

## Procesamiento de señales
+ `FFTW.jl` hace uso de la librería externa del mismo nombre para cálculo y manipulación de `FFT` y sus variantes. 
+ `DSP.jl` es una librería de procesamiento de señales. Incluye diseño y aplicación de filtros, convoluciones, funciones ventana, gráficos especializados, etc. 

## Cálculo simbólico
+ `Symbolics.jl` provee herramientas de cálculo simbólico. Es parte del proyecto `JuliaSymbolics`, que incluye otros paquetes. 

## Álgebra
+ `AbstractAlgebra.jl` es una derivación y ampliación de `Nemo.jl`, incluye herramientas para trabajar en teoría de números, cuerpos finitos, grupos finitos, etc. 
+ `AlgebraicJulia` es un proyecto que incluye varios paquetes incluyendo `Catlab.jl`, para aplicar teoría de categorías. 

## Geometría Algebraica
+ Hay varias librerías desarrolladas dentro del proyecto [AROMATH](https://team.inria.fr/aromath/software/): `TensorDec.jl`, `AlgebraicSolvers.jl`, `SemiAlgebraicTypes.jl`, `GSplines.jl` y `Axl.jl`.

## Notebooks
+ `IJulia.jl` permite correr `Julia` en una `jupyter-notebook`. Una vez instalado el paquete, al abrir `jupyter` aparece la posibilidad de crear una notebook con `Julia`.
+ `Pluto.jl` es un sistema de notebooks desarrollado específicamente para `Julia`. Tiene la pecualiaridad de que en `Pluto` la notebook tiene un estado global que no puede romperse. Esto quiere decir que si en una celda definimos una variable `n` y en otra celda calculamos `sum(1:n)`, al cambiar el valor de `n` en la primera celda, _automáticamente_ se correrá la siguiente y recalculará la suma. Esto vale para _todas_ las celdas que dependan del valor de `n`. Para algunas aplicaciones, esto es excelente. Sin embargo, tiene sus costos: 
  - Actualizar una celda puede tener efectos en cascada inesperados (por ejemplo: largo tiempo de cómputo).
  - No es posible reutilizar el nombre de una variable. Es decir: no puede haber dos celdas que definan `n`, porque `Pluto` no sabría cuál valor utilizar. 
+ `PlutoUI.jl` permite agregar botones, deslizadores, cajas de selección, y otros chiches a una notebook de `Pluto`. La sintaxis es extraordinariamente simple. 


## Debug y control de código. 
+ `Debugger.jl`: un debugger para `Julia`.
+ `DispatchDoctor.jl` permite encontrar problemas en el momento del _dispatch_. Por ejemplo: cambios de tipos que le generan conflictos al compilador y, por lo tanto, producen un deterioro en la performance. 
+ `ProfileView.jl` permite testear código y obtener un gráfico que nos muestra el tiempo dedicado a cada tarea, marcando posibles cuellos de botella, exceso de _allocations_, etc. 



# Paralelización

`Julia` integra el cálculo en paralelo desde su núcleo y además se presta facilmente al uso de GPU. 

## Programación asincrónica
Se puede suspender programáticamente la ejecución de código, a la espera de concretar otras tareas. Por ejemplo: se puede hacer un programa que inicie ciertas operaciones, lance la descarga de un archivo de internet, realice otras operaciones en paralelo y retome el trabajo una vez que la descarga haya finalizado. Véase la [Documentación](https://docs.julialang.org/en/v1/manual/asynchronous-programming/).

## Threads
Iniciando `Julia` con el comando `julia --threads 4`, si inicia una sesión de la consola con `4` threads disponibles (si el CPU lo admite). Luego usando el `macro` `Threads.@threads` se puede, por ejemplo, paralelizar un `for`. Sin embargo, hay que tener mucho cuidado para evitar que los distintos threads operen sobre las mismas variables, porque pueden sobreescribirse unos a otros y ocasionar resultados inesperados. Véase la [Documentación](https://docs.julialang.org/en/v1/manual/multi-threading/)

## GPU
`JuliaGPU` es un proyecto que incluye los cuatro grandes paquetes que permiten paralelizar usando GPUs. Hay un paquete especializado para cada una de las tecnologías disponibles: 
+ `CUDA.jl` para el `CUDA` de `NVIdia`,
+ `AMDGPU.jl` para el sistema `ROCm` de `AMD`,
+ `oneAPI.jl` para gráficos integrados de `Intel` y
+ `Metal.jl` para gráficos integrados de los nuevos chips de `Apple`.

Se encuentran en distinto nivel de desarrollo. La más completa es `CUDA.jl`, pero `AMDGPU.jl` y `Metal.jl` están perfectamente operativas. 


# Creación de paquetes propios

En `Julia` crear un paquete propio es realmente **muy** sencillo. Basta crear un directorio para contenerlo, abrir una consola de `Julia` dentro del directorio y tipear: 
```julia
  pkg> generate NombreDelPaquete
```
Esto creará todos los archivos necesarios para definir el paquete. En particular, creará una carpeta `/src` y dentro de ella un archivo `NombreDelPaquete.jl`. Dentro de este archivo tendremos la definición del _módulo_: 
```julia
module NombreDelPaquete

end;
```

Esencialmente se trata escribir todo el código necesario en nuevos archivos `.jl`, incluyendo los nuevos tipos que se definan y las funciones. Luego, en `NombreDelPaquete`, dentro de la definición del módulo agregamos:  
+ lineas de la forma: `include("archivo1.jl")` para incluir en el módulo todo el código generado en los otros archivos. 
+ líneas de la forma: `export Tipo, funcion1, funcion2`, para _exportar_ el tipo `Tipo` y las funciones `function1`, `function2`, etc. Cuando el usuario haga `using NombreDelPaquete`, podrá usar directamente sólo las funciones exportadas. 

Si en una consola nos ubicamos en el directorio del paquete y tipeamos: 
```julia
  pkg> activate .
```
Entraremos en el entorno del propio paquete. Si ahora hacemos, por ejemplo: 
```julia
  pkg> add Plots
```
esto agregará `Plots` como _dependencia_ de nuestro paquete. Con este sólo paso conseguimos:
- Las funciones de `Plots` puede usarse dentro de nuestra librería. 
- Si un usuario instala nuestro paquete _automáticamente_ el gestor de paquetes instalará también `Plots`, porque nuestro paquete lo requiere. 

Si subimos nuestro paquete a un repositorio de `Github`, será instalable por cualquier usuario mediante la dirección del repositorio. Si además lo registramos en `JuliaPackages`, podrá instalarse con 
```
  pkg> add NombreDelPaquete
```

Además, hay herramientas que permiten automatizar la creación de documentación y muchos más chiches. 

# Metaprogramación

El código `Julia` es un objeto dentro de `Julia`. Es decir que un fragmento de código puede ser tomado como una _expresión_ dentro del lenguaje y ejecutado. 
Por ejemplo: 
```julia
  julia> e = :(x=2; x+3)
  julia> typeof(e)
  julia> eval(e)
```
`e` es una _expresión_ que puede evaluarse, lo que equivale a correr  el código definido dentro de ella. 

Los macros de `Julia` (toda sentencia con prefijo `@`, como `@time`, `@benchmark`, `@animate`, etc.) convierten en expresión el código que uno les pasa, agregan otras expresiones y ejecutan el código resultante. Es decir: al correr un macro `Julia` está creando código nuevo sobre el nuestro y lo está ejecutando. A esto se lo llama _metaprogramación_. 

Ya observamos que los `macros` agregan gran funcionalidad permitiendo ejecutar procesos complejos con un simple prefijo. Cualquier usuario puede definir nuevos macros. El `macro` `@macroexpand` permite ver qué código genera otro macro. 

# Performance

Ya vimos que `Julia` es realmente rápido. Sin embargo, la velocidad intrínseca puede empeorar con una mal código. Si se quiere código veloz, es importante tener en mente los [Consejos de Performance](https://docs.julialang.org/en/v1/manual/performance-tips/). En particular, hay dos puntos muy importantes: 
+ Probar el código con `@time` y prestarle atención a `allocations`. En muchos casos escribimos (innecesariamente) código que obliga a la máquina a guardar en memoria más información de la necesaria. Esto además de memoria cuesta tiempo. Si notamos `allocations` excesivas, conviene revisar por qué ocurren.
+ Escribir funciones que sean estables en el tipo. No hace falta introducir anotaciones de tipo. De hecho: en general es mejor evitarlas salvo para hacer uso del _multiple dispatch_. Pero sí es importante que si una función va a devolver un vector, devuelva siempre un vector. Si a veces devuelve un vector y otras una tupla y otras otra cosa, el compilador no tiene más remedio que asumir que la función devuelve cosas de tipo `Any` y no puede generar código optimizado para nuestra función. 

# Introspección

`Julia` brinda muchas herramientas para _investigar_ nuestro propio código. Por ejemplo al usar el macro `@code_warntype` como prefijo a la ejecución de una función nos advertirá si en algún lugar de nuestro código el compilador se encuentra con problemas para decidir el tipo de una variable. Esto nos permite corregir la ambiguedad y acelerar el código. 

Además, la conversión de nuestro código a lenguaje de máquina se realiza en varios pasos. Hay funciones y macros que nos permiten ver el resultado de cada paso. `Meta.@lower` nos da el primer paso de traducción. Es decir: la conversión de nuestro código en expresiones de `Julia`. Ya mencionamos `@code_warntype` para ver nuestro código con tipos. Luego `@code_llvm` nos da la traducción de nuestro código luego de pasar por `LLVM` (que es lo que usa `Julia` para compilar). Finalmente `@code_native` nos muestra en código en lenguaje de máquina. 

<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-3/clase-4-1"> << Volver a la primera parte</a> 
</div> 