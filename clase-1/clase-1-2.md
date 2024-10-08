---
layout: default
title: "Clase 1- Segunda parte - Un poco de teoría"
#permalink: https://iojea.github.io/curso-julia/clase-1/clase-1-2
---
  
# Nociones generales

<div class="warnbox">
<span class="warntit">Advertencia</span>

La idea de esta segunda parte (vagamente) teórica es posicionar a <code>Julia</code> dentro del universo de lenguajes de programación. No pretenden ser técnicamente precisas, sino sólo dar una idea general para ayudar a pensar al momento de escribir programas en <code>Julia</code>. 
</div>


A los fines de lo que nos interesa podemos pensar los lenguajes de programación en dos grandes grupos: los lenguajes más _rígidos_ y los más _flexibles_ (no hay una distinción tajante entre ambos). Los lenguajes más rígidos tienden a ser de tipado estricto y _compilados_ y los más flexibles tienden a ser de tipado dinámico e _interpretados_. A primera vista `Julia` luce como un lenguaje de los _flexibles_, pero en realidad en este y en muchos otros aspectos es más bien un _híbrido_. 

## Tipado dinámico vs estático

En la computadora los distintos tipos de datos se almacenan de manera diferente. Por ejemplo: un _entero_ se guarda esencialmente como su representación en binario. Pero hay distintas clases de enteros: en un entero común se reserva un bit para indicar el signo, mientras que en un _Unsigned Integer_ esto no es necesario. Un número decimal, en cambio, se almacena por su representación en punto flotante. Un caracter o más en general un `String` (cadena de caracteres) se codifica en binario según algún sistema de codificación (`ASCII`, `UTF-8`, etc.). Es decir que `1`, `1.0` y `'1'`son tres cosas diferentes. Cualquier operación que involucre varios datos, como _sumar_, requiere que estos datos estén representados de un mismo modo. Por lo tanto, si hacemos `1 + 1.0` aunque nosotros no nos enteremos por detrás hay un proceso de conversión (del `1` en `1.0`). 

Lenguajes como `C`, `C++` o `Fortran` requieren que uno especifique el tipo de dato de cada variable y, de ser necesario, obligan al usuario a realizar la conversión explícitamente. El siguiente es un ejemplo de función en `C`:

```C
  int sumar(int a, int b)    
  {
      int resultado;
      resultado = a+b;
      return resultado;        
  }
```

Esta función sólo es capaz de sumar enteros. Para sumar flotantes hará falta otra función. Y para sumar un entero y un flotante, otra. 

Lenguajes como `Python` o `Matlab` no tienen este requisito. En el momento de correr el código el lenguaje _infiere_ qué tipo de dato debe asignarle a cada variable y cuando lo necesita realiza las conversiones pertinentes de manera silenciosa, sin que el usuario se entere. A continuación la función anterior, escrita en `Python`:

```python
  def sumar(a,b)    
    resultado = a+b
    return resultado   
```

El tipado está asociado a otra característica fundamental de estos lenguajes: la _compilación_.

## Compilar vs. Interpretar

El código que efectivamente se ejecuta en un procesador no es el código que uno escribe (sea en `C`, en `Python` o en `Java`). Para que un código se ejecute hay un proceso de _traducción_ que lleva lo que uno escribió a lenguaje de máquina. Ese proceso es costoso y **lleva tiempo**. 

Los lenguajes compilados, como `C` o `Fortran`, no ejecutan el código que uno escribe de manera directa, sino que tienen una instancia de _compilación_ que traduce el archivo de texto plano que uno escribió en un archivo ejecutable. A posteriori el usuario puede _correr_ ese ejecutable, eventualmente pasándole ciertos parámetros, y obtener el resultado. En el archivo ejecutable se encuentran los pasos a realizar en lenguaje de máquina. Por lo tanto, al momento de usar ese ejecutable debe estar perfectamente determinado el tipo de cada una de las variables usadas, de modo que la máquina sepa qué estructura utilizar al generar esas variables en la memoria y cómo operar con ellas. Por eso el proceso de compilación está separado y es _previo_ a la ejecución del programa. 

