# Lógica de primer orden

Extiende la lógica proposicional con **términos** y **cuantificadores**

En la programación lógica, un programa toma una fórmula de LPO (Por ejemplo, $\forall X. P(X)$) y busca satisfacerla o refutarla. En caso de lograr satisfacerla, el sistema produce una salida que verifica la propiedad P. 

## Lenguajes de primer orden

Un lenguaje de primer orden está formado por: 

1. Conjunto de **símbolos de función** $F =  \{f,g,h,...\}$ donde cada símbolo tiene una **aridad** ($\geq 0$) que indica la cantidad de argumentos que recibe.
2. Conjunto de símbolos de **predicado** $P = \{P,Q,R,...\}$. Cada símbolo también tienen una **aridad** ($\geq 0$).

Por ejemplo el lenguaje de primer orden $\mathcal{L}_{aritmética}$ está formado por :  
- símbolos de función: $\{0^0, succ^1, +^2, *^2\}$
- símbolos de predicado: $\{=^2, <^2\}$

### Términos de primer orden

Fijamos un Lenguaje de primer orden y un conjunto infinito y numerable de variables $X = \{X, Y, Z, ...\}$.

#### Definición de términos

El conjunto $T$ de términos se define por la gramática:

``` t ::= X | f(t1, t2, ..., tn) ```

donde X es una variable y f es un símbolo de función de aridad n.

Por ejemplo en $\mathcal{L}_{aritmética}$ son términos: 

- ``succ(0)``
- ``+(succ(0), 0)`` o ``succ(0) + 0``

### Fórmulas de primer orden

Se extiende la lógica proposicional con tres nuevas expresiones.  
Siendo **P un símbolo de predicado de aridad n aplicado a n términos** y X una variable ligada por los cuantificadores, se define la gramática de fórmulas de primer orden de la siguiente manera:  
```
σ ::= P(t1, ..., tn)   (fórmula atómica) 
      | ∀X. σ          (cuantificador universal)
      | ∃X. σ          (cuantificador existencial)
      | ⊥
      | σ ⇒ σ
      | σ ∧ σ
      | σ ∨ σ
      | ¬σ
```

Ejemplo de fórmula en $\mathcal{L}_{aritmética}$ :

- $\forall X. \forall Y. =(+(succ(X), Y), 0 )$ Es equivalente a $\forall X. \forall Y. succ(X) + Y = 0$

#### Igualdad de fórmulas de primer orden

Dos formulas que solo difieren en el nombre de sus variables ligadas se consideran **iguales**.

Ejemplo:

- $\forall X. \exists Y.  P(X, Y) \equiv \forall A. \exists B. P(A, B)$

#### Sustitución de variables

Notamos $\sigma \{X := t\}$ a la sustitución de las ocurrencias libres de la variable X por el término t en la fórmula $\sigma$, evitando la captura de variables. 

# Deducción natural en LPO

Se extiende el sistema de deducción natural de lógica proposicional para la lógica de primer orden: 

- $\Gamma$ es un conjunto de fórmulas a la que llamamos **contexto**
- $\Gamma \vdash \sigma$ es un **secuente**. 

Se agregan a las reglas de deducción natural las reglas de introducción y eliminación para los cuantificadores universales y existenciales.
## Reglas de deducción natural

### Reglas de eliminación 

$$
\frac{\Gamma \vdash \forall X. \sigma }{\Gamma \vdash \sigma\{X := \tau\}}\forall_e \quad 
\frac{\Gamma \vdash \exists X. \sigma \quad \Gamma, \sigma \vdash \tau \quad X \notin \text{FV}(\Gamma, \tau)}{\Gamma \vdash \tau}\exists_e
$$

### Reglas de introducción

$$
\frac{\Gamma \vdash \sigma \quad X \notin \text{FV}(\Gamma)}{\Gamma \vdash \forall X. \sigma}\forall_i \quad
\frac{\Gamma \vdash \sigma\{X := \tau\}}{\Gamma \vdash \exists X.\sigma}\exists_i
$$

# Semántica de LPO

## Estructuras de primer orden

