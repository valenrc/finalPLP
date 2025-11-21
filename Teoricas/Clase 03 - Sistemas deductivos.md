# Teorica 03 - Sistemas deductivos

## Lógica proposicional

La lógica proposicional es un sistema deductivo que se encarga de estudiar la validez de los argumentos que se pueden formar a partir de proposiciones.
Las lógicas proposicionales carecen de cuantificadores, pero tienen variables proposicionales, es decir, que se pueden interpretar como proposiciones con un valor de verdad definido. 
### Sintáxis

#### Símbolos

Negación, conjunción, disyunción, implicación, bicondicional y paréntesis.
**$\neg, \land, \lor, \rightarrow, \leftrightarrow, (, )$**
#### Variables proposicionales

Son infinitas: $ P, Q, R, S, T, ...$
Las variables proposicionales son las letras que representan proposiciones. Por ejemplo, $P$ puede representar la proposición "Hace frío".
#### Formulas o proposiciones

- Combinciones **apropiadas** de simbolos y variables proposicionales
Ejemplo: $(P \land Q) \rightarrow R$
### Definición inductiva
#### Fórmulas
1. cualquier variable proposicional es una fórmula
2. si $\tau$ es una fórmula, entonces $\neg \tau$ también lo es
3. si $\tau$ y $\sigma$ son fórmulas, entonces $(\tau \land \sigma), (\tau \lor \sigma), (\tau \rightarrow \sigma), (\tau \leftrightarrow \sigma)$ también lo son

Las fórmulas son un ejemplo de **conjunto inductivo**.
- Tienen un esquema que permite probar propiedades sobre ellos (**inducción estructural**)
- Tienen un esquema de recursión que permite definir funciones sobre ellos (**recursión estructural**)
### Semántica
#### Semántica clásica
Consiste en asignarle **valores de verdad** {V, F} a las fórmulas.  
Dos enfoques equivalentes para dar semántica a las fórmulas: 
- **Tablas de verdad**
- **Valuaciones**

Cada fila de una tabla de verdad se corresponde con una valuación. Para una fórmula de $n$ variables proposicionales, hay $2^n$ valuaciónes posibles o filas en la tabla de verdad.
#### Valuaciones
Una valuación es una función $\rm{v} : \mathcal{V} \to {V,F}$ que asigna un valor de verdad a cada **variable proposicional**.

Una valuación **satisface** una proposicion $\tau$ si ***$\rm{v} \vDash \tau$***.

Definición de la relación $\vDash$:

- $\rm{v} \vDash \it{P} \leftrightarrow \rm{v}(\it{P}) = V$
- $\rm{v} \vDash \neg \tau \leftrightarrow \rm{v} \nvDash \tau$
- $\rm{v} \vDash \tau \land \sigma \leftrightarrow \rm{v} \vDash \tau$ y $\rm{v} \vDash \sigma$
- $\rm{v} \vDash \tau \lor \sigma \leftrightarrow \rm{v} \vDash \tau$ o $\rm{v} \vDash \sigma$
- $\rm{v} \vDash \tau \rightarrow \sigma \leftrightarrow \rm{v} \nvDash \tau$ o $\rm{v} \vDash \sigma$
- $\rm{v} \vDash (\tau \leftrightarrow \sigma) \leftrightarrow (\rm{v} \vDash \tau \leftrightarrow \rm{v} \vDash \sigma)$
#### Tautologías y satisfactibilidad

Dada una fórmula $\tau$, esta es: 

- **Tautología** si $\rm{v} \vDash \tau$ para toda valuación $\rm{v}$
- **Satisfactible** si existe una valuación $\rm{v}$ tal que $\rm{v} \vDash \tau$
- **Insatisfactible** si no es satisfactible
- **Lógicamente equivalente** a otra fórmula $\sigma$ cuando $\rm{v} \vDash \tau \leftrightarrow \rm{v} \vDash \sigma$ para toda valuación $\rm{v}$
##### Teorema:

>Una fórmula $\tau$ es una tautología si y solo si $\neg \tau$ es insatisfactible.

Este teorema sugiere un método para probar que una fórmula $\tau$ es una tautología: probar que $\neg \tau$ es insatisfactible. 
### Deducción natural

La deducción natural en lógica proposicional es un método que permite demostrar la validez de argumentos.
#### Definiciones
##### Verdades universales

Son fórmulas cuyo valor de verdad **no** depende de cómo se interpretan. En la lógica proposicional, las verdades universales son las **tautologías**.  
Contamos con una caracterización semántica de las tautologías (sección Tautologías y satisfactibilidad), pero tambien interesa obtener una caracterización sintáctica:  
**Un conjunto de fórmulas que se puedan **probar** en un sistema deductivo**
#### Sistema deductivo basado en reglas de prueba

