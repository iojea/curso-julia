# Intro a `Julia`

## Clase 1: un poco de _teoría_

### Nociones generales

>[!WARNING]
> La idea de estas notas (muy poco) teóricas es posicionar a `Julia` dentro de l universo de lenguajes de programación. No pretenden ser tecnicamente precisas, sino sólo dar una idea general para ayudar a pensar al momento de escribir programas en `Julia`. 


A los fines de lo que nos interesa podemos pensar los lenguajes de programación en dos grandes grupos: los lenguajes más _rígidos_ y los más _flexibles_ (no hay una distinción tajante entre ambos). Los lenguajes más rígidos tienden a ser de tipado estricto y _compilados_ y los más flexibles tienden a ser de tipado dinámico e _interpretados_. A primera vista `Julia` luce como un lenguaje de los _flexibles_, pero en realidad en este y en muchos otros aspectos es más bien un _híbrido_. 

#### Tipado dinámico vs estático

En la computadora los distintos tipos de datos se almacenan de manera diferente. Por ejemplo: un _entero_ se guarda esencialmente como su representación en binario. Pero hay distintas clases de enteros: en un entero común se reserva un bit para indicar el signo, mientras que en un _Unsigned Integer_ esto no es necesario. Un número decimal, en cambio, se almacena por su representación en punto flotante. Un caracter o más en general un `string` (cadena de caracteres) se codifica en binario según algún sistema de codificación (`ASCII`, `UTF-8`, etc.). Es decir que `1`, `1.0` y `'1'`son tres cosas diferentes. Cualquier operación que involucre varios datos, como _sumar_, requiere que estos datos estén representados de un mismo modo. Por lo tanto, si hacemos `1 + 1.0` aunque nosotros no nos enteremos por detrás hay un proceso de conversión (del `1` en `1.0`). 

Lenguajes como `C`, `C++` o `Fortran` requieren que uno especifique el tipo de dato de cada variable y, de ser necesario, obligan al usuario a realizar la conversión explícitamente. El siguiente es un ejemplo de función en `C`:

```C
  int sumar(int a, int b)    
  {
    int resultado;
    resultado = a+b;
    return resultado;        
  }
```

Lenguajes como `Python` o `Matlab` no tienen este requirimiento. En el momento de correr el código el lenguaje _infiere_ qué tipo de dato debe asignarle a cada variable y cuando lo necesita realiza las conversiones pertinentes de manera silenciosa, sin que el usuario se entere. A continuación la función anterior, escrita en `Python`:

```python
  def sumar(a,b)    
    resultado = a+b
    return resultado   
```

El tipado está asociado a otra característica fundamental de estos lenguajes: la _compilación_.

#### Compilar vs. Interpretar

El código que efectivamente se ejecuta en un procesador no es el código que uno escribe (sea en `C`, en `Python` o en `Java`). Para que un código se ejecute hay un proceso de _traducción_ que lleva lo que uno escribió a lenguaje de máquina. Ese proceso es costoso y **lleva tiempo**. 

Los lenguajes compilados, como `C` o `Fortran` no ejecutan el código que uno escribe de manera directa, sino que tienen una instancia de _compilación_ que traduce el archivo de texto plano que uno escribió en un archivo ejecutable. A posteriori puede _correr_ ese ejecutable, eventualmente pasándole ciertos parámetros y obtener el resultado. En el archivo ejecutable se encuentran los pasos a realizar en lenguaje de máquina. Por lo tanto, al momento de usar ese ejecutable debe estar perfectamente determinado el tipo de cada una de las variables usadas, de modo que la máquina sepa qué estructura utilizar al generar esas variables en la memoria y cómo operar con ellas. Por eso el proceso de compilación está separado y es _previo_ a la ejecución del programa. 

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

>[!NOTE]
>Todo lo anterior no es absolutamente estricto. Con el paso del tiempo los lenguajes de tipado estático han incorporado algunas flexibilidades, muchos lenguajes interpretados admiten la posibilidad de compilación, etc. 

#### Memoria

Suele haber otras diferencias entre lenguajes compilados e interpretados. Una de ellas (bastante sensible) es el manejo de la memoria. Cuando uno escribe un programa medianamente sofisticado suelen aparecer muchas variables auxiliares. Estas variables pueden ocupar mucho espacio (vectores o matrices, por ejemplo). En los lenguajes compilados suele ser necesario indicar de manera precisa qué va a hacer uno con el espacio ocupado por esas variables. Hay que reservar el espacio previamente, y liberarlo cuando la variable ya no se necesita. No hacer esto adecuadamente puede derivar en resultados catastróficos como quedarse sin memoria o intentar usar un bloque de memoria de acceso restringido (`segmentation fault`). El manejo de memoria conlleva una sintaxis específica y **mucho** cuidado. 

Los lenguajes interpretados se encargan de esta tarea automáticamente, por lo cual liberan al programador de bastantes preocupaciones. El costo, sin embargo es alto: los intérpretes son muy conservadores y procuran no liberar memoria a menos que estén absolutamente seguros de hacerlo no causará daños. Por lo tanto, un programa interpretado tiende a hacer un uso de memoria mucho más intensivo que uno previamente compilado y a perder mucho más tiempo liberando memoria ocupada.