Otros lenguajes (más modernos) como `Python` o `R` son _interpretados_. Es decir: no requieren de un proceso de compilación, sino que hay un _intérprete_ que lee el archivo de texto plano que uno escribe, lo convierte _al vuelo_ en lenguaje de máquina y lo ejecuta, dando el resultado. Típicamente, en ese proceso de interpretación se _infiere_ el tipo de las variables. Usualmente los lenguajes interpretados son de tipado dinámico y los compilados son de tipado estático. 

Los lenguajes interpretados son mucho más flexibles y cómodos para programar: uno puede escribir un montón de código sin preocuparse por aclarar si algo es un entero (con signo o sin signo) o un flotante. El lenguaje se encarga de lidiar con todos esos detalles. El resultado suele ser un código más claro (más cercano a un lenguaje humano) y considerablemente más corto. 

Los lenguajes compilados en cambio, tienen una ventaja que en muchas aplicaciones es crucial: al procesar el código previamente y traducirlo a lenguaje de máquina producen programas muchísimo más veloces. La razón es muy simple: todo lo que el compilador hace (y a veces compilar lleva un buen rato), el intérprete lo tiene que hacer en el momento de ejecutar el código (y repetir cada vez que se ejecuta). 

Por ejemplo,  consideremos la función `sumar` escrita en `Python` (más arriba). El siguiente fragmento:

```python
c = sumar(1,2)
```

realiza un proceso totalmente distinto al siguiente

```python
c = sumar(1,2.1)
```

En el primero tenemos dos enteros que se suman de manera directa por su representación en binario. En el segundo tenemos un entero y un flotante. El entero debe ser convertido a flotante y sumado al otro, mediante la suma de flotantes.

<div class="notebox">
<span class="notetit">Nota:</span>

Todo lo anterior no es absolutamente estricto. Con el paso del tiempo los lenguajes de tipado estático han incorporado algunas flexibilidades, muchos lenguajes interpretados admiten la posibilidad de compilación, etc. 
</div>


## Memoria

Suele haber otras diferencias entre lenguajes compilados e interpretados. Una de ellas (bastante sensible) es el manejo de la memoria. Cuando uno escribe un programa medianamente sofisticado suelen aparecer muchas variables auxiliares. Estas variables pueden ocupar mucho espacio (vectores o matrices, por ejemplo). En los lenguajes compilados suele ser necesario indicar de manera precisa qué va a hacer uno con el espacio ocupado por esas variables. Hay que reservar el espacio previamente, y liberarlo cuando la variable ya no se necesita. No hacer esto adecuadamente puede derivar en resultados catastróficos como quedarse sin memoria o intentar usar un bloque de memoria de acceso restringido (`segmentation fault`). El manejo de memoria conlleva una sintaxis específica y **mucho** cuidado. 

Los lenguajes interpretados se encargan de esta tarea automáticamente, usualmente mediante un _Garbage Collector (GC)_. Esto libera al programador de bastantes preocupaciones. El costo, sin embargo es alto: los intérpretes son muy conservadores y procuran no liberar memoria a menos que estén absolutamente seguros de hacerlo no causará daños. Por lo tanto, un programa interpretado tiende a hacer un uso de memoria mucho más intensivo que uno previamente compilado y a el GC pierde más tiempo liberando memoria ocupada.

## El problema de los dos lenguajes

Todo lo anterior ha dado lugar a lo que se conoce como _problema de los dos lenguajes_, que está muy presente especialmente en aplicaciones científicas. Un matemático, un físico o un químico típicamente no quieren ser programadores. Su tarea central no es programar. Por lo tanto, preferirían no tener que lidiar con todos los detalles de lenguajes compilados. De ahí la popularización de lenguajes como `Matlab`, `R` o `Python`. Son lenguajes mucho más sencillos en los que uno puede escribir y probar programas muchísimo más rápido. 

