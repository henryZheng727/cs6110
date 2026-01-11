= Learning Goals
- Convert logic formulas into proof-assistant code
- Work through natural deduction proofs

= Your Task
Prove the following statements in your favorite proof assistant:
- $P and Q -> P -> Q$
- $not (P and Q) -> R -> not R -> Q$
- $(P -> Q) or P and not Q$
- $((P -> Q) and (P -> R)) -> (P -> Q and R)$
- $P -> not not P$
- $not not (P and not P)$
- $P and not P$ assuming double negation $not not P -> P$ for all formulas $P$)
- $((P -> Q) -> P) -> P$ assuming double negation
  - #link("https://en.wikipedia.org/wiki/Peirce%27s_law")[Pierce's Law], aka #link("https://www.cl.cam.ac.uk/~tgg22/publications/popl90.pdf")[call/cc]
- $(forall x . A(x)) -> (exists y . A(y))$
- $(forall x . A(x) -> B(x)) -> ((forall x . A(x)) -> (forall x . B(b))$
- $((exists x . A(x)) or (exists x . B(x))) -> exists x . (A(x) or B(x))$

*Do not use* tactics like Lean's `simp` or `sorry` in your final proofs. (_But you're definitely encouraged to use them when debugging!_) Ultimately, the steps in your final proofs should resemble the steps in a handwritten natural deduction proof.

*Hints*
- In Lean, every occurrence of `P` `Q` and `x` can use type `Bool`, _except_ when you state double-negation, it should be over `P : Prop`
- Ben's solutions use the following Lean tactics (names in CAPS are for you to fill in):
  - `intro NAME`
  - `exact HYPOTHESIS.left` / `exact HYPOTHESIS.right`
  - `cases HYPOTHESIS with` ...
    - when `HYPOTHESIS` is a Bool, the cases are `| true => ...` and `| false => ...`
    - when `HYPOTHESIS` is an existential, the cases are `| intro NAME_1 NAME_2 => ...`
    - when `HYPOTHESIS` is a disjunction, the cases are `| inl NAME_1 => ...` and `| inr NAME_1 => ...`
  - `apply HYPOTHESIS`
  - `exists VALUE`
  - `have NAME : TYPE := by PROOF`
  - `assumption`
  - `contradiction`
  - `left`
  - `right`
  - `rfl`

= Getting Started
GitPod: https://github.com/utahplt/lean-logic-gitpod

Example Lean theorem (also included in the gitpod):
```
theorem example :
  forall P : Bool,
    P ∧ P → P
  := by
    intro P
    intro pandp
    exact pandp.left
```

 
= Extra Links
https://adam.math.hhu.de/#/g/trequetrum/lean4game-logic (great reference material for Lean tactics, even if the game doesn't load!)

https://incredible.pm/
