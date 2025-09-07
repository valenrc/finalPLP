-- Currificacion y tipos
--- EJERCICIO 1.1 ---
max2 :: (Ord a) => (a, a) -> a
max2 (x, y)
  | x >= y = x
  | otherwise = y

normaVectorial :: (Floating a) => (a, a) -> a
normaVectorial (x, y) = sqrt (x^2 + y^2)

_substract :: (Num a) => a -> a -> a
_substract = flip (-)

predecesor :: (Num a) => a -> a
predecesor = _substract 1

{-
(Float -> Float) es el tipo de la funcion f
(Float -> Float) -> Float significa que evaluarEnCero recibe una funcion (f) y devuelve f 0 (que tambien es Float)
Si no suponemos que todos los numeros son de tipo float entonces el tipo de la funcion sería
(a -> b) -> b. con a = Integer
-}
evaluarEnCero :: (Integer -> a) -> a
evaluarEnCero = \f -> f 0

dosVeces :: (a -> a) -> (a -> a)
dosVeces = \f -> f . f

{-
map  :: (x -> y) -> [x] -> [y]
flip :: (a -> b -> c) -> b -> a -> c

como flip es el pimer argumento de map:
x = (a -> b -> c)
y = (b -> a -> c)
entonces [x] -> [y]:
-}
flipAll :: [x -> y -> z] -> [y -> x -> z]
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
flipRaro :: b -> (a -> b -> c) -> a -> c
flipRaro = flip flip

--- EJERCICIO 1.2 ---
--Las funciones que no están currificadas son max2 y normaVectorial

max2currificada :: (Ord a) => a -> a -> a
max2currificada x y
  | x>=y = x
  | otherwise = y

normaVectorialcurrificada :: (Floating a) => a -> a -> a
normaVectorialcurrificada x y = sqrt (x^2 + y^2)

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

--- EJERCICIO 3.1 ---
{-
---ESQUEMAS DE RECURSION
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)

foldl :: (a -> b -> b) -> b -> [a] -> b
foldl f ac [] = ac
foldl f ac (x:xs) = foldl f (f ac x) xs

recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr f z []     = z
recr f z (x:xs) = f x xs (recr f z xs)

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

_elem :: (Eq a) => a -> [a] -> Bool
_elem e = foldr (\x ac -> e == x || ac ) False

_concat :: [a] -> [a] -> [a]
_concat = flip (foldr (:))

_filter :: (a -> Bool) -> [a] -> [a]
_filter f = foldr (\x ac -> if f x then x:ac else ac) []

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

--- EJERCICIO 3.2 ---
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun f = foldr1 (\x ac -> if f x ac then x else ac)

--- EJERCICIO 3.3 ---
sumasParciales :: (Num a) => [a] -> [a]
sumasParciales xs = foldr aux [] (reverse xs)
  where
    aux x [] = [x]
    aux x xs = xs ++ [x + last xs]

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
--partes [] = [[]]
--partes (x:xs) = (partes xs) ++ (map (x:) (partes xs))
partes = foldr (\x ac -> ac ++ (map (x:) ac)) [[]]

prefijos :: [a] -> [[a]]
prefijos = foldr (\x ac -> [] : (map (x:) ac)) [[]]

-- Defino la recursion primitiva para sublistas
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr f z []     = z
recr f z (x:xs) = f x xs (recr f z xs)

sublistas :: [a] -> [[a]]
--sublistas [] = [[]]
--sublistas (x:xs) = tail (prefijos (x:xs)) ++ sublistas xs
sublistas = recr (\x xs ac -> tail (prefijos (x:xs)) ++ ac) [[]]

--- EJERCICIO 5 ---
-- elementosEnPosicionesPares no usa recursión estructural pues usa el parámetro recursivo xs dentro de su definición. 
-- entrelazar usa recursión estructural.
entrelazar :: [a] -> [a] -> [a]
entrelazar [] ys = []
entrelazar (x:xs) ys = if null ys
  then entrelazar xs []
  else x : head ys : entrelazar xs (tail ys)

{-
Este es un caso en donde foldr devuelve una función

Ejecución simbólica:
lambda :: a -> ([a] -> [a]) -> [a] -> [a]
lambda: (\x fr ys -> if null ys then x: fr [] else x : head ys : fr (tail ys))

entrelazarFold [1,2] [6,7]
= foldr lambda id [1,2] [6,7]
= lambda 1 (foldr lambda id [2]) [6,7]
= 1 : head [6,7] : ((foldr lambda id [2]) (tail [6,7]))
= 1 : 6 : (foldr lambda id [2] [7])
= [1,6] :  ...
= [1,6,2,7]
-}

-- fr es el acumulador recursivo de foldr, en este caso es una función que toma una lista y devuelve otra lista 
entrelazarFold :: [a] -> [a] -> [a]
entrelazarFold = foldr (\x fr ys ->
  if null ys then x : fr []
  else x : head ys : fr (tail ys)) id