<div class="notebox">
<span class="notetit">Nota:</span>

Además, <code>Matlab</code> y <code>R</code> fueron diseñados específicamente para hacer cálculo científico, por lo cual su sintaxis es mucho más cercana al lenguaje al que los científicos están habituados. <code>Python</code> no tiene esta ventaja. 
</div>

Sin embargo, en muchas aplicaciones (resolución de ecuaciones diferenciales, aplicaciones a geometría, simulaciones numéricas de problemas físicos o químicos de gran tamaño, manejo de grandes volúmenes de datos, etc.) el tiempo de ejecución se torna un problema serio. Ahí es donde estos lenguajes fallan y es necesario pasar a lenguajes compilados que son mucho más tediosos de programar, pero dan lugar a programas más rápidos. 

Por lo tanto, en muchos casos se da una dinámica de dos lenguajes: los algoritmos se bocetan, se prueban y se ajustan en `Matlab` o `Python` pero la versión final se escribe en `C` o `Fortran`. Alternativamente, se usan los dos lenguajes al mismo tiempo: todo lo que hace a la interfaz del usuario (las funciones que el usuario llama, el sitio web o incluso una ventanita con botones) se implementan en `Python`, pero las rutinas críticas se escriben en `C`. El ejemplo más notorio de esta filosofía son las propias librerías de `Python`: `Numpy` y `Scipy` son librerías que permiten hacer operaciones matemáticas sofisticadas escribiendo código `Python`. Sin embargo, las librerías en sí están escritas en `C` y `C++` y hacen uso de diversas funciones de `Fortran`. Algo similar ocurre con `Matlab` en su conjunto. 

# Julia

A primera vista, `Julia` luce como un lenguaje interpretado, de tipado dinámico. Por ejemplo: la función `sumar` en `Julia` se puede escribir: 

```julia
function sumar(a,b)    
  resultado = a+b
  return resultado     
end
```

Sin embargo, `Julia` es un **lenguaje compilado** de **tipado dinámico** (con tipado opcional). Para lograr esto `Julia` hace uso de un mecanismo de _Just In Time Compilation_, que ya mencionamos. Además, `Julia` tiene algunas otras peculiaridades que vale la pena mencionar. 

## JIT Compilation

En `Julia` (en principio) uno no obtiene un ejecutable, sino que, como ocurre en `Python`, `R` o `Matlab` uno escribe un archivo de texto plano con el código y luego directamente ejecuta ese código. Lo que ocurre es que al hacer esto `Julia` infiere los tipos de las variables y **compila** una versión de las funciones que uno escribió adecuada a los tipos inferidos. Esa versión compilada se almacena en memoria y dura mientras la sesión de `Julia` se encuentre abierta. 

Esto es una enorme ventaja, porque el código de `Julia` se ejecuta realmente rápido y puede alcanzar velocidades muy cercanas a las de `C` o `Fortran`. 

En principio, `Julia` deduce los tipos de las variables en función de lo que se escribió en la función o, en su defecto, de los valores que se usaron al llamar a la función. Por ejemplo: la función `sumar` no da ninguna pista respecto de si pretendemos sumar enteros o flotantes. `Julia` deducirá cuál es el caso la primera vez que se ejecute la función. Por lo tanto, si corremos 
```julia
x = sumar(3,6)
```
`Julia` compilará una versión de la función asumiendo que los dos parámetros son enteros. Si luego corremos: 
```julia
y = sumar(1.2,3.4)
```
`Julia` _volverá a compilar_ la función, esta vez en una versión para flotantes. 

<div class="importantbox">
<span class="importantit">Importante:</span>

Esto da lugar a uno de los <i>defectos</i> de <code>Julia</code>: lo que se llama <i>problema del primer plot</i>: la primera vez que se ejecuta una función, el tiempo de ejecución será relativamente largo, porque se estará haciendo la <i>compilación</i> junto con la <i>ejecución</i>. 
</div>

