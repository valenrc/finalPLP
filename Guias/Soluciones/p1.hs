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
sumaAlt mult (x:xs) = (mult*x) + sumaAlt (mult*(-1)) xs



