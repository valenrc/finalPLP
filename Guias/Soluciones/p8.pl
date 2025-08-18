% Guia 7 - Resolución Lógica
%=====EJERCICIO 22=====%
preorder(nil, []).
preorder(bin(I,R,D), [R|L]) :- append(LI,LD,L), preorder(I,LI), preorder(D,LD).
append([], YS, YS).
append([X|XS], YS, [X|L]) :- append(XS, YS, L).

% Guia 8 - Programación lógica
%=====EJERCICIO 1=====%

padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).
abuelo(X, Y) :- padre(X, Z), padre(Z, Y).
% X es abuelo de Y 
% X ->p Z ->p Y

% I.
% Cual es el resultado de la consulta abuelo(X, manuel)?
% X = juan

% II.
% definir los predicados hijo, hermano y descendiente.
hijo(X,Y) :- padre(Y,X).

hermano(X,Y) :- padre(Z,X), padre(Z,Y), X \= Y.

descendiente(X,Y) :- padre(Y,X).
descendiente(X,Y) :- padre(Z,X), descendiente(Z,Y).

% III
% arbol de consulta para descendiente(A,juan).
% descendiente(A, juan)
%   |
%    - padre(juan, A)
%       |
%       - A = carlos
%       - A = luis
%   |
%   - padre(Z, A), descendiente(Z, juan)
%       |
%       - (Z := carlos A := daniel)
%         descendiente(carlos, juan)
%           |
%           - padre(carlos, juan) OK - (A = daniel)
%       - (Z := carlos A := diego)
%       descendiente(carlos, juan)
%           |
%           - padre(carlos, juan) OK - (A = diego)
%       - (Z := luis A:= pablo)
%       descendiente(luis, juan)
%           |
%           - padre(juan, luis) OK - (A = pablo)
%       ... Y lo mismo con los demas hijo de luis (manuel y ramiro)

% IV.
% consulta para encontrar a los nietos de juan:
% abuelo(juan, X)
% X se instancia en todos los nietos de juan

% V.
% consulta para encontrar a todos los hermanos de pablo:
% hermano(pablo, X) o hermano(X, pablo)

% VI
ancestro(X, X).
ancestro(X, Y) :- ancestro(Z, Y), padre(X, Z).

% ancestro(juan, A)
%   1.ancestro(juan, juan) (1er regla)
%      A = juan
%
%   2.ancestro(Z, A), padre(juan, Z) (2da regla)
%      1.ancestro(A, A) (A = Z)
%         padre(juan, A)
%           A = carlos
%           A = luis
%      2.ancestro(Z1, A) padre(Z, Z1)
%         1.ancestro(A, A) (A = Z1)
%           padre(Z, A)
%             Z = juan
%             A = carlos  (unifica con el primer padre(Z,A) que encuentra)
%               padre(juan, juan) FAIL
%             Z = juan
%             A = luis
%               padre(juan, juan) FAIL
%             Z = carlos
%             A = daniel
%               padre(juan, carlos) OK
%                 ancestro(juan, daniel) (1er consulta
%                   A = daniel
%                   ...
% Las dos consultas primeras dieron A = carlos y A = luis
% que son los hijos de juan (que unificaron con padre(juan,A))
% luego, ancestro(Z1, A) va a unificar Z,A todos los pares tal que padre(Z,A) sea verdadero. Entonces A va a ser otro resultado de la consulta si padre(juan, Z) es verdadero.
% El loop infinito se genera al unificar con todos los padres(Z,A) a medida que se va avanzando en el arbol de consulta.
% Despues de la consulta ancestro(Z1, A) padre(Z, Z1)

% version arreglada
ancestroFixed(X, Y) :- padre(X, Y).
ancestroFixed(X, Y) :- padre(X, Z), ancestroFixed(Z, Y).

%=====EJERCICIO 2=====%

vecino(X, Y, [X | [Y|_]]).
vecino(X, Y, [_|Ls]) :- vecino(X, Y, Ls).

% I. arbol de busqueda para vecino(5, Y, [5,6,5,3])
/* 
vecino(5, Y, [5,6,5,3])
  1.vecino(5, Y, [5 | [6 | [5,3]]) (1er regla)
    Y = 6
  2.vecino(5, Y, [6| [6,5,3]])
    vecino(5, Y, [6,5,3])
      1.no unifica con la primer regla X
      2.vecino(5, Y, [6 | [5,3]])
        vecino(5, Y, [5,3])
          1.vecino(5, Y, [5 | 3 |  []])
            Y = 3
          2.vecino(5, Y, [5|[3]])
            vecino(5, Y, [3])
              1.no unifica
              2.vecino(5, Y, [3|[]])
                vecino(5, Y, [])
                  FALSE
*/

% II. Si se invierte el orden de las reglas se llega a los mismos resultados, con la diferencia de que no falla al terminar de encontrar todos los vecinos ya que "recorre" la lista de izquierda a derecha.
% primero falla con vecino(5, Y, []) y luego va unificando con los vecinos de 5.

%=====EJERCICIO 3=====%
natural(0).
natural(suc(X)) :- natural(X).

%
%menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).
%menorOIgual(X, X) :- natural(X).
%
%I.
% menorOIgual(0, N)
%   1. menorOIgual(X, suc(Y))
%      menorOIgual(0, Y)     {X = 0, suc(Y) = N}
%        1. menorOIgual(X, suc(Y))
%           menorOIgual(0, Y) {X = 0, suc(Y) = Y}
%             ... Y asi hasta que se exceda el limite de llamadas recursivas