<br>

<div class="notebox">
<span class="notetit">Nota:</span>

La compilación <code>JIT</code> no es una innovación exclusiva de <code>Julia</code>. El primer sistema de compilación <code>JIT</code> fue desarrollado para <code>Lisp</code> y data de la década de 1960. <code>Matlab</code> introdujo un proceso de <code>JIT</code> hace más de diez años. En <code>Python</code> está la librería <code>Numba</code> que introduce la posibilidad de compilar funciones just in time. Sin embargo, <code>Julia</code> combina la compilación con algo que se llama <b>multiple dispatch</b>,  que exploraremos más adelante y hace una diferencia notable.
</div>

### Una ventaja educativa

En `Matlab` la tendencia natural es a escribir _scripts_. Es decir: secuencias de instrucciones de código. Esto es muy poco recomendable como práctica de programación en general, por muchas razones. Siempre es mejor escribir _funciones_ que realicen tareas pequeñas y específicas y luego llamar a esas funciones para procesar cada instancia particular de datos. 

`Python` invita más a escribir funciones, pero los estudiantes igualmente tienen tendencia a escribir bloques de código suelto (entornos como `Colab` contribuyen a ello). 

Un curso en el que se intente aprovechar las características de `Julia` debería hacer hincapié en el uso de funciones, que son el pilar fundamental sobre el que está construido el lenguaje. De este modo, `Julia` ayuda a introducir una buena practica de programación desde el inicio. 

# Julia de verdad es rápido.

`Julia` es el único lenguaje de tipado dinámico que pertenece al selecto club de los `Petaflop`, es decir: la pequeña familia de lenguajes capaces de ejecutar más de `10^15` operaciones de punto flotante en menos de un segundo. Logró este objetivo dentro del proyecto `Celeste`, en donde `Julia` corre en una supercomputadora con más de un millón de threads. Los otros miembros del club son: `C`, `C++` y `Fortran`. 

A continuación un par de gráficos comparativos con otros lenguajes. 

Primero, comparando algunas operaciones mátemáticas típicas (`1` corresponde al tiempo obtenido en `C`):

<img src="../clase-1/images/mat_ops.png">

Y luego una comparación general de lenguajes sopesando tiempo de ejecución y longitud de código. 

<img src="../clase-1/images/all_lang_summary.png">

# Un ejemplo

Terminemos con un ejemplo que permite constatar en la práctica la velocidad `Julia` y la enorme potencia de su proceso de compilación _just in time_. 
    
Consideremos un programa bastante tonto para estimar `π` mediante un método de Montecarlo: tiramos puntos al azar en el cuadrado [-1,1]<sup>2</sup>, contamos cuántos caen en el disco unitario y estimamos `π∼4n/N`, donde `N` es la cantidad total de puntos y `n` la cantidad de puntos que cayeron en el círculo.

**Ejercicio:** Implementar una función que resuelva este problema. Puede resultar útil utilizar la función `rand()` (sin argumentos) que devuelve un número al azar en el intervalo [0,1]. 

Podemos comparar la función implementada en `Julia` con su análogo en `Python`. Supongamos que consideramos: 
```python
import numpy as np
def estimate_pi(N):
    n = 0
    for i in range(N):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if x**2 + y**2 <= 1:
           n += 1
    return 4*n/N
```
Probamos esta función con `N=1_000_000` y estimando el tiempo con `%time` y obtenemos un tiempo de ejecución de `848 ms`. Esto es esperable porque los `for` de `Python` son interpretados, no compilados, de modo que suelen ser muy lentos. Un truco usual en `Python` y `Matlab` es _vectorizar_ el código de modo que las operaciones que se hacen dentro del `for` sean reemplazadas por funciones de librería que ejecutan internamente un `for` compilado (y escrito en `C` o `Java`). Nuestro código vectorizado luciría más o menos así: 

