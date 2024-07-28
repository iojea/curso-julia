# Intro a `Julia`

## Clase 1: Archivos `.jl`

### Editor

No existe una IDE especializada para `Julia` como pueden ser `Spyder` para `Python`, `R Studio` para `R` o `Matlab` en sí mismo. Para escribir código `Julia` más extenso es necesario utilizar un editor de texto plano externo: `VSCode`, `Sublime`, `Atom`, `Kate`, `GEdit`, `Zed`, etc., etc., etc. Cualquiera de ellos es capaz de reconocer la sintaxis de `Julia` (eventualmente vía plug-ins). Los esfuerzos de la comunidad de `Julia` han estado focalizados en el desarrollo del plug-in para `VSCode`, de modo que si no hay preferencias previas lo más sencillo es usar `VSCode` (o `VS-Codium` si se prefiere una versión de código abierto y des-microsofteada). A quienes gusten de editores que corren en la terminal, les recomiendo [Helix](https://helix-editor.com/). 

### Archivos `.jl`

Para escribir código `Julia` sólo necesitamos generar un archivo con extensión `.jl`. Luego podemos correrlo desde la consola. 

Abrir un archivo e insertar el siguiente código: 

```julia
  function generar_cuadrados(n)
      salida = zeros(n)
      for i in eachindex(salida)
          salida[i] = i^2
      end
      return salida  
  end 
```

Se trata de una función muy sencilla que recibe un parámetro `n` y devuelve un vector con los números: $1^2, 2^2, \dots, n^2$. 

Guardemos el archivo, por ejemplo como `clase1.jl` (identificar en qué directorio guardamos el archivo). 

Luego, abrimos una sesión de `Julia` (en `VSCode` y otras IDEs puede abrirse una terminal interna, dentro del propio programa) y corremos: 

```julia
  julia> include("clase1.jl")
```



