
# Indice

## Introduction to the Theory of Programming Languages
- [ ] 1 - Terms and Relations

## The implementation of functional programming languages
- [ ] 2 - The lambda calculus
  - [x] 2.1 - Syntax
  - [x] 2.2 - Operational semantics
  - [ ] 2.3 - Reduction order
  - [ ] 2.4 - Recursive functions
  - [ ] 2.5 - Denotational semantics
- [ ] 8 - Polymorphic type-checking
  - [ ] 8.1 - Informal notation for types
  - [ ] 8.2 - Polymorphism
  - [ ] 8.3 - Type inference
  - [ ] 8.4 - Intermediate language
  - [ ] 8.5 - How to find types
  - [ ] 8.6 - Summary of rules for correct typing
- [ ] 9 - A type checker
  [ ] 9.1 - Representation of programms
  [ ] 9.2 - Representation of type expressions
  [ ] 9.3 - Success and failure
  [ ] 9.4 - Solving equations
  [ ] 9.5 - Keeping track of types
  [ ] 9.6 - New variables
  [ ] 9.7 - The type checker

# Notas 
## The lambda calculus

Se extiende el cálculo lambda puro
- Constantes: `true`, `false`, `0`, `nil`
- Funciones: `and`, `or`, `not`, `if`, `cons`, `head`, `tail`, `isnil`

### Expresiones
```
<exp> ::= <constant>          -- built-in constants
        | <variable>          -- variable names 
        | <exp> <exp>         -- applications
        | λ <variable>.<exp>  -- lambda abstractions
```

### Semantica operacional

#### Variables libres y ligadas
Una variable **ocurre libre** en una expresión si no está **ligada** por una abstracción que la contiene.

Definicion de "libre":
- x occure libre en x
- x ocurre libre en (E F) <-> x ocurre libre en E o x ocurre libre en F
- x ocurre libre en (λy.E) <-> x ocurre libre en E y x ≠ y 

Definicion de "ligada":
- x ocurre ligada en (E F) <-> x ocurre ligada en E o x ocurre ligada en F
- x ocurre ligada en (λy.E) <-> (x = y y x ocurre libre en E) o (x ocurre ligada en E)

Cada ocurrencia **individual** es ligada o libre, pero no ambas, sin embargo, una variable puede aparecer ligada y libre en la misma expresión. Por ejemplo:
```(λx.x) x```. 

#### Conversion beta (β)
Ejemplo:
```(λx. x + 1) 4``` Es la yuxtaposición de la abstración ```(λx. x + 1)``` y el argumento ```4```. 

Definición:
El resultado de aplicar una abstracción a un argumento es la instancia del cuerpo de la abstracción que resulta de reemplazar las **ocurrencias libres** del paramétro de la abs. con (copias de) el argumento. 

Ejemplo:


```(λx. x + 1) 4 -> 4 + 1``` (β-reducción)

```4 + 1 <- (λx. x + 1) 4``` (β-abstracción)

```4 + 1 <-> (λx. x + 1) 4``` (β-conversión)

#### Data constructors
Se introducen los siguientes data-constructors: ```CONS, HEAD, TAIL``` donde:
- ```HEAD (CONS a b) -> a```
- ```TAIL (CONS a b) -> b```

Ejemplos:
- ```CONS 1 (CONS 2 NIL)``` (representa la lista [1, 2])
- ```HEAD (CONS 1 (CONS 2 NIL)) -> 1``` 
- ```TAIL (CONS 1 (CONS 2 NIL)) -> (CONS 2 NIL)```


Estos constructores pueden ser representados como abstracciones:
- ```CONS = (λa. λb. λf. f a b)``` 
- ```HEAD = (λx. x (λa. λb. a))```
- ```TAIL = (λx. x (λa. λb. b))```

```CONS 1 NIL``` es equivalente a ```(λa. λb. λf. f a b) 1 NIL -> (λ.f f 1 NIL)```

```HEAD (CONS 1 NIL)``` es equivalente a ```(λx. x (λa. λb. a)) (λ.f 1 NIL) -> (λ.f f 1 NIL) (λa. λb. a) -> (λa. λb. a) 1 NIL -> (λb. 1) NIL -> 1```

