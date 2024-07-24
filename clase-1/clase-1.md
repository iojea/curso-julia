# Intro a `Julia`

## Clase 1: Generalidades y primeros pasos

### Características generales

Empecemos un poco teóricamente, posicionando a `Julia` dentro del universo de lenguajes de programación. 

A los fines de lo que nos interesa podemos pensar los lenguajes de programación en dos grandes grupos: los lenguajes más _rígidos_ y los más _flexibles_ (no hay una distinción tajante entre ambos). Los lenguajes más rígidos tienden a ser de tipado estricto y _compilados_ y los más flexibles tienden a ser de tipado dinámico e _interpretados_. A primera vista `Julia` luce como un lenguaje de los _flexibles_, pero en realidad en este y en muchos otros aspectos es más bien un _híbrido_. 

>[!WARNING]
>Estas notas no pretenden ser técnicamente precisas, sino sólo dar una idea general para ayudar a pensar al momento de escribir programas en `Julia`. 

#### Tipado dinámico vs estático

En la computadora los distintos tipos de datos se almacenan de manera diferente. Por ejemplo: un _entero_ se guarda esencialmente como su representación en binario. Pero hay distintas clases de enteros: en un entero común se reserva un bit para indicar el signo, mientras que en un _Unsigned Integer_ esto no es necesario. Un número decimal, en cambio, se almacena por su representación en punto flotante. Un caracter o más en general un `string` (cadena de caracteres) se codifica en binario según algún sistema de codificación (`ASCII`, `UTF-8`, etc.). Es decir que `1`, `1.0` y `'1'`son tres cosas diferentes. Cualquier operación que involucre varios datos, como _sumar_, requiere que estos datos estén representados de un mismo modo. Por lo tanto, si hacemos `1 + 1.0` aunque nosotros no nos enteremos por detrás hay un proceso de conversión (del `1` en `1.0`). 

Lenguajes como `C`, `C++` o `Fortran` requieren que uno especifique el tipo de dato de cada variable y, de ser necesario, obligan al usuario a realizar la conversión explícitamente. El siguiente es un ejemplo de función en `C`:

```C
  int addNumbers(int a, int b)         // firma   
  {
    int result;
    result = a+b;
    return result;                  // salida
  }
```

