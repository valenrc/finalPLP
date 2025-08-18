--- EJERCICIO 1.a ---
max2 :: (Float, Float) -> Float
max2 (x,y) | x >= y = x
           | otherwise = y

normaVectorial :: (Float, Float) -> Float
normaVectorial (x,y) = sqrt (x^2 + y^2)

substract :: Float -> Float -> Float
substract = flip (-)

predecesor :: Float -> Float
predecesor = substract 1

{-
(Float -> Float) es el tipo de la funcion f
(Float -> Float) -> Float significa que evaluarEnCero recibe una funcion (f) y devuelve f 0 (que tambien es Float)
Si no suponemos que todos los numeros son de tipo float entonces el tipo de la funcion sería
(a -> b) -> b
-}
evaluarEnCero :: (Float -> Float) -> Float
evaluarEnCero = \f -> f 0

{-
f :: Float -> Float
g :: Float -> Float
g = f.f
-}
dosVeces :: (Float -> Float) -> (Float -> Float)
dosVeces = \f -> f.f

{-
map  :: (a -> b) -> [a] -> [b]

flip :: (a -> b -> c) -> (b -> a -> c)
flip :: (Float -> Float -> Float) -> (Float -> Float -> Float)
-}
flipAll :: [Float -> Float -> Float] -> [Float -> Float -> Float]
flipAll = map flip

{-
f :: a -> b -> c

flip1 :: (a  -> b  -> c ) -> b  -> a  -> c
flip2 :: (a' -> b' -> c') -> b' -> a' -> c'

Uso correspondencia Curry-howard para deducir el tipo:

(a  -> b  -> c) ?= (a' -> b' -> c') -> b' -> a' -> c'
a => (a' -> b' -> c')

b -> c ?= b' -> a' -> c'
b => b'
c => a' -> c'

entonces (b -> a -> c) => b' -> (a' -> b' -> c') -> a' -> c'
flip1 flip2 :: b' -> (a' -> b' -> c') -> a' -> c'
-}
flipRaro :: Float -> (Float -> Float -> Float) -> Float -> Float
flipRaro = flip flip

--- EJERCICIO 1.b ---
{-
* max2 no esta currificada
* normaVectorial no está currificada
-}

max2Currified :: Float -> Float -> Float
max2Currified x y | x>=y = x
                  | otherwise = y

normaVectorialCurrified :: Float -> Float -> Float
normaVectorialCurrified x y = sqrt (x^2 + y^2)

--- EJERCICIO 2 ---
_curry :: ((a,b) -> c) -> (a -> b -> c)
_curry f = \x y -> f (x,y)

_uncurry :: (a -> b -> c) -> ((a,b) -> c)
_uncurry f = \(x,y) -> f x y

-- curryN
{-
No se puede definir curryN porque el tipado en Haskell es estático.
Por ejemplo, el tipo para las funciones
curry2 :: ((a,b) -> c) -> (a -> b -> c)
curry3 :: ((a,b,c) -> d) -> (a -> b -> c -> d)
es distinto. Entonces no hay manera de "parametrizar" la cantidad de argumentos.

-}

--- EJERCICIO 3 ----
{-
---ESQUEMAS DE RECURSION
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)

foldl :: (a -> b -> b) -> b -> [a] -> b
foldl f ac [] = ac
foldl f ac (x:xs) = fold f (f ac x) xs

recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr f [] z = z
recr f (x:xs) z = f x xs (recr f z xs)

  EJEMPLOS:
  -- recursion estructural (foldr) --
  reverse [] = []
  reverse (x:xs) = (reverse xs) ++ [x]

  reverse = foldr (\x rec -> rec ++ [x]) []

  -- recursion iterativa (foldl) --
  digitsToNumber ac [] = ac
  digitsToNumber ac (x:xs) = digitsToNumber (ac * 10 + x) xs

  digitsToNumber = foldl (\acc x -> acc * 10 + x) 0

  -- recursion primitiva (recr)
  trim [] = []
  trim (x:xs) = if x == ' ' then trim xs else x:xs

  trim = recr (\x xs rec -> if x == ' ' then rec else x:xs }) [] 

