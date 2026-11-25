%%%% rules.pl -- Part 2. Write the seven predicates below.
%%%%
%%%% The grader loads the facts and given rules in cases/kb.pl before this
%%%% file, so parent/2, edge/2, elem/2, join/3, and len/2 are yours to call.
%%%% The grader scores R1, R2, and R3 separately. Finish them in order. You
%%%% keep every group you get right.
%%%%
%%%% Each stub below throws, so a check you did not reach fails with a
%%%% message that identifies the predicate. Replace the whole stub, head and
%%%% body, with your own clauses. A stub left above your clauses runs first
%%%% and throws before Prolog tries yours.

%%% R1 -- the family.

% sibling(X, Y): X and Y share a parent and are not the same person.
%
% Order matters. X \= Y succeeds only when X and Y are already bound to
% different things, so put it after the goal that binds them.
sibling(X, Y) :-
    parent(P, X),   % bind P to a parent of X
    parent(P, Y),   % find Y sharing the same parent P
    X \= Y.         % exclude self-sibling matches

% cousin(X, Y): a parent of X and a parent of Y are siblings.
cousin(X, Y) :-
    parent(P1, X),      % bind P1 to a parent of X
    parent(P2, Y),      % bind P2 to a parent of Y
    sibling(P1, P2),    % require P1 and P2 to be siblings
    X \= Y.             % prevent X from matching Y


% descendant(D, A): A is an ancestor of D.
%
% Two clauses, the mirror image of ancestor/2 in cases/kb.pl. The base
% clause reads one parent fact. The recursive clause reads one parent fact
% and then asks a smaller question.
descendant(D, A) :-
    % Base case: A is directly a parent of D
    parent(A, D).

    % Recursive step: walk up through intermediate parent P to ancestor A
    descendant(D, A) :-
        parent(P, D),
        descendant(P, A).

%%% R2 -- lists.

% count_of(X, List, N): X occurs N times in List. N is 0 for the empty
% list, which is your base case.

% Base case: an empty list contains 0 occurrences of X
count_of(_, [], 0).

% Recursive case: count occurrences of X in Tail, then increment if Head matches X
count_of(X, [Head|Tail], N) :-
    count_of(X, Tail, N1),
    ( X = Head ->
        N is N1 + 1
    ;
        N is N1
    ).
    

% rev(List, Reversed): Reversed holds the elements of List in the other
% order. Reverse the tail. Then use join/3 to put the head at the end.
rev([], []).
rev([H|T], R) :-
    rev(T, RT),
    join(RT, [H], R).

% last_of(List, X): X is the last element of List. The empty list has no
% last element, so last_of([], X) must fail.
last_of([X], X).
last_of([_|T], X) :-
    last_of(T, X).

%%% R3 -- the graph.

% route(From, To, Path): Path is the list of nodes from From to To, in
% order, following edge/2 and never visiting a node twice. A route from a
% node to itself is [From].
%
% reach_r/2 in cases/kb.pl walks the same graph and never ends, because
% the cycle a -> b -> c -> a always offers one more edge. Carry the nodes
% you visited. Refuse to step onto one again. \+ Goal is true when Goal
% cannot be proved. That is how you say "not yet visited."
route(From, To, Path) :- travel(From, To, [From], Path).

travel(To, To, Visited, Path) :- rev(Visited, Path).
travel(From, To, Visited, Path) :-
    edge(From, Next),
    \+ elem(Next, Visited),
    travel(Next, To, [Next|Visited], Path).