%%% EJERCICIO 4 %%%
juntar(Xs, [], Xs).
juntar([], Ys, Ys).
juntar([X|Xs], Ys, [X|Zs]) :- juntar(Xs, Ys, Zs).

%%% EJERCICIO 5 %%%
% last(?L, ?U)
last(Xs, Y) :- append(_,[Y],Xs).

% reverse(+L, ?R)
reverse([],[]).
reverse(L, [R|Rs]) :- append(Ls,[R],L), reverse(Ls, Rs).

% prefijo(?P, +L)
prefijo(P, L) :- append(P,_,L).

% sufijo(?S, +L)
sufijo(S, L) :- append(_,S,L).

% sublista(?S, +L)
sublista(S, L) :- prefijo(P,L), sufijo(SF,L), append(P,S,L1), append(L1, SF, L).

% pertenece(?X, +L)
pertenece(X, L) :- append(A,_,L), last(A,X).

%%% EJERCICIO 6 %%%
% aplanar(+Xs, Ys)
aplanar([],[]).
aplanar([X|Xs], [X|Ys]) :- 
  number(X),
  aplanar(Xs, Ys).
aplanar([X|Xs], Ys) :-
  is_list(X),
  aplanar(X, Ax),
  aplanar(Xs, AXs),
  append(Ax,AXs,Ys).

%%%% EJERCICIO 8 %%%
% parteQueSuma(+L, +S, -P) P es una lista de elementos de L que suma S
parteQueSuma([X|_], X, [X]).
parteQueSuma([X|Xs], S, [X|Ys]) :- SS is S-X, parteQueSuma(Xs,SS,Ys).
parteQueSuma([_|Xs], S, Ys)     :- parteQueSuma(Xs, S, Ys). 

%%% EJERCICIO 9 %%%
desde(X,X).
desde(X,Y) :- nonvar(Y), Y >= X.
desde(X,Y) :- var(Y), N is X+1, desde(N, Y).

%%% EJERCICIO 10 %%%
% intercalar(L1, L2, L3)
intercalar(L1, [], L1).
intercalar([], L2, L2).
intercalar([X|Xs], [Y|Ys], [X,Y|L3]) :- intercalar(Xs, Ys, L3).

%%% Generate & Test %%%
%%% EJERCICIO 13 %%%

%%% EJERCICIO 15 %%%
% tri(A,B,C) triangulo con lados A, B, C

% cada lado debe ser menor que la suma de los otros dos
% esTriangulo()
esTriangulo(tri(A, B, C)) :-
  A > 0, B > 0, C > 0,
  ladoValido(A, B, C),
  ladoValido(C, B, A),
  ladoValido(B, A, C).

ladoValido(A, B, C) :- 
  A < B+C,
  A > B-C.