---
z es el valor inicial del acumulador, la primera operacion a evaluar va a ser f x_n z
donde x_n es el valor de mas a la derecha de la lista
-}
_sum :: (Num a) => [a] -> a
_sum = foldr (+) 0
{-
sum [1,2,3]
= foldr (+) 0 [1,2,3]
= (+) 1 (foldr (+) 0 [2,3])
= (+) 1 ((+) 2 (foldr (+) 0 [3]))
= (+) 1 ((+) 2 ((+) 3 foldr (+) 0 []))
= (+) 1 ((+) 2 ((+) 3 0))
= (+) 1 ((+) 2 3)
= (+) 1 5
= 6
-}

_elem :: (Eq a) => a -> [a] -> Bool
_elem n = foldr (\x z -> z || x==n) False

_append :: [a] -> [a] -> [a]
_append l1 l2 = foldr (:) l2 l1

_filter :: (a -> Bool) -> [a] -> [a]
_filter f = foldr (\x z -> if f x then x:z else z) []

{-
_map (+1) [1,2]
= foldr (:).(+1) [] [1,2]
= ((:).(+1)) 1 (foldr (:).(+1) [] [2]) 
= ((:).(+1)) 1 ((:).(+1) 2 (foldr (:).(+1) [] []))
= ((:).(+1)) 1 ((:).(+1) 2 [])
= ((:).(+1)) 1 ((:) ((+1) 2) [])
= ((:).(+1)) 1 [(+ 1) 2]
= ((:).(+1)) 1 [3]
= (:) ((+1) 1) [3]
= (:) (2) [3]
= [2,3]
-}
_map :: (a -> b) -> [a] -> [b]
_map f = foldr ((:).f) []

mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f = foldr1 (\x z -> if f x z then x else z)

sumasParciales :: (Num a) => [a] -> [a]
sumasParciales xs = foldr fefe [] (reverse xs)
  where
    fefe x [] = [x]
    fefe x xs = xs ++ [x + last xs]

sumaAlt :: (Num a) => [a] -> a
sumaAlt = foldr (-) 0

sumaAltInverso :: (Num a) => [a] -> a
sumaAltInverso = foldl (flip (-)) 0

--- EJERCICIO 4 ---
{-
concatMap aplica una función a cada elemento de una lista y concatena los resultados
concatMap :: (a -> [a]) -> [a] -> [b]

No se me ocurrió como implementarla con take y drop
-}
permutaciones :: (Eq a) => [a] -> [[a]]
permutaciones [] = [[]]
permutaciones xs = concatMap (\y -> map (y :) (permutaciones (remove y xs))) xs
  where
    remove _ [] = []
    remove x (y:ys)
      | x == y = ys
      | otherwise = y : remove x ys

partes :: [a] -> [[a]]
-- partes (x:xs) = (partes xs) ++ (map (x:) (partes xs))
partes = foldr (\x z -> z ++ (map (x :) z)) [[]]

prefijos :: [a] -> [[a]]
prefijos = foldr (\x acc -> [] : map (x:) acc) [[]]

--- EJERCICIO 5 ---
entrelazar :: [a] -> [a] -> [a]
entrelazar [] = id
entrelazar (x:xs) = \ys -> if null ys
  then entrelazar xs []
  else x : head ys : entrelazar xs (tail ys)

entrelazarFold :: [a] -> [a] -> [a]
entrelazarFold = foldr (\x fr ys ->
  if null ys then x: fr []
  else x : head ys : fr (tail ys)) id

--- EJERCICIO 6 ---
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr f z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

sacarUna :: (Eq a) => a -> [a] -> [a]
sacarUna elem = recr (\x xs z -> if x==elem then xs else x:z) []

{-
foldr no es adecuado para implementar sacarUna porque la funcion que utiliza no tiene forma de acceder a xs
foldr sería adecuado para implementar sacarTodas que saca todas la apariciones de un elemento
-}

-- inserta un elemento en una lista ordenada crecientemente
insertarOrdenado :: (Ord a) => a -> [a] -> [a]
insertarOrdenado elem = recr (\x xs z -> if elem <= x
  then elem:x:xs
  else x:z) [elem]

