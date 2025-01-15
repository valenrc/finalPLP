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

flip1 :: (a  -> b  -> c ) -> (b  -> a  -> c)
flip2 :: (a' -> b' -> c') -> b' -> a' -> c'

(a  -> b  -> c) ?= (a' -> b' -> c') -> (b' -> a' -> c')
a => (a' -> b' -> c')

b -> c ?= (b' -> a' -> c')
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

-- curryN = ? 

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

_map :: (a -> b) -> [a] -> [b]
_map f = foldr (\x z -> (f x):z) []

mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f = foldr1 (\x z -> if f x z then x else z)

-- llamar con acc=0
sumasParciales :: (Num a) => a -> [a] -> [a]
sumasParciales acc [] = []
sumasParciales acc (x:xs) = [acc+x] ++ (sumasParciales (acc+x) xs)

sumaAlt :: (Num a) => a -> [a] -> a
sumaAlt mult [] = 0
sumaAlt mult (x:xs) = (mult*x) + sumaAlt (-mult) xs

sumaAlt' :: (Num a) => [a] -> a
sumaAlt' = foldr (-) 0

sumaAltInverso :: (Num a) => [a] -> a
sumaAltInverso = foldl (flip (-)) 0

--- EJERCICIO 4 ---
{-
concatMap aplica una función a cada elemento de una lista y concatena los resultados
concatMap :: (a -> [a]) -> [a] -> [b]

take devuelve los primeros n elementos de una lista
take :: Int -> [a] -> [a]

drop elimina los primeros n elementos de una lista
drop :: Int -> [a] -> [a]

TO-DO
-}

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

armarPares :: [a] -> [b] -> [(a,b)]
armarPares [] _ = []
armarPares _ [] = []
armarPares (x:xs) (y:ys) = (x,y) : armarPares xs ys