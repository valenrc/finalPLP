# Funciones comunes en Haskell y Prolog
## Haskell
### Prelude
```haskell
even :: Integer -> Bool
odd :: Integer -> Bool
id :: a -> a
const :: a -> b -> a
--Composicion de funciones
(.) :: (b -> c) -> (a -> b) -> a -> c
-- Intercambia los argumentos de una funcion
flip :: (a -> b -> c) -> b -> a -> c
-- Aplica una funcion a un argumento
($) :: (a -> b) -> a -> b

-- Funciones de listas
-- aplica una funcion a cada elemento de una lista
map :: (a -> b) -> [a] -> [b]
-- filtra los elementos de una lista que cumplen una condicion
filter :: (a -> Bool) -> [a] -> [a]
-- concatena listas
(++) :: [a] -> [a] -> [a]
-- concatena listas de listas
concat :: [[a]] -> [a]
-- devuelve una lista con sus elementos en orden inverso
reverse :: [a] -> [a]
-- accede al elemento de una lista en una posicion dada
(!!) :: [a] -> Int -> a
-- elimina los n primeros elementos de una lista
drop :: Int -> [a] -> [a]
-- tomar los n primeros elementos de una lista
take :: Int -> [a] -> [a]
-- reduce una lista a un unico valor de derecha a izquierda
-- foldl f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn
foldr :: (a -> b -> b) -> b -> [a] -> b
-- reduce una lista a un unico valor de izquierda a derecha
-- foldr f z [x1, x2, ..., xn] == x1 `f` (x2 `f` ... (xn `f` z)...)
foldl :: (b -> a -> b) -> b -> [a] -> b
-- mapea una lista con una funcion y luego concatena los resultados
concatMap :: (a -> [b]) -> [a] -> [b]
-- devuelve el maximo de una lista
maximum :: Ord a => [a] -> a
-- devuelve el minimo de una lista
minimum :: Ord a => [a] -> a

--une dos listas como si fueran conjuntos
union :: Eq a => [a] -> [a] -> [a]
--interseccion de dos listas
intersect :: Eq a => [a] -> [a] -> [a]
--diferencia de dos listas
(\\) :: Eq a => [a] -> [a] -> [a]
--elimina los elementos duplicados de una lista
nub :: Eq a => [a] -> [a]
--elimina la primera ocurrencia de un elemento en una lista
delete :: Eq a => a -> [a] -> [a]

-- crea una lista infinita con un valor dado
repeat :: a -> [a]
-- crea una lista infinita dada una funcion y un valor inicial, donde cada elemento es el resultado de aplicar la funcion al elemento anterior
iterate :: (a -> a) -> a -> [a]
-- span p xs devuelve un par de listas, donde la primera lista contiene el prefijo mas grande de xs cuyos elementos cumplen la condicion p, y la segunda lista contiene el resto de los elementos
span :: (a -> Bool) -> [a] -> ([a], [a])
-- partition p xs devuelve un par de listas, donde la primera lista contiene los elementos de xs que cumplen la condicion p, y la segunda lista contiene los elementos que no la cumplen
partition :: (a -> Bool) -> [a] -> ([a], [a])
```
## Prolog
```prolog
% Listas
sort(+List, -SortedList)
msort(+List, -SortedList) % no borra duplicados
member(+Element, +List)
append(+List1, +List2, -List3)
delete(+List, +Element, -List2) % borra todas las ocurrencias
select(+Element, +List, -List2) % borra solo la primera ocurrencia
last(+List, -LastElement) 
is_list(+List)
numlist(+Low, +High, -List) % genera una lista de numeros consecutivos
length(+List, -Length)
flatten(+NestedList, -FlatList) % aplana una lista de listas
reverse(?List, ?ReversedList) 
sum_list(+List, -Sum) % suma los elementos de una lista
max_list(+List, -Max) % maximo de una lista

% built-in
between(+Low, +High, ?Value)
var(+Term) % true si Term es una variable
nonvar(+Term) % true si Term no es una variable
atom(+Term) % atomo: cadena de caracteres que no empieza con mayuscula


% Arithmetic
number(+Term) % true si Term es un numero
integer(+Term) % true si Term es un entero
abs(+Expr) % valor absoluto
round(+Expr)
max(+Expr1, +Expr2)
min(+Expr1, +Expr2)
gcd(+Expr1, +Expr2)
+Expr1 mod +Expr2 % modulo

% Set
list_to_set(+List, -Set) % elimina duplicados
is_set(+Set) % true si no hay duplicados
union(+Set1, +Set2, -Union)
intersection(+Set1, +Set2, -Intersection)
subtract(+Set1, +Set2, -Difference)
subset(+Set1, +Set2) % true si Set1 es subconjunto de Set2
permutation(?Xs, ?Ys) % true si Xs es una permutacion de Ys

```