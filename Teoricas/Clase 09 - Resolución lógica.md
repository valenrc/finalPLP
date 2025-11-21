## Introducción a Prolog
### Programas
Un programa en Prolog es un conjunto de reglas. Cada regla es de la forma:
$$\sigma \quad \text{:-} \quad \tau_1,...,\tau_n.$$
Donde $\sigma, \tau_1,...,\tau_n$ son fórmulas atómicas. 

La cuales tienen la siguiente interpretación lógica:
$$\forall X_1 ...\forall X_k \;. ((\tau_1 \;\land\;...\:\land\;\tau_n) \Rightarrow \sigma)$$
Donde $X_1,...,X_k$ son las variables libres de $\sigma, \tau_1,...,\tau_n$.

Si $n=0$ entonces la regla es un **hecho**.
Ejemplo:
```prolog
% Reglas donde n=0 (hechos)
padre(zeus, ares).

% Reglas donde n>0
hermano(X, Y) :- padre(Z, X), padre(Z, Y), X \= Y.
```
### Consultas
Una consulta es de la forma: 
$$ \mathtt{?-} \; \sigma_1, ..., \sigma_n$$
La cual tiene la siguiente interpretación lógica:
$$\exists X_1,...,X_k \;. (\sigma_1 \;\land\;...\;\land\;\sigma_n)$$
Donde $X_1,...,X_k$ son las variables libres de $\sigma_1,...,\sigma_n$.

Prolog busca demostrar la fórmula $\sigma_1 \;\land\;...\;\land\;\sigma_n$ tratando de refutar su negación.
Si se quiere demostrar $\tau$ se busca una refutación para $\neg \tau$ mediante el **método de resolución**.
## Resolución para LPO
Entrada: Una fórmula $\sigma$ en LPO.
Salida: *True* si $\sigma$ es válida, *False* en caso contrario.

*Si $\sigma$ es válida, el método siempre termina*.
*Si $\sigma$ no es válida, el método puede no terminar*.
### Método de resolución
1. Escribir $\neg \sigma$ como un conjunto $\mathcal{C}$ de cláusulas (forma clausal).  
2. Buscar una refutación de $\mathcal{C}$ mediante resolución.
   Una refutación es una derivación de $C \vdash \bot$. 

Si se encuentra una refutación de $\mathcal{C}$ entonces:
- Vale $\neg \sigma \vdash \bot$
    Es decir, $\neg \sigma$ es insatisfactible/contradicción.
    Luego, vale $\vdash \sigma$, por lo tanto $\sigma$ es válida/tautología
Si no se encuentra una refutación de $\mathcal{C}$ entonces:
- No vale $\neg \sigma \vdash \bot$
	Es decir, $\neg \sigma$ es satisfactible.
	Luego, no vale $\vdash \sigma$, por lo tanto $\sigma$ no es válida.
#### Paso 1: Pasaje a forma clausal
1. Reescribir los $\Rightarrow$ usando $a \Rightarrow b \equiv \neg a \lor b$.
2. Pasar a forma normal negada, empujando los $\neg$ hacia adentro.	```
3. Pasar a forma normal prenexa, extrayendo los $\forall, \exists$ hacia afuera.
   Una fórmula está en FNP si está escrita únicamente con cuantificadores seguido de una fórmula en FNN.
4. Pasar a forma normal de Skolem, "skolemizando" los cuantificadores existenciales. (Este paso no produce una fórmula equivalente a la original pero si preserva la satisfactibilidad)
5. Pasar a forma normal conjuntiva, distribuyendo los $\lor$ sobre $\land$.
6. Empujar los cuantificadores hacia adentro de las conjunciones.
#### Paso 2: Resolución
Una vez obtenido $\mathcal{C}$, se procede a buscar una **refutación** mediante resolución. Es decir, una demostración de $\mathcal{C} \vdash \bot$.
$$\boxed{\frac{\begin{matrix}\{\textcolor{red}{\sigma_1,...,\sigma_p},\ell_1,...,\ell_n\} \quad \{\textcolor{red}{\neg\tau_1,...,\neg\tau_q},...,\ell_1^{\ '},...,\ell_m^{\ '}\} \\ S = \text{mgu}(\textcolor{red}{\sigma_1} \stackrel{?}{=}... \stackrel{?}{=} \textcolor{red}{\sigma_p} \stackrel{?}{=} \textcolor{red}{\neg\tau_1} \stackrel{?}{=} ...\stackrel{?}{=} \textcolor{red}{\neg\tau_q}) \end{matrix}}{S(\{ \ell_1,...,\ell_n,\ell_1^{\ '},...,\ell_m^{\ '} \})}}$$
Con $p,q>0$
##### Resolución binaria
La resolución binaria es un caso particular de la resolución donde $p=q=1$.Es decir, se resuelven solo dos cláusulas a la vez.
$$\boxed{\frac{\{\textcolor{red}{\sigma},\ell_1,...,\ell_n\} \quad \{\textcolor{red}{\neg\tau},\ell^{'}_{1}...,\ell^{'}_{m}\} \quad S = \text{mgu}(\textcolor{red}{\sigma} \stackrel{?}{=} \textcolor{red}{\neg\tau})}{S(\{ \ell,\ell^{\ '} \})}}$$
### Corrección del método de resolución
#### Corrección del pasaje a forma clausal
Dada una fórmula $\sigma$ en LPO:
1. El pasaje a forma clausal termina
2. El conjunto de cláusulas $\mathcal{C}$ obtenido es equisatisfactible a $\sigma$.Es decir, $\sigma$ es satisfactible si y solo si $\mathcal{C}$ solo si $\mathcal{C}$ es satisfactible. 
#### Corrección del algoritmo de refutación
Dado un conjunto de cláusulas $\mathcal{C}_0$
1. Si $\mathcal{C}_0 \vdash \bot$ entonces el algoritmo de refutación termina.
2. El algoritmo devuelve $\mathsf{INSAT}$ si y solo si $\mathcal{C}_0 \vdash \bot$.  
3. Si $\mathcal{C}_0 \nvdash \bot$ entonces el algoritmo puede no terminar. 