#### El problema de los dos lenguajes

Todo lo anterior ha dado lugar a lo que se conoce como _problema de los dos lenguajes_, que está muy presente especialmente en aplicaciones científicas. Un matemático, un físico o un químico típicamente no quieren ser programadores. Su tarea central no es programar. Por lo tanto, preferirían no tener que lidiar con todos los detalles de lenguajes compilados. De ahí la popularización de lenguajes como `Matlab`, `R` o `Python`. Son lenguajes mucho más sencillos en los que uno puede escribir y probar programas muchísimo más rápido. 

>[!NOTE]
>Además, `Matlab` y `R` fueron diseñados específicamente para hacer cálculo científico, por lo cual su sintaxis es mucho más cercana al lenguaje al que los científicos están habituados. `Python` no tiene esta ventaja. 

Sin embargo, en muchas aplicaciones (resolución de ecuaciones diferenciales, aplicaciones a geometría, simulaciones numéricas de problemas físicos o químicos de gran tamaño, manejo de grandes volúmenes de datos, etc.) el tiempo de ejecución se torna un problema serio. Ahí es donde estos lenguajes fallan y es necesario pasar a lenguajes compilados que son mucho más tediosos de programar, pero dan lugar a programas mucho más rápidos. 

Por lo tanto, en muchos casos se da una dinámica de dos lenguajes: los algoritmos se bocetan, se prueban y se ajustan en `Matlab` o `Python` pero la versión final se escribe en `C` o `Fortran`. Alternativamente, se usan los dos lenguajes al mismo tiempo: todo lo que hace a la interfaz del usuario (las funciones que el usuario llama, el sitio web o incluso una ventanita con botones) se implementan en `Python`, pero las rutinas críticas se escriben en `C`. El ejemplo más notorio de esta filosofía son las propias librerías de `Python`: `Numpy` y `Scipy` son librerías que permiten hacer operaciones matemáticas sofisticadas escribiendo código `Python`. Sin embargo, las librerías en sí están escritas en `C` y `C++` y hacen uso de diversas funciones de `Fortran`. Algo similar ocurre con `Matlab` en su conjunto. 

### Julia

A primera vista, `Julia` luce como un lenguaje interpretado, de tipado dinámico. Por ejemplo: la función `sumar` en `Julia` se puede escribir: 

```julia
function sumar(a,b)    
  resultado = a+b
  return resultado     
end
```

Sin embargo, `Julia` es un **lenguaje compilado** de **tipado dinámico** (con tipado opcional). Para lograr esto `Julia` hace uso de lo que se llama _Just In Time Compilation_. Además, `Julia` tiene algunas otras pecualiaridades que vale la pena mencionar. 

#### JIT Compilation

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

>[!IMPORTANT]
>Esto da lugar a uno de los _defectos_ de `Julia`: lo que se llama _problema del primer plot_: la primera vez que se ejecuta una función, el tiempo de ejecución será relativamente largo, porque se estará haciendo la _compilación_ junto con la _ejecución_. 

>[!NOTE]
>La compilación `JIT` no es una innovación de `Julia`. El primer sistema de compilación `JIT` fue desarrollado para `Lisp` y data de la década de 1960. `Matlab` introdujo un proceso de `JIT` hace más de diez años. En `Python` está la librería `Numba` que introduce la posibilidad de compilar funciones _just in time_. Sin embargo, `Julia` combina la compilación con algo que se llama _multiple dispatch_ que exploraremos más adelante y hace una diferencia notable.

##### Una ventaja educativa

En `Matlab` la tendencia natural es a escribir _scripts_. Es decir: secuencias de instrucciones de código. Esto es muy poco recomendable por muchas razones. Siempre es mejor escribir _funciones_ que realicen tareas pequeñas y específicas y luego llamar a esas funciones para procesar cada instancia particular de datos. 

`Python` invita más a escribir funciones, pero los estudiantes igualmente tienen tendencia a escribir bloques de código suelto (entornos como `Colab` contribuyen a ello). 

Un curso en el que se intente aprovechar las características de `Julia` debería hacer hincapié en el uso de funciones, que son el pilar fundamental sobre el que está construido el lenguaje. De este modo, `Julia` ayuda a introducir una buena practica de programación desde el inicio. 

#### `Julia` de verdad es rápido.

`Julia` es el único lenguaje de tipado dinámico que pertenece al selecto club de los `Petaflop`, es decir: la pequeña familia de lenguajes capaces de ejecutar más de $10^15$ operaciones de punto flontante en menos de un segundo. Logró este objetivo dentro del proyecto `Celeste`, en donde `Julia` corre en una supercomputadora con más de un millón de threads. Los otros miembros del club son: `C`, `C++` y `Fortran`. 

A continuación un par de gráficos comparativos con otros lenguajes. Primero, comparando algunas operaciones máticas típicas ($1$ corresponde al tiempo obtenido en `C`):


![Alt text](/clase-1/images/mat_ops.png)

Y luego una comparación general de lenguajes comparando tiempo de ejecución y longitud de código. 

![Alt text](/clase-1/images/all_lang_summary.png)