--- EJERCICIO 7 ---
genLista :: a -> (a -> a) -> Integer -> [a]
genLista x f 0 = []
genLista x f cant = x : genLista (f x) f (cant-1)

desdeHasta :: Integer -> Integer -> [Integer]
desdeHasta d h = genLista d (+1) (h-d+1)

--- EJERCICIO 8 ---
mapPares :: (a -> a -> b) -> [(a,a)] -> [b]
mapPares f xs = [f x y | (x,y) <- xs]

-- Funcion zip
armarPares :: [a] -> [b] -> [(a,b)]
armarPares (x:xs) (y:ys) = (x,y) : armarPares xs ys
armarPares _ _ = []

{-
-- https://stackoverflow.com/a/26285107
Ejemplo: (s = step; c = const []) 
armarParesFold [1,3] [2,4] = 
foldr s c [1,3] [2,4] = 
s 1 (s 3 (const [])) [2,4]    (def de foldr)
(1,2) : (s 3 (const []) [4])  (por definicion de step; r = s 3 (const [])
(1,2) : (3,4) : (const [] []) (de nuevo def. de step)
(1,2) : (3,4) : []
[(1,2), (3,4)]
-}
-- step es una funcion que toma un elemento de la primer lista, la recursion con los demas elementos de la primer lista y tambien la segunda lista. Aprovecha la evaluación parcial ya que al evaluar foldr s c lista1 va a devolver una funcion que toma otra lista y que evalua con lo explicado recien.
armarParesFoldr :: [a] -> [b] -> [(a,b)]
armarParesFoldr = foldr step (const [])
  where step x r [] = []
        step x r (y:ys) = (x,y) : r ys

-- funcion zipWith
mapDobleFold :: (a -> a -> b) -> [a] -> [a] -> [b]
mapDobleFold g = foldr step (const [])
  where step x r [] = []
        step x r (y:ys) = g x y : r ys

mapDoble :: (a -> a -> b) -> [a] -> [a] -> [b]
mapDoble f xs ys = mapPares f (armarPares xs ys)


--- EJERCICIO 9 ---
-- Req: las dos matrices tienen las mismas dimensiones
sumaMat :: [[Int]] -> [[Int]] -> [[Int]]
--sumaMat (x:xs) (y:ys) = (zipWith (+) x y) : sumaMat xs ys
sumaMat = zipWith (zipWith (+))

{-
trasponer [[1,2,3],
           [4,5,6]]  =  [[1,4],
                         [2,5],
                         [3,6]]
-}

-- TO-DO

--- EJERCICIO 10 ---
-- Genera listas en base a un predicado y una funcion
generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom stop next []

generateFrom :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs | stop xs = init xs
                          | otherwise = generateFrom stop next (xs ++ [next xs])

-- Ejemplo
fibonacci :: Int -> [Int]
fibonacci n = generateFrom (\xs -> length xs > n) (\xs -> last xs + last (init xs)) [0,1]

generateBase::([a] -> Bool) -> a -> (a -> a) -> [a]
generateBase stop base next = generateFrom stop (next.last) [base]

{-
f 0 = []
f 1 = [0!] = [1]
f 2 = [0!,1!] = [1,1]
f 3 = [0!,1!,2!] = [1,1,2]
-}
factoriales :: Int -> [Int]
factoriales n = generate (\xs -> length xs > n) (\xs ->
  if null xs then 1 else product [1..length xs])

{-
i 3 (+1) 10 = [10, (+1) 10, (+1) ((+1) 10)] = [10,11,12]
-}
iterateN :: Int -> (a->a) -> a -> [a]
iterateN n f b = generateBase (\xs -> length xs > n) b f

iterateN' :: Int -> (a->a) -> a -> [a]
iterateN' n f b = take n $ iterate f b

--generateFrom' :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
--generateFrom' = ???

--- Ejercicio 11 ---

-- caso base n=0. Está bien esto ??
{-
potencia :: Integer -> Integer -> Integer
potencia x 0 = 1
potencia x n = x * potencia x (n-1)
-}

foldNat :: (Integer -> a -> a) -> a -> Integer -> a
foldNat f z 0 = z
foldNat f z n = f n (foldNat f z (n-1))

potencia num = foldNat (\_ r -> num * r) 1

-- Ejercicio 12 --
data Polinomio a =
    X
  | Cte a
  | Suma (Polinomio a) (Polinomio a)
  | Prod (Polinomio a) (Polinomio a)
  deriving(Show)

-- esquema de recursion estructural
recPolinomio :: b -> (a -> b) -> (b -> b -> b) -> (b -> b -> b) -> b -> Polinomio a -> b
recPolinomio fbase fCte fSuma fProd z term = case term of
  X     -> z
  Cte n -> fCte n
  Suma t1 t2 -> fSuma (recp t1) (recp t2)
  Prod t1 t2 -> fProd (recp t1) (recp t2)
  where recp = recPolinomio fbase fCte fSuma fProd z

evaluarPol :: Integer -> Polinomio Integer -> Integer
evaluarPol n = recPolinomio n id (+) (*) 0

--- Ejercicio 13 ---
data AB a =
  Nil | Bin (AB a) a (AB a)

foldAB :: (a -> b -> b -> b) -> b -> AB a -> b
foldAB f z Nil = z
foldAB f z (Bin t1 n t2) = f n (foldAB f z t1) (foldAB f z t2)

recAB  :: (a -> AB a -> AB a -> b -> b -> b) -> b -> AB a -> b
recAB f z Nil = z
recAB f z (Bin t1 n t2) = f n t1 t2 (recAB f z t1) (recAB f z t1)

esNil :: AB a -> Bool
esNil Nil = True
esNil _ = False

altura :: AB a -> Integer
altura = foldAB (\n ri rd -> 1 + max ri rd) 0

cantNodos :: AB a -> Integer
cantNodos = foldAB (\n ri rd -> 1 + ri + rd) 0

-- mejorSegun (> 10) (Bin (Bin Nil 1 Nil) 10 (Bin Nil 15 Nil)) --> 15
-- mejorSegunAB :: (a -> a -> Bool) -> AB a -> a

---- Ejercicio 16 ----
-- arboles con una cantidad indeterminada para cada nodo
data RoseTree a = Rose a [RoseTree a]
  deriving Show

rose :: RoseTree Integer
rose = Rose 1 [Rose 2 [], Rose 3 [Rose 4 [], Rose 5 [], Rose 6 []]]

-- dado un rosetree devuelve una lista con las hojas ordenadas de izquierda a derecha segun su aparicion en el rosetree
hojas :: RoseTree a -> [a]
hojas (Rose x rs) = x : concat (map hojas rs)

-- distancias, devuelve la distancia desde la raiz a cada una de sus hojas
-- distancia rose = [0,1,1,2,2,2]
distanciasX :: Integer -> RoseTree a -> [Integer]
distanciasX n (Rose a xs) = n : concat (map (distanciasX (n+1)) xs) -- wtf funciona

distancias :: RoseTree a -> [Integer]
distancias = distanciasX 0

-- devuelve la cant de nodos de la rama del rosetree mas larga
--altura :: RoseTree a -> Integer
--altura (Rose a) = max map (distancias)

foldRT :: (a -> [b] -> b) -> RoseTree a -> b
foldRT f (Rose r rs) = f r (map (foldRT f) rs)

hojasFold :: RoseTree a -> [a]
hojasFold = foldRT (\r l -> r : concat l)

--distanciasFold :: (RoseTree a) -> [Integer]
--distanciasFold = foldRT (\r l -> 0 : concat ) ??

alturaFold :: RoseTree a -> Integer
alturaFold = foldRT (\r l -> 1 + caca l)
  where
    caca [] = 1   -- maximum [] se rompe. si el rt es una hoja su altura es 1
    caca xs = maximum xs

---- Ejercicio 17 ----
ff :: (a -> b -> c) -> b -> a -> c
ff f x y = f y x

gg :: (a -> b -> c) -> (a -> b) -> a -> c
gg f g x = f x (g x)