% El programa se cuelga cuando la primer regla es el caso recursivo, esto es porque X unifica con suc(Y). Luego se llama a menorOIgual(0, Y) y se vuelve a unificar con la primer regla y asi sucesivamente.

%II.
% Las circunstancias en las que podría colgarse un programa en Prolog son:
% No se pero siempre debe aparecer primero el caso recursivo.

% Version corregida
menorOIgual(X,X) :- natural(X).
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).

%=====EJERCICIO 4=====%
% predicado juntar(?L1, ?L2, ?L3) que tiene exito si L3 es la concatenacion de L1 y L2.
juntar([], L2, L2).
juntar([X|Xs], Ys, [X|Zs]) :- juntar(Xs, Ys, Zs).

%=====EJERCICIO 5=====%
% Definir usando append o juntar:
 
%I. last(?L, ?U) donde U es el ultimo elemento de la lista L.
last(L, X) :- juntar(_,[X],L).

%II. reverse(+L, -L1) donde L1 contiene los mismos elementos que L, pero en orden inverso .reverse([1,2,3],[3,2,1]) -> true
reverse([],[]).
reverse(Xs,[Y|Ys]) :-
  last(Xs,Y),
  juntar(Z,[Y],Xs),
  reverse(Z,Ys).

%III. prefijo(?P, +L) donde P es prefijo de la lista L
%IV. sufijo(?S, +L) donde S es sufijo de la lista L

%V. sublista(?S, +L) donde S es una sublista de L
sublista(S,L) :- juntar(S,_,L).

%VI. pertenece(?X, +L)
pertenece(X, [X|_]).
pertenece(X, [Y|Ys]) :- X \= Y, pertenece(X,Ys).

%=====EJERCICIO 6=====%
% aplanar(+Xs, -Ys)
aplanar([],[]).
aplanar([X|Xs], [X|Ys]) :- number(X), aplanar(Xs, Ys).
aplanar([X|Xs], Ys) :-
  is_list(X),
  aplanar(X,Z1), aplanar(Xs,Z2),
  juntar(Z1,Z2,Ys).

%=====EJERCICIO 7=====%
% definir usando append (o juntar):

% I.palindromo(+L, ?L1)
palindromo(L1,L2) :- reverse(L1,R), juntar(L1,R,L2). 

% II. iesimo(?I, +L, -X)
iesimo(I,Xs,X) :- juntar(L,_,Xs), length(L,I), last(L,X).

%=====EJERCICIO 8=====%
% Definir usando member y/o append:

% I. interseccion(+L1, +L2, -L3) L3 es la interseccion sin repeticiones de L1 y L2
% falla cuando hay repetidos en L1 y estan en la interseccion
interseccion([],_,[]).

interseccion([X|XS], YS, [X|ZS]) :-
  member(X,YS),
  interseccion(XS,YS,ZS),
  not(member(X,ZS)).

interseccion([X|XS], YS, ZS) :-
  not(member(X,YS)),
  interseccion(XS,YS,ZS).

% partir(?N,?L,?L1,?L2) : L1 tiene los N primeros elementos de L y L2 el resto.
% Los parametros que pueden estar indefinidos son todos, pero si N y L no estan definidos entonces deben estarlo L1 o L2 (aunque de hecho esto tampoco parece necesario)
partir(N,L,L1,L2) :- append(L1,L2,L), length(L1,N).

% borrar(+L1, +X, -L2) borra todas las ocurrencias de X de L2
% no quiero usar member ni append :p
borrar([],_,[]).
borrar([Y|L1], X, [Y|L2]) :- X \= Y, borrar(L1,X,L2).
borrar([X|L1],X,L2) :- borrar(L1,X,L2).

% sacarDuplicados(+L1, -L2)
sacarDuplicados([],[]).

sacarDuplicados([X|L1], [X|L2]) :-
  not(member(X,L1)),
  sacarDuplicados(L1,L2).

sacarDuplicados([X|L1], L2) :-
  member(X,L1),
  borrar(L1,X,LX),
  sacarDuplicados(LX,L2).

% permutacion(+L1, ?L2) tiene exito cuando L2 es permutacion de L1
permutacion([],[]).
permutacion([X|L1], L2) :-
  permutacion(L1,W),
  append(W1,W2,W),
  append(W1,[X|W2],L2).

% reparto(+L, +N, -LLlistas) Llistas es una lista de N listas de cualquier longitud tales que al concatenarlas se obtiene la lista L. N >= 0
reparto(L,1,[L]).
reparto(L,N,[M1|LL]) :-
  N > 1,
  M is N-1,
  append(M1,M2,L),
  reparto(M2,M,LL).

% repartoSinVacias(+L, -LListas) LListas es una lista sin listas vacias. y el tamaño de las listas puede ser variable.
repartoSinVacias(L1,L) :-
  length(L1, N),
  between(1,N,M),
  reparto(L1, M, L),
  not((member(X, L), length(X,0))).

%=====EJERCICIO 9=====%
% elementos es una lista de N elementos de L preservando el orden en el que aparecen
elementosTomadosEnOrden(_,0,[]).
elementosTomadosEnOrden(L,N,[X|EL]) :-
  append(_, [X|XS], L),
  M is N-1,
  elementosTomadosEnOrden(XS,M,EL).

%=====EJERCICIO 10=====%
desde(X,X).
desde(X,Y) :- N is X+1, desde(N,Y).
/*
I. desde(+X,-Y)
  Si se instancia Y e Y < X, el programa se cuelga.

II. desde2(+X,?Y)
*/
% var(Y)    - true si Y es una variable libre
desde2(X,X).
desde2(X,Y) :- integer(Y),  Y >= X.
desde2(X,Y) :- var(Y), N is X+1, desde2(N,Y).

%=====EJERCICIO 11=====%
% intercalar(?L1,?L2,?L3) L3 tiene intercalados los elementos de L1 y L2
% reversibilidad: los tres pueden estar sin instanciar. Se puede instanciar todos o ninguno o solo uno.
intercalar(L1,L2,L3) :- intercalarAux(L1,L2,L3,0).

intercalarAux([],L2,L2,_).
intercalarAux(L1,[],L1,_).
intercalarAux([X|L1],L2,[X|L3],0)    :- intercalarAux(L1,L2,L3,1).
intercalarAux(L1, [X|L2], [X|L3],1)  :- intercalarAux(L1,L2,L3,0).

%=====EJERCICIO 12=====%
% arbol binario
% nil               -> arbol vacio
% bin(izq, v, der)  -> v es un valor valor, izq y der son subarboles

%I. vacio(+Arbol)
vacio(nil).