```TAIL (CONS 1 NIL)``` es equivalente a ```(λx. x (λa. λb. b)) (λ.f 1 NIL) -> (λ.f f 1 NIL) (λa. λb. b) -> (λa. λb. b) 1 NIL -> (λb. b) NIL -> NIL```

#### Conversion alpha (α)
La conversión alpha es una operación que cambia los nombres de las **variables ligadas** en una expresión.

Ejemplo:

```(λx. x+1) <-> (λy. y+1)``` (α-conversión)

El nuevo nombre de la variable ligada no debe ser igual a ninguna variable libre en el cuerpo de la abstracción. 

#### Conversion eta (η)
La conversión eta es una operación que elimina abstracciones redundantes. En forma general, si ```x``` no ocurre libre en ```F```, entonces:

 ```(λx. F x) <-> F``` (η-conversión)

F puede ser cualquier función. 

#### Como probar la interconvertibilidad de dos expresiones
Vamos a demostrar que se puede probar la interconvertiblidad de dos expresiones si aplicandolas al mismo argumento se obtiene el mismo resultado.

Dadas dos expresiones ```F1``` y ```F1``` y una variable ```w``` tal que no aparece libre en ```F1``` o ```F1```, si 

```F1 w <-> E``` y ```F2 w <-> E``` entonces ```F1 <-> F2```.

Prueba:

- ```F1 <-> (λw. F1 w)``` (η-conversión)

- ```<-> (λw. E)``` (Por hipótesis)

- ```<-> (λw. F2 w)```

- ```<-> F2``` (η-conversión)

#### Sustitución
La sustitución es una operación que reemplaza todas las ocurrencias libres de una variable en una expresión por otra expresión.

Notación: ```E[M/x]``` significa que se reemplazan todas las ocurrencias libres de ```x``` en ```E``` por ```M```. Y se define de la sig. manera:

- ```x[M/x] -> M```
- ```c[M/x] -> c``` (c es una constante o una variable distinta a x)
- ```(E F)[M/x] -> E[M/x] F[M/x]```
- ```(λx.E)[M/x] -> λx.E``` (no podemos sustituir variables ligadas)

- ```(λy.E)[M/x] -> (λy.E[M/x])``` si **x** no ocurre libre en E o **y** no ocurre libre en M. (**y** es una variable distinta a x) 
- ```(λy.E)[M/x] -> λz.(E[y/z])[M/x]``` si no se cumple lo anterior. z es una variable fresca (variable que no aparece libre en E o M )

#### Definicion de todas las reducciones
- ```(λx.E) M <-> E[M/x]     ``` (β-conversión)
- ```(λx.E)   <-> (λy.E[y/x])``` (α-conversión)
- ```(λx.E x) <-> E          ``` (η-conversión)


### Orden de reduccion

Una expresion está en **forma normal** si no contiene ninguna subexpresion que pueda ser reducida (*redexes*).

La evaluacion de una expresion es una secuencia de reducciones hasta que la expresion resultante quede en forma normal.

Una expresion se puede reducir de diferentes maneras. Algunas expresiones pueden no tener forma normal. Pero podemos demostrar que una expresion tiene una única forma normal. 

#### Primer teorema de Church-Rosser (CRT 1)
Si ```E1 <-> E2``` entonces existe una expresion ```E``` tal que:
- ```E1 ->z| E``` y ```E2 -> E```

Corolario: \
Una expresion no puede ser reducida a dos formas normales distintas (que no sean α-convertibles). \

Este corolario nos dice que todas las secuencias de reducciones finitas llegan al mismo resultado.

#### Segundo Teorema de Church-Rosser (CRT 2)

El CRT2 tiene que ver con una estrategia de reduccion llamada **estrategia de reduccion de orden normal**. La cual consiste en reducir primero el redex mas externo de mas a la izquierda. 

Teorema: \
Si ```E1 -> E2``` y ```E2``` está en forma normal, entonces existe una secuencia de reducciones de orden normal desde ```E1``` hasta ```E2```.

*Nota: En la teorica de la materia, esta estrategia es call-by-name. Y call-by-name débil es normal order reduction pero con la restruccion de que las expresiones que son abstracciones nunca se reducen, entonces, traduciendo los nombres de las teóricas:* \
***call-by-name**: normal order reduction* \
***call-by-name débil**: call-by-name*