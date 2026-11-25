<!--no-pdf-->
# Why Each Prediction Reads the Way It Does

Write one entry per case, before you run anything. Name the rule behind each
predicted field. One to three sentences is enough. The grader checks the
structure of this file only. It does not judge how good the reasoning is, and
it sets no word minimum.

For every case you predicted wrongly, add a short correction after you run
it: what you predicted, what the language printed, and which rule you
misread. Corrections belong in the correction commits, not the prediction
commit.

Commit this file together with `predictions.tsv`, before any case runs:

```bash
git add predictions.tsv REASONING.md
```

The example below uses a query that is not one of the 16 cases, so it gives
no answer away. `parent(pat, X)` reads `parent(pat, jim)` because the `parent`
facts are tried top to bottom and only that one has `pat` as its first
argument:

```text
## parent(pat, X)

The goal scans the parent facts in source order. Only parent(pat, jim) has
pat first, so X binds to jim. No second fact matches, so the first ; finds
nothing and the search ends after one answer.
```

## P01

Prolog searches the parent facts from top to bottom. It finds parent(tom, liz) first, then parent(tom, bob). These are the first and second answers with no succeeding ones since tom only has 2 children in 2 counts.

## P02

When prolog gets a query such as parent(tom, bob), it checks for the fact in the knowledge base. It returned true because the fact was found in the second line of our knowledge base.

## P03

This asks if tom belongs to a parent. Given that no fact in the knowledge base has tom as its second argument, it fails and returns false and no count has been recorded.

## P04

The first goal  is to unify X to a term that matches f(Y, a), and the second goal is to bind Y to b. Because X’s binding contains that same Y, it becomes X = f(b, a)

## P05

These compares both compound terms by checking their functor and arguments. Since both terms have the same functor f and two arguments, it unifies the corresponding arguments, assigning a to X and b to Y resulting in one solution and one count.

## P06

The query of a = b returns a false because they are both atoms and can never unify. Returning a false means that it didn't find an answer resulting in a count of 0.

## P07

This checks Tom's children first, then checks the children of each of those children. It starts from the top so it checks Liz  which has no listed children, then proceeds to Bob who has two: Ann and Pat.Ann and Pat are Tom’s grandchildren and are the first and second answers in two counts.

## P08

The base clause runs first before the recursive clause, so Liz and Bob are first. Then Ann, Pat, Sue, and Jim are after. Sue comes first compared to Jim, because the recursive rule is called on Ann, before it goes to Pat.

## P09

`ancestor_r` checks the recursive rule before the base clause. Prolog explores descendants as deeply as possible before returning to the direct children. Its complete answer in order is sue, jim, pat, ann, liz, bob; sue and jim will be the first and second answers and the total count is 6.

## P10

The query for ancestor(X, Jim) looks for all ancestors of Jim starting with the base clause which finds bob. But before bob, prolog has to have found the path of pat->tom->-bob->jim, from top to bottom, which means that pat is actually the first and tom is second.

## P11

The first clause calls reach(X,Z) before checking any edge causing a left recursion. This  means Prolog repeatedly calls the same predicate without making progress toward a base case. Since it gets stuck in an infinite recursive loop, it cannot produce an answer so all fields are `unbounded`.

## P12

The base clause is not true, leading to the recursive which goes from a->b->c and finds the edge(c,d), which returns the first true. From there, if we press ;, it would go back to Z = a and it will do the same thing and return true, resulting in an infinite amount of trues.

## P13

The len predicate recursively removes one element from the list until it reaches the empty list with  length  zero. It then adds one for every removed element using `N is M + 1`, resulting in a total length of 3 in only one count.

## P14

Each time prolog uses the first clause, it stops and gives one split. With the second clause, it moves one element from the list into X. When the remaining list is [], the second clause can't match, and the search ends with false.

## P15

Since Prolog evaluates goals from left to right, the comparison `X > 2` requires `X` to already have a numerical value, but `X` in this case  is still unbound. This is because `elem` has not yet been executed to assign a value to X, this then causes Prolog to raise an instantiation error making all fields read error.

## P16

The first part generated the x=1, x=2, and x=3, but only x=3 passed the condition of x>2. This results in 3 being the only value of x.
