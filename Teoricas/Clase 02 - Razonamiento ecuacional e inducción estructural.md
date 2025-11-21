# Teórica 2 - Razonamiento ecuacional e inducción estructural

El objetivo es demostrar que ciertas expresiones son equivalentes con el objetivo de justificar que un algoritmo es correcto y encontrar posibles optimizaciones. 

## Hipótesis de trabajo

Se asume lo siguiente: 

- Trabajamos con **tipos de datos inductivos**.
- Trabajamos con **funciones totales**.
  - Las ecuaciones deben cubrir todos los casos posibles.
  - La recursion siempre debe terminar
- El programa **no depende del orden** de las ecuaciones. 

## Razonamiento ecuacional

Raonamiento ecuacional es el proceso de demostrar que dos expresiones son equivalentes. Usamos tres tipos de prinicipios:

- Principio de reemplazo
- Principio de induccion estructural
- Principio de extensionalidad funcional

### Principio de reemplazo

Sea $e1 = e2$ una ecuación incluida en un programa. 
Las siguientes operaciones preservan la igualdad de expresiones: 

- Reemplazar **cualquier instancia** de $e1$ por $e2$.
- Reemplazar **cualquier instancia** de $e2$ por $e1$.

Si una igualdad se puede demostrar usando solo el principio de reemplazo, decimos que es una **igualdad por definición**.

### Inducción estructural

Queremos demostrar que una propiedad $P$ se cumple para todos los valores de un tipo de datos inductivo $T$: 

````haskell
data T = ConstBase1 <parametros>
       ...
       | ConstBaseN <parametros>
       | ConstRecursivo1 <parametros>
       ...
       | ConstRecursivoN <parametros>
````
#### Principio de inducción estructural

Sea $P$ una propiedad acerca de las expresiones de tipo T tal que:
- $P$ se cumple para todos los **constructores base**.
- $P$ vale sobre todos los constructores recursivos, asumiendo como **hipótesis inductiva** que $P$ se cumple para los parámetros de tipo T del constructor recursivo en cuestión. 

Entonces **$ \forall x::T.$ $P(x) $**

#### Principio de inducción sobre booleanos

Sea $P$ es una propiedad acerca de los valores booleanos,
Y se cumple **$P(False)$ y $P(True)$**,
Entonces: 
**$\boxed{ \forall b::Bool. \; P(b)}$**

####  Principio de inducción sobre pares

Sea $P$ es una propiedad acerca de pares de valoes de tipos $a$ y $b$,
Si **$\forall x::a, y::b.$ $P(x,y)$**
Entonces:
**$\boxed{\forall p::(a,b). \; P(p)} $**

#### Principio de inducción sobre naturales

```haskell
data Nat = Zero | Succ Nat
```
Sea $P$ es una propiedad acerca de los valores naturales,
Si **$P(Zero)$** y 
**$\forall n::Nat.$ $P(n) \implies P(Succ(n))$**
Entonces:
**$\boxed{\forall n::Nat. \; P(n)}$**

#### Principio de inducción sobre listas

```haskell
data [a] = [] | a : [a]
```
Sea $P$ es una propiedad acerca de expresiones de tipo $[a]$,
Si **$P([])$** y
**$\forall x::a, xs::[a].$ $P(xs) \implies P(x:xs)$**
Siendo $P(xs)$ la hipótesis inductiva y $P(x:xs)$ la tésis inductiva, entonces:
**$\boxed{\forall xs::[a]. \; P(xs)}$**

### Extensionalidad

La extensionalidad es la propiedad de que dos funciones son iguales si producen el mismo resultado para todos los valores de entrada.

Una expresión puede ser equivalente a otra dependiendo de dos puntos de vista:

- **Intensional**: Dos expresiones son iguales si están definidas de la misma manera
- **Extensional**: Dos expresiones son iguales si son indisitinguibles al observarlas. 

Se puede probar mediante inducción estructural:

#### Extensionalidad para pares

Si $p::(a,b)$, entonces:
**$\exist x::a, y::b. \; p = (x,y)$**

#### Extensionalidad para sumas

Si $s::\text{Either a b}$, entonces:
- o bien: **$\exist x::a. \; s = \text{Left} \; x $**
- o bien: **$\exist y::b. \; s = \text{Right} \; y$**

#### Extensionalidad funcional

Sean $f,g::a \to b$ dos funciones, entonces. 

Se define la siguiente propiedad inmediata:
Si $f = g$, entonces $\forall x::a. \; f(x) = g(x)$

#### Principio de extensionalidad funcional

Si **$\forall x::a. \; f(x) = g(x)$, entonces $f = g$**


#### Demostración de desigualdades 

Ahora queremos demostrar que **no** vale una igualdad de la forma $e1 = e2 :: A$

Si demostraramos $ e1 = e2 :: A$ entonces: 
$ obs \; e1 \rightsquigarrow True \iff obs \; e2 \rightsquigarrow True$
Para toda observación $obs :: A \to \text{Bool}$.

Ahora, por la contrarreciproca de lo anterior, si encontramos una observación $obs$ que distinga entre $e1$ y $e2$, entonces **$e1 \neq e2$.**

### Isomorfismos de tipos
A veces valores de tipos distintos representan la misma información. 

Decimos que dos tipos de datos A y B son **isomorfos** si:
1. Hay una función $f :: A \to B$ total. 
2. Hay una función $f :: B \to A$ total.
3. Se puede demostrar que $f \circ g = \text{id}_A :: A \to A$ 
4. Se puede demostrar que $g \circ f = \text{id}_B :: B \to B$

Escribimos $A \backsimeq B$ para denotar que A y B son isomorfos.

Las funciones de 1 y 2 transforman valores de un tipo en valores del otro tipo.  
Al componer las funciones de 1 y 2, se obtiene la identidad de A y B respectivamente.

Un ejemplo de isomorfismo es la currificación y descurrificación de funciones:

```haskell
curry :: ((a,b) -> c) -> a -> b -> c
curry f x y = f (x,y)

uncurry :: (a -> b -> c) -> (a,b) -> c
uncurry f (x,y) = f x y
```
Podemos demostrar que los tipos de datos son isomorfos:
$((a,b) \to c) \backsimeq (a \to b \to c)$  
Ya que podemos demostrar usando extensionalidad funcional e induccion sobre pares que:  
$\text{curry} \circ \text{uncurry = id}$ y  
$\text{uncurry} \circ \text{curry = id}$.