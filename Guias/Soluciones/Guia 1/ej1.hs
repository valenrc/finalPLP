max2 :: (Ord x) => (x, x) -> x 
max2 (x, y)
  | x >= y = x
  | otherwise = y

normaVectorial :: (Floating x) => (x, x) -> x
normaVectorial (x, y) = sqrt (x^2 + y^2)

_subtract :: (Num x) => x -> x -> x
_subtract = flip (-)

predecesor :: (Num x) => x -> x
predecesor = _subtract 1

evaluarEnCero :: (Integer -> x) -> x
evaluarEnCero = \f -> f 0

dosVeces :: (x -> x) -> (x -> x)
dosVeces = \f -> f . f

-- map  :: (x -> y) -> [x] -> [y]
-- flip :: (a -> b -> c) -> b -> a -> c

-- como flip es el pimer argumento de map:
-- x = (a -> b -> c)
-- y = (b -> a -> c)
-- entonces [x] -> [y]:
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
