# Teórica 1- - Esquemas de recursión y tipos de datos inductivos

```haskell
Sea g :: [a] -> b

g [] = <caso_base>
g (x:xs) = <caso_recursivo>
```
Entonces:
## Recursion Estructural
la definicion de g está dada por recursión estructural si: 

1. El caso base devuelve un valor fijo z.
2. El caso recursivo se escribe usando (>= 0 veces) **x** y **(g xs)**, pero sin usar el valor de xs ni otros llamados recursivos.

Toda recursion estructural es una instancia de **foldr**

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)
```

## Recursion Primitiva
la definicion de g está dada por recursión primitiva si:

1. El caso base devuelve un valor fijo z.
2. El caso recursivo se escribe usando (>= 0 veces) **x**, **(g xs)** y **xs** pero sin hacer otros llamados recursivos.

Toda recursion primitiva es una instancia de **recr**

```haskell
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr f z []     = z
recr f z (x:xs) = f x xs (recr f z xs)
```

>La recursión primitiva es más general que la estructural. Todas la definiciones dadas por recursion estructural tambien estan dadas por recursion primitiva.

## Recursion Iterativa
```haskell
Sea g :: [a] -> b
g ac []     = <caso_base>
g ac (x:xs) = <caso_recursivo>
```
la definición de g está dada por recursion iterativa si:
- El caso base devuelve un valor fijo z.
- El caso recursivo invoca inmediatamente a (g ac' xs), donde ac' es el acumulador actualizado para la función en función de su valor anterior y el valor de x. 

Toda recursión iterativa es una instancia de **foldl**.
```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f ac []     = ac
foldl f ac (x:xs) = foldl f (f ac x) xs
```

## Similitudes
foldr y foldl tienen comportamientos diferentes:

```haskell	
foldr f z [1,2,3] = f 1 (f 2 (f 3 z))

foldl f z [1,2,3] = f (f (f z 1) 2) 3
```

>Si f es una operación **asociativa y conmutativa**, foldr y foldl definen la misma funcion. 

```haskell
sum = foldl (+) 0 = foldr (+) 0
or  = foldl (||) False = foldr (||) False
```

## Tipos de datos algebraicos
```haskell
data T =  ConstBase1 <parametros>
	| ConstBase2 <parametros>
	...
	| ConstBaseN <parametros>
						
	| ConstRecursivo1 <parametros>
	| ConstRecursivo2 <parametros>
	...
	| ConstRecursivoN <parametros>
				
```
### Definicion inductiva
- Los constructores base no reciben parámetros de tipo T
- Los constructores recursivos reciben al menos un parámetro de tipo T.
- Los valores del tipo algebráico T son los que se pueden construir aplicando constructores base y recursivos un número **finito** de veces.

### Recursión estructural

Dada una función ***g : T → Y*** definida por ecuaciones:

```haskell
g(Cbase1 <parametros>)       = <caso base1>
g(Cbase2 <parametros>)       = <caso base2>
...
g(CbaseN <parametros>)       = <caso baseN>

g(Crecursivo1 <parametros>)  = <caso recursivo1>
g(Crecursivo2 <parametros>)  = <caso recursivo2>
...
g(CrecursivoN <parametros>)  = <caso recursivoN>
```

***g*** está dada por recursión estructural si cumple:

1. Cada **caso base** devuelve un valor fijo
2. Cada **caso recursivo** se escribe combinando:
    1. Los parámetros del constructor que ***NO*** son de tipo T (sin usar los parámetros del constructor que son del tipo T).
    2. El llamado recursivo sobre ***cada*** parámetro de tipo T (sin hacer otros llamados recursivos).