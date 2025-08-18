## Extensionalidad y lemas de generación

### Ejercicio 1

Definiciones:
```haskell
intecambiar (x, y) = (y, x)

espejar (Left x) = Right x
espejar (Right y) = Left y

asociarI (x, (y, z)) = ((x, y), z)
asociarD ((x, y), z) = (x, (y, z))

flip f x y = f y x

curry f x y = f (x, y)
uncurry f (x, y) = f x y
```

Demostrar usando lemas de generación (extensionalidad) cuando sea neceario:

#### I
\forall p::(a, b) . intercambiar (intecambiar p) = p

Aplico extensionalidad sobre pares: 
Si p :: (a, b) entonces \exists x::a, y::b tal que p = (x,y)

Entonces:

intercambiar (intercambiar (x,y))
= intercambiar (y, x)       {def. intercambiar}
= (x, y)                    {def. intercambiar}
∎

#### II
\forall p::(a, (b,c)) . asociarD (asociarI p) = p

Usando extensionalidad sobre pares
Si p::(a, (b,c)) entonces \exists x::a, y::b, z::c tales que p = (x, (y,z))

Entonces, basta con demostrar:
\forall x::a, y::b, z::c . asociarD (asociarI (x, (y,z))) = (x, (y,z))

Luego: 

asociarD (asociarI (x, (y,z)))
= asociarD ((x, y), z)          {def. asociarI}
= (x, (y, z))                   {def. asociarD}
∎

#### III
\forall p :: Either a b . espejar (espejar p) = p

Usando extensionalidad sobre 'sumas'
Si p :: Either a b, entonces:
- o bien \exists x :: a . p = Left x
- o bien \exists y :: b . p = Right y

Entonces basta con demostrar tanto:

\forall x :: a . espejar (espejar Left x) = Left x
como: 
\forall y :: b . espejar (espejar Right y) = Right y 

Luego:

espejar (espejar Left x)
= espejar (Right x)
= Left x

espejar (espejar Right x)
= espejar (Left x)
= Right x
∎

#### IV
\forall f::a->b->c. \forall x :: a. \forall y :: b. flip (flip f) x y = f x y

flip (flip f) x y
= (flip f) y x      {def. flip}
= flip f y x        {prop. evaluacion parcial}
= f x y             {def. flip}

#### V
\forall f::a->b->c. \forall x::a. \forall y::b. curry (uncurry f) x y = f x y

curry (uncurry f) x y
= uncurry f (x, y)         {def. curry}
= f x y                    {def. uncurry}

### Ejercicio 2
Demostrar usando extensionalidad funcional

#### I
flip . flip = id

Usando ext. funcional:
flip . flip = id <-> \forall f::a->b->c. flip . flip f = id f

flip . flip f
= flip (flip f)           {def. (.)}
Aplico ext. de nuevo:
\exists 
= flip (flip f x y)
= flip (f y x)
= f x y