##### Secuente

A partir de asumir que el conjunto de fórmulas $\{\tau_1, \tau_2, ..., \tau_n\}$ son tautologías, podemos obtener una prueba de la validez de $\sigma$.
$$\boxed{\tau, \tau, ..., \tau \vdash \sigma}$$
##### Reglas de prueba

Permiten deducir un secuente (**conclusión**) a partir de otros secuentes (**premisas**). 

Donde:  
$\Gamma_1 \vdash \tau_1 \;...\; \Gamma_n \vdash \tau_n : \text{premisas}$  
$\Gamma \vdash \sigma : \text{conclusión}$

$$\boxed{\frac{\Gamma_1 \vdash \tau_1 \;...\; \Gamma_n \vdash \tau_n}{\Gamma \vdash \sigma}{nombre}}$$
##### Pruebas

Se obtienen aplicando reglas de prueba a premisas y conclusiones obtenidas previamente.

Un secuente es **válido** si existe una prueba de la conclusión a partir de las premisas.

##### Teoremas

Llamamos **teorema** a toda fórmula lógica $\tau$ tal que el secuente $\vdash \tau$ es válido.  
El hecho de que el conjunto de asunciones sea vacío indica que la prueba no depende de nada y es siempre válida. 
Siempre se puede transformar un secuente de la forma $\tau_1, \tau_2, ..., \tau_n \vdash \sigma$ en un secuente de la forma $\vdash \tau_1 \rightarrow \tau_2 \rightarrow ... \rightarrow \tau_n \rightarrow \sigma$ aplicando la regla $\rightarrow_i$. 

##### Contradicción

Una contradicción es una expresión de la forma $(\tau \land \neg \tau)$ o $(\neg \tau \land \tau)$.

- Denotamos una contradiccion con el símbolo **$\bot$**  
- Cualquier fórmula puede ser derivada a partir de una contradicción

#### Reglas de prueba

##### Axioma

$$\frac{}{\tau \vdash \tau}{ax}$$

##### Debilitamiento (weakening)

$$ \frac{\Gamma \vdash \sigma}{\Gamma, \tau \vdash \sigma}{W}$$ 

##### Reglas de introducción

$$ \frac{\Gamma \vdash \tau \quad \Gamma \vdash \sigma}{\Gamma \vdash \tau \land \sigma} \land_i  \frac{}{}$$

$$ \frac{\Gamma \vdash \tau}{\Gamma \vdash \tau \lor \sigma} \lor_{i_1} \frac{}{} \quad \frac{\Gamma \vdash \sigma}{\Gamma \vdash \tau \lor \sigma} \lor_{i_2}$$

$$ \frac{\Gamma, \tau \vdash \sigma}{\Gamma \vdash \tau \rightarrow \sigma} \rightarrow_i \frac{}{}$$

$$ \frac{\Gamma, \tau \vdash \bot}{\Gamma \vdash \neg \tau} \neg_i $$

##### Reglas de eliminación

$$ \frac{\Gamma \vdash \tau \land \sigma}{\Gamma \vdash \tau} \land_{e_1} \frac{}{} \quad \frac{\Gamma \vdash \tau \land \sigma}{\Gamma \vdash \sigma} \land_{e_2} \frac{}{} $$

$$ \frac{\Gamma \vdash \tau \lor \sigma \quad \Gamma, \tau \vdash \rho \quad \Gamma, \sigma \vdash \rho}{\Gamma \vdash \rho} \lor_e $$

$$ \frac{\Gamma \vdash \tau \rightarrow \sigma \quad \Gamma \vdash \tau}{\Gamma \vdash \sigma} \rightarrow_e $$

$$ \frac{\Gamma \vdash \tau \quad \Gamma \vdash \neg \tau}{\Gamma \vdash \bot} \neg_e \quad \frac{\Gamma \vdash \neg \neg \tau}{\Gamma \vdash \tau} \neg \neg_e$$

$$ \frac{\Gamma \vdash \bot}{\Gamma \vdash \tau} \bot_e $$

##### Reglas derivadas

$$ \frac{\Gamma \vdash \tau}{\Gamma \vdash \neg \neg \tau} \neg \neg_i \quad \frac{\Gamma \vdash \tau \rightarrow \sigma \quad \Gamma \vdash \neg \sigma}{\Gamma \vdash \neg \tau}{MT} $$

$$ \frac{\Gamma, \neg \tau \vdash \bot}{\Gamma \vdash \tau}{PBC} \quad \frac{}{\Gamma \vdash \tau \lor \neg \tau}{LEM} $$

Las reglas derivadas son las que se pueden obtener a partir de las reglas básicas (primitivas) de la deducción natural.