%II. raiz(+Arbol, ?X)
raiz(bin(_,X,_), X).

%III. altura(+Arbol, ?X)
altura(nil,0).
altura(bin(A1, _, A2), N) :-
  altura(A1,N1),
  altura(A2, N2),
  N is max(N1, N2) + 1.

%cantidadNodos(+A, ?N)
cantidadNodos(nil, 0).
cantidadNodos(bin(A1, _, A2), N) :-
  cantidadNodos(A1, N1),
  cantidadNodos(A2, N2),
  N is 1+N1+N2.

%======EJERCICIO 12======%
%I. inorder(+AB, ?Lista)
inorder(nil, []).
inorder(bin(A1,X,A2), L) :- inorder(A1,L1), inorder(A2, L2), append(L1, [X|L2], L).

%II. arbolConInorder(+Lista, -AB)
% genera un arbol a partir de el recorrido inorder dado por una lista
arbolConInorder(L, AB) :- !, inorder(AB,L).

%III. aBB(+T) tiene exito si T es un arbol binario de busqueda
aBB(nil).
aBB(bin(A1, X, A2)) :-
  (A1 == nil; (raiz(A1, I), X >= I)),
  (A2 == nil; (raiz(A2, D), X =< D)),
  aBB(A1),
  aBB(A2).

%IV. abbInsertar(+X,+T1,-T2) T2 es T1 pero insertando X
% reversibilidad de los paramtros:
% X no puede pasarse sin instanciar
% T1 se puede pasar sin instanciar solo si se instancia T2 (si no se instancia T1 y T2, da bien el primer resultado pero da error si se piden mas resultados)
% T2 se puede pasar instanciado, este instanciado T1 o no. 
abbInsertar(X, nil, bin(nil, X, nil)).
abbInsertar(X, bin(A1, Y, A2), bin(A1, Y, T)) :- 
  X >= Y,
  abbInsertar(X,A2,T).

abbInsertar(X, bin(A1, Y, A2), bin(T, Y, A2)) :- 
  X < Y,
  abbInsertar(X,A1,T).

%=====EJERCICIO 14=====%
% coprimos(-X,-Y)
coprimos(X,Y) :-
  gen_pares(X,Y),
  Gcd is gcd(X,Y),
  Gcd == 1.

% gen_pares(X,Y)
gen_pares(X,Y) :-
  desde2(1,N),
  paresQueSuman(N,X,Y).

%paresQueSuman(+N,-X,-Y)
% este predicado es muy lento :/
paresQueSuman(N,X,Y) :-
  between(1,N,X),
  between(1,N,Y),
  N is X+Y.

%=====EJERCICIO 15=====%
%I. cuadradoSemiLatino(+N, -XS)
% XS es una matriz cuadrada de N*N donde todas sus filas suman lo mismo
% Resuelvo el ejercicio de manera bottom-up
listasQueSuman(0,0,[]).
listasQueSuman(N,S,[X|XS]) :-
  % genera todas las listas de N elementos que suman S
  N > 0,
  between(0,S,X),
  M is N-1,
  Z is S-X,
  listasQueSuman(M,Z,XS).

% N: cant de elementos de la matriz
% M: cant de elementos de las listas que componen la matriz
matrizNxMDeListasQueSumanS(0,_,_,[]).
matrizNxMDeListasQueSumanS(N, M, S, [X|XS]) :-
  N > 0,
  listasQueSuman(M,S,X),
  N1 is N-1,
  matrizNxMDeListasQueSumanS(N1, M, S, XS).

cuadradoSemiLatino(N,XS) :-
  desde(0,S),
  matrizNxMDeListasQueSumanS(N,N,S,XS).

%II. cuadradoMagico(+N, -XS) es un cuadrado semilatino N*N pero sus columnas suman todas un mismo valor
cuadradoMagico(N,XS) :-
  cuadradoSemiLatino(N,XS),
  todasSusColumnasSumanLoMismo(XS).

todasSusColumnasSumanLoMismo([]).
todasSusColumnasSumanLoMismo()
%=======EJERCICIO 16======%
