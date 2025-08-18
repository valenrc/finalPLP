% 2do parcial 2024
% subsecuenciaCreciente(+L,-S)
% S es una subseq de elementos de L estrictamente creciente, respetando el orden de aparicion

% a)
subsecuenciaCreciente([],[]).
subsecuenciaCreciente(XS,S) :-
  subsecuencia(XS,S),
  creciente(S).

%subconjunto(+XS,-S)
subsecuencia([],[]).
subsecuencia([X|XS],[X|S]) :- subsecuencia(XS,S).
subsecuencia([X|XS],S) :- subsecuencia(XS,S).

%creciente(+XS)
creciente([]).
creciente([_]).
creciente([X,Y|XS]) :- X < Y, creciente([Y|XS]).

% b)
subsecuenciaCrecienteMasLarga(LS,S) :-
  subsecuenciaCreciente(LS,S),
  length(S,L),
  not((subsecuenciaCreciente(LS,S2), length(S2,L2), L2 > L)).

% c)
% fibonacci(-X) instancia en X los numeros de la seq de fibonacci

% fib(+X,-F) - F es el X-esimo numero de fibonacci
fib(0,0).
fib(1,1).
fib(X,F) :-
  X > 1,
  Y is X-1, Z is X-2,
  fib(Y,F1), fib(Z,F2),
  F is F1+F2.

fibonacci(X) :-
  desde(0,N),
  fib(N,X).

% desde(+X,-Y)
desde(X,X).
desde(X,Y) :-
  Z is X+1,
  desde(Z,Y).

%% el predicado fibonacci no es reversible, si X está instanciado y pertenece a la sec. de fibonacci, entonces devuelve true. Pero si X no pertenece, entonces el programa no termina.