```python
def estimate_pi_numpy(N):
    xy = 2*np.random.random((N, 2)) - 1
    norma = (xy**2).sum(axis = 1)    
    en_circ = norma <= 1    
    n = en_circ.sum()
    return 4*n/N
```

Aquí creamos una matriz en donde cada fila es un punto, calculamos la norma al cuadrado de cada fila, comparamos con 1 y sumamos los menores que 1. El tiempo de ejecución es de `31 ms`. Una ganancia considerable. 

En `Python` hay otra alternativa, que es utilizar la librería `Numba`. `Numba` agrega funcionalidades de compilación _just in time_ que permiten acelerar el `for`. Nuestro código es: 

```python
import numba
@numba.jit()
def estimate_pi_numba(N):
    n = 0
    for i in range(N):
        x = 2*np.random.random() - 1
        y = 2*np.random.random() - 1
        if x**2 + y**2 <= 1:
           n += 1
    return 4*n/N
```

Para no contabilizar el tiempo de compilación, ejecutamos esta función primero con `N=2` y luego con `%time` y `N=1_000_000`. El tiempo obtenido es de `7.65 ms`

Probamos ahora nuestro código en `Julia`:

```julia
function estimate_pi(N)
    n = 0
    for i in 1:N
        x = 2*rand() - 1
        y = 2*rand() - 1
        if x^2 + y^2 <= 1
           n += 1
        end
    end
    return 4*n/N
end
```

Lo corremos una vez para compilar y medimos el tiempo de la segunda corrida con  `@time` y obtenemos: `3.8 ms`. Es decir: **la mitad** que con `Numba` y **un décimo** que la versión vectorizada en `Python`.

Cabe preguntarse, ¿ganaremos algo vectorizando el código de `Julia`? Podemos probar. El siguiente código es análogo al de `Python`.

```julia
function estimate_pi_vec(N)
    xy = 2*rand(N,2) .- 1
    norma = sum(xy.^2,dims=2)    
    en_circ = norma .≤ 1 
    n = sum(en_circ)
    return 4*n/N
end
```

Y al correrlo con `@time` obtenemos un tiempo de alrededor de `11 ms`. Y si repetimos podemos encontrarnos con tiempos de `20 ms` o incluso `32 ms`. Lo primero que notamos es que es muy volátil. Lo segundo que notamos es que dentro de su volatilidad suele ser mejor que la versión vectorizada de `Python`, pero peor que la versión _ingenua_ en `Julia`.

La razón tanto de la volatilidad como del empeoramiento respecto del código básico la da el propio `@time`: estamos haciendo `18` _allocations_ (accesos a memoria) por un total de `68 Mb`. Esto a su vez desencadena llamados al _Garbage Collector_ (`gc`) que debe limpiar la memoria que ocupamos para `arrays` auxiliares. Esto además de memoria consume _tiempo_. Las variaciones en el tiempo de ejecución provienen de que en algunas corridas se ejecuta el `gc` y en otras no.  La versión sin vectorizar no reportaba _allocations_. Es decir: la versión vectorizada tanto en ` Julia` como en `Python` paga la penalidad del consumo innecesario de memoria. En este sentido, el código _vectorizado_ si bien sirve para mejorar la performance dentro de un lenguaje interpretado nunca podrá competir con un código _ingenuo_, si este último prescinde del uso innecesario de memoria.

En resumen: en general el código _natural_ es muy eficiente en `Julia` y no necesitamos de trucos como la _vectorización_ de las operaciones. Esto además de dar programas más rápidos permite escribir código más claro y descriptivo.

<br>
 <div style="text-align: left">
<a href="https://iojea.github.io/curso-julia/clase-1/clase-1-1"> << Volver a la parte 1</a> 
</div> <div style="text-align: right">
<a href="https://iojea.github.io/curso-julia/clase-2/clase-2-1"> >> Ir a la clase 2</a> 
</div>
