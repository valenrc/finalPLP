% Tests for aBB predicate

% Load the file containing the aBB predicate
:- [p8].

% Define some test trees
tree1(nil).
tree2(bin(nil, 10, nil)).
tree3(bin(bin(nil, 5, nil), 10, bin(nil, 15, nil))).
tree4(bin(bin(nil, 5, nil), 10, bin(nil, 8, nil))). % Not a BST

% Test cases
:- begin_tests(aBB).

test(empty_tree) :-
  tree1(Tree),
  aBB(Tree).

test(single_node_tree) :-
  tree2(Tree),
  aBB(Tree).

test(valid_bst) :-
  tree3(Tree),
  aBB(Tree).

test(invalid_bst, [fail]) :-
  tree4(Tree),
  aBB(Tree).

:- end_tests(aBB).

% Run the tests
:- run_tests.
% Tests for aBB and abbInsertar predicates

% Load the file containing the aBB and abbInsertar predicates
:- [p8].

% Define some test trees
tree1(nil).
tree2(bin(nil, 10, nil)).
tree3(bin(bin(nil, 5, nil), 10, bin(nil, 15, nil))).
tree4(bin(bin(nil, 5, nil), 10, bin(nil, 8, nil))). % Not a BST

% Test cases for aBB
:- begin_tests(aBB).

test(empty_tree) :-
  tree1(Tree),
  aBB(Tree).

test(single_node_tree) :-
  tree2(Tree),
  aBB(Tree).

test(valid_bst) :-
  tree3(Tree),
  aBB(Tree).

test(invalid_bst, [fail]) :-
  tree4(Tree),
  aBB(Tree).

:- end_tests(aBB).

% Test cases for abbInsertar
:- begin_tests(abbInsertar).

test(insert_into_empty_tree) :-
  abbInsertar(10, nil, Tree),
  Tree = bin(nil, 10, nil).

test(insert_into_single_node_tree) :-
  tree2(Tree),
  abbInsertar(5, Tree, NewTree),
  NewTree = bin(bin(nil, 5, nil), 10, nil).

test(insert_into_bst) :-
  tree3(Tree),
  abbInsertar(12, Tree, NewTree),
  NewTree = bin(bin(nil, 5, nil), 10, bin(bin(nil, 12, nil), 15, nil)).

:- end_tests(abbInsertar).

% Run the tests
:- run_tests.