#### Lógica clásica vs constructiva/intuicionista

En la lógica constructiva o intuicionista, no se permite la prueba por contradiccion (PBC) ni la prueba del tercero excluido (LEM). Esto es debido a que se rechaza el principio de bivalencia (una proposición es verdadera o falsa, pero no ambas) que justifica las pruebas de lógica clásica. 

> In classical logic, the meanings of the logical connectives are explained by means of the truth tables, and these explanations justify LEM. However, the truth table explanations involve acceptance of the principle of bivalence [...]. The intuitionist does not accept bivalence, at least not in mathematics. The reason is the view that mathematical sentences are made true and false by proofs which mathematicians construct.
>
> &mdash; *Pagin, Peter (1998). Intuitionistic logic and antirealism. Routledge encyclopedia*

Las reglas $\neg \neg_e$, $PBC$ y $LEM$ son equivalentes y se derivan cada una a partir de la otra. Estas tres reglas forman parte de la **lógica clásica**.

Esto significa que todas la demostraciones formales obtenidas en lógica intuicionista son válidas en lógica clásica, pero no todas las pruebas obtenidas en la lógica clásica son válidas en la lógica intuicionista. 

#### Correción y completitud
Tenemos definiciones separadas para "satisfactible" $\vdash$ y "tautologia" $\vDash$. Tenemos que probar que, en deducción natural, estas dos definiciones son lo mismo, o sea:  
- Solo deberíamos poder probar cosas que efectivamente sean verdaderas,  
- y deberíamos poder probar todas las cosas que sean verdaderas.

Estas dos propiedades son **correción** (soundness) y **completitud** (completness).

Sabemos que:
- si $\vdash \tau$ es un secuente válido, entonces $\tau$ tiene una prueba
- $\tau$ es una tautología si $\rm{v} \vDash \tau$ para toda valuación $\rm{v}$

##### Consecuencia semántica

Para $\tau_1, \tau_2,..., \tau_n, \sigma$ fórmulas de la lógica proposicional,
$$ \tau_1, \tau_2,..., \tau_n \vDash \sigma $$
cuando toda valuación $\rm{v}$ que satisface todas las premisas ($\rm{v} \vDash \tau_i$ para todo $i \in 1...n$), también satisface la conclusión ($\rm{v} \vDash \sigma$).

##### Corrección

$\sigma_1, ..., \sigma_n \vdash \tau$ secuente válido implica que $\sigma_1, ..., \sigma_n \vDash \tau$.

##### Completitud I

$\sigma_1, ..., \sigma_n \vDash \tau$ implica que $\sigma_1, ..., \sigma_n \vdash \tau$ secuente válido.

##### Satisfactiblidad en un conjunto de fórmulas

Sea $\Gamma = \{ \tau_1, \tau_2, ..., \tau_n \}$ un conjunto de fórmulas de la lógica proposicional.  
$\Gamma$ **tiene un modelo** (o es satisfacible) si existe una valuación $\rm{v}$ tal que  
$\rm{v} \vDash \tau$ para toda $\tau \in \Gamma$

Ejemplo: $ \{ P, Q, Q \to \neg P \} $ no tiene un modelo

##### Conjunto consistente de fórmulas

$\Gamma$ se dice **consistente** si $\Gamma \nvdash \bot$,  
es decir, si no se puede derivar una contradicción a partir de las fórmulas de $ \Gamma $.

Ejemplo: $\{ P, Q, Q \to \neg P \}$ no es consistente

##### Completitud II 
Queremos probar que $\Gamma \nvdash \tau$ implica $\Gamma \nvDash \tau$.
O sea, si no podemos derivar $\tau$ a partir de $\Gamma$, entonces para toda valuación $\rm{v}$ tal que $\rm{v} \vDash \Gamma$, se tiene que $\rm{v} \nvDash \tau$.

Para eso usamos dos lemas: 

1. Si $\Gamma \nvdash \tau$, entonces $\Gamma \cup \{ \neg \tau \}$ es consistente.
2. $\Gamma$ es consistente si y solo si $\Gamma$ tiene un modelo (es satisfactible). 

##### Conjunto consistente maximal

Un conjunto es consistente maximal si es el conjunto mas grande que es consistente.

$\Gamma$ es consistente maximal si:
1. $\Gamma$ es consistente
2. Si $\Gamma \subseteq \Delta$ y $\Delta$ es consistente, entonces $\Gamma = \Delta$

##### Lema de saturación

Si $\Gamma$ es consistente, entonces existe un conjunto consistente maximal $\Delta$ tal que $\Gamma \subseteq \Delta$.

Con estas dos últimas definiciones podemos probar los lemas 1 y 2 y demostrar la completitud de la deducción natural.