--- EJERCICIO 6 ---
sacarUna :: (Eq a) => a -> [a] -> [a]
sacarUna elem = recr (\x xs r -> if x == elem then xs else x:r) []

{-
foldr no es adecuado para implementar sacarUna porque la funcion que utiliza no tiene forma de acceder a xs
foldr sería adecuado para implementar sacarTodas que saca todas la apariciones de un elemento
-}

insertarOrdenado :: (Ord a) => a -> [a] -> [a]
insertarOrdenado elem = recr (\x xs r -> if elem < x then elem:x:xs else x:r) [elem]

--- EJERCICIO 7 ---
mapPares :: (a -> b -> c) -> [(a,b)] -> [c]
mapPares f = map (uncurry f)

{-
-- https://stackoverflow.com/a/26285107s
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
armarPares :: [a] -> [b] -> [(a,b)]
armarPares = foldr step (const [])
  where step x r [] = []
        step x r (y:ys) = (x,y) : r ys

mapDoble :: (a -> b -> c) -> [a] -> [b] -> [c]
-- mapDoble f xs ys = mapPares f (armarPares xs ys)
mapDoble f = foldr (\x fr ys -> (f x (head ys)) : fr (tail ys)) (const [])

--- EJERCICIO 8 ---
sumaMat :: [[Int]] -> [[Int]] -> [[Int]]
sumaMat = mapDoble (mapDoble (+))

transponer :: [[Int]] -> [[Int]]
transponer [] = []
transponer ([]:_) = []
transponer xs = (map head xs) : transponer (map tail xs)

--- EJERCICIO 9 ---
foldNat :: (Integer -> a -> a) -> a -> Integer -> a
foldNat f z 1 = z
foldNat f z n = f n (foldNat f z (n-1))

potencia :: Integer -> Integer -> Integer
potencia n = foldNat (\_ ac -> n * ac) n

--- EJERCICIO 10 ---
genLista :: a -> (a -> a) -> Integer -> [a]
genLista inicial inc = foldNat (\_ ac -> ac ++ [inc (last ac)]) [inicial]

-- debería ser descurrificada?
desdeHasta :: Integer -> Integer -> [Integer]
desdeHasta n m = genLista n (+1) (m-n+1)

--- EJERCICIO 11 ---
data Polinomio a =
    X
  | Cte a
  | Suma (Polinomio a) (Polinomio a)
  | Prod (Polinomio a) (Polinomio a)
  deriving(Show)

foldPolinomio :: b -> (a -> b) -> (b -> b -> b) -> (b -> b -> b) -> Polinomio a -> b
foldPolinomio zX fCte fSuma fProd pol = case pol of
  X           -> zX
  Cte x       -> fCte x
  Suma pi pd  -> fSuma (recc pi) (recc pd)
  Prod pi pd  -> fProd (recc pi) (recc pd)

  where recc = foldPolinomio zX fCte fSuma fProd

evaluar :: (Num a) => a -> Polinomio a -> a
evaluar n = foldPolinomio n id (+) (*)

--- EJERCICIO 12 --
data AB a = Nil | Bin (AB a) a (AB a)
  deriving (Show)

foldAB :: b -> (a -> b -> b -> b) -> AB a -> b
foldAB zNil fBin Nil = zNil
foldAB zNil fBin (Bin tl x tr) = fBin x (recc tl) (recc tr)
  where recc = foldAB zNil fBin

recrAB :: b -> (a -> AB a -> AB a -> b -> b -> b) -> AB a -> b
recrAB zNil fBin Nil = zNil
recrAB zNil fBin (Bin tl x tr) = fBin x tl tr (recc tl) (recc tr)
  where recc = recrAB zNil fBin

-- se puede hacer con case
esNil :: AB a -> Bool
esNil = foldAB True (const.const.const False)

altura :: AB a -> Integer
altura = foldAB 0 (\_ ri rd -> 1 + max ri rd)

cantNodos :: AB a -> Integer
cantNodos = foldAB 0 (\_ ri rd -> 1 + ri + rd)

-- TO-DO definir usando esquemas de recursion
-- se puede usar recrAB pero no se que poner en el caso base :/
mejorSegunAB :: (a -> a -> Bool) -> AB a -> a
mejorSegunAB _ (Bin Nil x Nil) = x
mejorSegunAB f (Bin Nil x d)   = if f x (mejorSegunAB f d) then x else mejorSegunAB f d
mejorSegunAB f (Bin i x Nil)   = if f x (mejorSegunAB f i) then x else mejorSegunAB f i
mejorSegunAB f (Bin i x d)
  | f x (mejorSegunAB f d) = if f x (mejorSegunAB f i) then x else mejorSegunAB f i
  | f (mejorSegunAB f d) (mejorSegunAB f i) = mejorSegunAB f d
  | otherwise = mejorSegunAB f i

esABB :: (Ord a) => AB a -> Bool
esABB = recrAB True (\x ti td ri rd -> (comp (x>) ti && comp (x<) td) && ri && rd)
  where comp f = foldAB True (\x ri rd -> (f x) && ri && rd)

-- para el arbol (Bin arbolIzq x arbolDer) las ramas van a ser las ramas de arbolIzq concatenadas con las ramas del arbolDer y todas esas ramas van a tener a la raiz como primer nodo
ramas :: AB a -> [[a]]
ramas = foldAB [] (\x ri rd ->
  if null ri && null rd
    then [[x]]
    else map (x:) ri ++ map (x:) rd)

cantHojas :: AB a -> Integer
cantHojas = recrAB 0 (\_ ti td ri rd -> if esNil ti && esNil td then 1 else ri + rd)

espejo :: AB a -> AB a
espejo = foldAB Nil (\x ri rd -> Bin rd x ri)

--- EJERCICIO 13 ---
{-
me : mismaEstructura
A1 : Bin ai x ad
A2 : Bin bi y bd
me A1 A2
foldAB esNil sigma (Bin ai x ad) A2
sigma x (foldAB esNil sigma ai) (foldAB esNil sigma ad) A2
-}

mismaEstructura :: AB a -> AB a -> Bool
mismaEstructura = foldAB esNil comp
  where
    comp _ ri rd Nil         = False
    comp _ ri rd (Bin i _ d) = (ri i) && (rd d)

--- EJERCICIO 14 ---
data AIH a = Hoja a | BinH (AIH a) (AIH a)
  deriving Show

foldAIH :: (a -> b) -> (b -> b -> b) -> AIH a -> b
foldAIH fHoja fBinH aih = case aih of
  Hoja x     -> fHoja x
  BinH ai ad -> fBinH (recc ai) (recc ad)
  where recc = foldAIH fHoja fBinH

alturaAIH :: AIH a -> Integer
alturaAIH = foldAIH (const 1) (\ri rd -> 1 + max ri rd)

tamañoAIH :: AIH a -> Integer
tamañoAIH = foldAIH (const 1) (+)

--- EJERCICIO 15 ---
-- No se si esta definición es buena porque habría dos formas de representar una hoja: HojaRT x y BinRT x []
-- Podría asumir que las instancias de RoseTree se crean sin listas vacías
data RoseTree a =
  HojaRT a |
  BinRT a [RoseTree a]
    deriving (Show)

foldRT :: (a -> b) -> (a -> [b] -> b) -> RoseTree a -> b 
foldRT fHoja fBin rt = case rt of
  HojaRT x    -> fHoja x
  BinRT  x rs -> fBin x (map recc rs)
  where recc = foldRT fHoja fBin

hojasRT :: RoseTree a -> [a]
hojasRT = foldRT (:[]) (const concat)

distanciasRT :: RoseTree a -> [Integer]
-- distanciasRT = foldRT (const [0]) (\_ rs -> map (+1) (concat rs))
distanciasRT = foldRT (const [0]) (const (map (+1).concat))

alturaRT :: RoseTree a -> Integer
-- alturaRT = foldRT (const 1) (\_ rs -> 1 + maximum rs)
alturaRT = foldRT (const 1) (const ((+1).maximum))

--- EJERCICIO 16 ---
-- Nada de este ejercicio está testeado, puede que esté todo mal :/
data HashSet a = Hash (a -> Integer) (Integer -> [a])

-- devuelve un conjunto vacío con la función de hash indicada
-- como ningun elemento pertenece al conjunto, la tabla de hash tiene que devolver listas vacia para todos los enteros
vacio :: (a -> Integer) -> HashSet a
vacio f = Hash f (const [])

pertenece :: Eq a => a -> HashSet a -> Bool
pertenece x (Hash hf ht) = elem x $ ht (hf x)

agregar :: Eq a => a -> HashSet a -> HashSet a
agregar new_e (Hash hf ht)
  | pertenece new_e (Hash hf ht) = Hash hf ht -- new_e ya pertenece al conjunto
  | otherwise = Hash hf (\n -> if n == hf new_e then new_e : ht n else ht n)

-- esto tiene un error y es que si f1 y f2 son distintas, la preimagen en la tabla de hash del resultado no va a ser necesariemente la misma para el segundo conjunto. Pensar como arreglar esto. 
interseccion :: Eq a => HashSet a -> HashSet a -> HashSet a
interseccion (Hash f1 t1) (Hash f2 t2) =
  Hash f1 (\n -> concatenarSinRepetidos (t1 n) (t2 n))

-- asume que no hay repetdos en ninguna de las dos listas. es suficiente para el ejercicio ya que `agregar` nunca agrega repetidos.  
concatenarSinRepetidos :: Eq a => [a] -> [a] -> [a]
concatenarSinRepetidos = foldr (\x r ys -> if elem x ys then x : r ys else r ys) (const [])

foldr1_ :: (a -> a -> a) -> [a] -> a
foldr1_ f = recr (\x xs r -> if null xs then x else f x r) (error "lista vacia!!")

--- EJERCICIO 17 ---