import Data.List (nub, union)

type Var = String
type Lab = String

data Expr =
  EVar Var |
  EObj [(Lab,Var,Expr)] |
  ESel Expr Lab |
  EUpd Expr Lab Var Expr

exprA = ESel (EVar "VarA") "LabA"
exprB = ESel (EVar "VarB") "LabB"
expr1 = EUpd (EVar "Var1") "Lab1" "Var2" (EObj [("Lab3","Var3",exprA),("Lab4","Var4",exprB)])

-- Definir fold
-- esquema de recursion estructural
-- En el caso de EObj tengo que reducir la lista [(Lab,Var,Expr)] a un valor b usando la funcion fObj. Se puede hacer con foldr 
foldExpr :: (Var -> b) -> (Lab, Var, [b] -> b) -> (Lab -> b -> b) -> (Lab -> Var -> b -> b -> b) -> Expr -> b
foldExpr fVar fObj fSel fUpd expr = case expr of
  EVar v                  -> fVar v
--EObj []                 -> ?
  ESel exp lab            -> fSel lab (rec exp)
  EUpd exp1 lab var exp2  -> fUpd lab var (rec exp1) (rec exp2)
  where rec = foldExpr fVar fObj fSel fUpd

---- 1er Parcial 2024-2C ----
data Buffer a = Empty | Write Int a (Buffer a) | Read Int (Buffer a)
  deriving Show

buf = Write 1 "a" $ Write 2 "b" $ Write 1 "c" Empty

-- foldBuffer y recBuffer
-- recursion estructural y primitiva para Buffer a
foldBuffer :: b ->  (Int -> a -> b -> b) -> (Int -> b -> b) -> Buffer a -> b
foldBuffer cEmpty fWrite fRead buffer = case buffer of
  Empty -> cEmpty
  Write number content b -> fWrite number content (recc b)
  Read number b -> fRead number (recc b)
  where recc = foldBuffer cEmpty fWrite fRead

recBuffer :: b -> (Int -> a -> Buffer a -> b -> b) -> (Int -> Buffer a -> b -> b) -> Buffer a -> b
recBuffer cEmpty fWrite fRead buffer = case buffer of
  Empty -> cEmpty
  Write number content b -> fWrite number content b (recc b)
  Read number b -> fRead number b (recc b)
  where recc = recBuffer cEmpty fWrite fRead

-- lista todas las posiciones ocupadas del buffer
posicionesOcupadas :: Buffer a -> [Int]
posicionesOcupadas = 
  foldBuffer 
  [] 
  (\n cont acc -> if elem n acc then acc else n:acc) 
  (\n acc -> filter (\e -> e /= n) acc)  -- la lectura es destructiva

contenido :: Int -> Buffer a -> Maybe a
contenido pos = foldBuffer Nothing (\n cont acc -> if n==pos then Just cont else acc) (\n acc -> if n==pos then Nothing else acc)

-- devuelve true si cada lectura se da en una posicion en la cual hay algo escrito en ella
puedeCompletarLecturas :: Buffer a -> Bool
puedeCompletarLecturas = recBuffer True (\_ _ _ acc -> acc) (\n b acc -> elem n (posicionesOcupadas b) && acc)

-- deshace las ultimas n operaciones de un buffer
-- aprovecho la evaluación parcial :)
deshacer :: Buffer a -> Int -> Buffer a
deshacer = recBuffer
  (const Empty)
  (\id cont b acc n -> if n==0 then Write id cont b else acc (n-1))
  (\id b acc n -> if n==0 then Read id b else acc (n-1))

{-
======1er parcial 1C2024
% modelo de logica proposicional
-}
data Prop = Var String | No Prop | Y Prop Prop | O Prop Prop | Imp Prop Prop

type Valuacion = String -> Bool

prop = Y (Var "P") (No (Imp (Var "P") (Var "R")))

foldProp :: (String -> b) -> (b -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Prop -> b
foldProp cVar fNo fY fO fImp prop = case prop of
  Var s     -> cVar s
  No p      -> fNo  (acc p)
  Y p1 p2   -> fY   (acc p1) (acc p2)
  O p1 p2   -> fO   (acc p1) (acc p2)
  Imp p1 p2 -> fImp (acc p1) (acc p2)
  where acc = foldProp cVar fNo fY fO fImp

recProp :: (String -> b) -> (Prop -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> Prop -> b
recProp cVar fNo fY fO fImp prop = case prop of
  Var s     -> cVar s
  No p      -> fNo  p     (acc p)
  Y p1 p2   -> fY   p1 p2 (acc p1) (acc p2)
  O p1 p2   -> fO   p1 p2 (acc p1) (acc p2)
  Imp p1 p2 -> fImp p1 p2 (acc p1) (acc p2) 
  where acc = recProp cVar fNo fY fO fImp

-- variables: dada una formula devuelve la lista con todas sus variables proposicionales en algun orden sin elementos repetidos
variables :: Prop -> [String]
variables = foldProp (\s -> [s]) nub union union union

-- indica si una formula es valida dada la valuacion pasada como parametro
evaluar :: Valuacion -> Prop -> Bool
evaluar v = foldProp (\s -> v s) not (&&) (||) (\ac1 ac2 -> (not ac1) || ac2)