Se supone fijado un lenguaje de primer orden $\mathcal{L}$
Una estructura de primer orden es un par $\mathcal{M} = (M, I)$ donde:
- $M$ es un conjunto **no vacío** llamado **universo**. (Por ejemplo, para la estructura de los naturales en $\mathcal{L}_{aritmética}$, $M = \mathbb{N}$) 
- $I$ es una función que le da una **interpretación** a cada símbolo del lenguaje $\mathcal{L}$
- Para cada símbolo de función $f$ de aridad $n$: 
$$I(f) : M^n \to M$$
  $I(f)$ es una función la cual interpreta el resultado de $f$ como otro elemento del universo
- Para cada símbolo de predicado $P$ de aridad $n$: 
$$I(P) \subseteq M^n$$
  $I(P)$ es el conjunto de n-uplas de elementos del universo que satisfacen $P$
## Interpretación de los términos

Se supone fijada una estructura de primer orden $\mathcal{M} = (M,I)$ 
### Asignación
Una **asignación** es una función que a cada **variable** del conjunto definido de variables $\mathcal{X}$ le asigna un **elemento del universo**: 
$$ \alpha : \mathcal{X} \to M $$
### Interpretación 
Cada término $t \in \mathcal{T}$ (del conjunto definido de términos de primer orden) se interpreta como un elemento $\alpha (t) \in M$. 
$$ \alpha(\textsf{f}(t_1, ...t_n)) = I(\textsf{f})(\alpha(t_1),...,\alpha(t_n))$$
### Relación de satisfacción 
Definimos la relación de satisfacción $\alpha \vDash_{\mathcal{M}} \sigma$
"La asignación $\alpha$ bajo la estructura $\mathcal{M}$ satisface la fórmula $\sigma$"

Se define inductivamente:
Se supone fijada una estructura de primer orden $\mathcal{M} = (M,I)$
![[Pasted image 20250206171242.png]]
## Validez y satisfactibilidad
Una fórmula $\sigma$ es: 
- **Válida**
  si $\alpha \vDash_{\mathcal{M}}$ para toda $\mathcal{M}, \alpha$

- **Satisfactible**
  Si $\alpha \vDash_{\mathcal{M}}$ para alguna $\mathcal{M}, \alpha$

- **Inválida**
  Si $\alpha \nvDash_{\mathcal{M}}$ para alguna $\mathcal{M}, \alpha$

- **Insatisfactible**
  Si $\alpha \nvDash_{\mathcal{M}}$ para toda $\mathcal{M}, \alpha$
### Observaciones
$\sigma$ es válida $\leftrightarrow$ $\sigma$ **no** es inválida
$\sigma$ es insatisfactible $\leftrightarrow$ $\sigma$ **no** es insatisfactible 
$\sigma$ es satisfactible $\leftrightarrow$ $\neg \sigma$ es inválida 

**$\sigma$ es válida $\leftrightarrow$ $\neg \sigma$ es insatisfactible** 
## Modelos
**Sentencia**: fórmula $\sigma$ sin variables libres
**Teoría de primer orden**: conjunto de sentencias
### Consistencia 
Una teoría $\mathcal{T}$ es **consistente** si $\mathcal{T} \nvdash ⊥$ (no deriva una contradicción)
### Modelo
Una estructura $\mathcal{M} = (M, I)$ es un **modelo** de una teoría $\mathcal{T}$ si vale $\alpha \vDash \sigma$ para toda asignación $\alpha : \mathcal{X} \to M$ y toda fórmula $\sigma \in \mathcal{T}$ 
### Corrección y completitud
#### Teorema de Gödel
Dada una teoría $\mathcal{T}$ , son equivalentes:
1. $\mathcal{T}$ es **consistente**
2. $\mathcal{T}$ tiene un **modelo**. (al menos uno)
##### Corolario I
Dada una fórmula $\sigma$, son equivalentes:
1. $\vdash \sigma$ es derivable
2. $\sigma$ es **válida**
##### Corolario II
Dada una fórmula $\sigma$, son equivalentes: 
3. $(\vdash \neg \sigma)$ es derivable
4. $\sigma$ es **insatisfactible**
#### Problema de la decisión
No es posible dar con un algoritmo que cumpla con la siguiente especificación:
	**Entrada**: una fórmula $\sigma$ 
	**Salida**: un booleano que indica si $\sigma$ es válida
(Church-Turing)
