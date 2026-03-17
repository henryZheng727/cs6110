-- DFA.lean
-- Deterministic finite automaton: structure, run semantics, and helper lemmas.
--
-- We define a DFA as a triple (step, start, accept) and provide:
--   • `run`      — the extended transition function δ̂
--   • `accepts`  — acceptance predicate (run lands in accept set)
--   • `language` — the set of all accepted words
--   • `run_nil`, `run_cons`, `run_append` — key equational lemmas
--
-- The pumping lemma proof depends heavily on `run_append`, which lets us
-- decompose a run over a concatenation w = x ++ y ++ z into three pieces.

import PumpingLemma.Language

import Mathlib.Data.Finset.Defs
import Mathlib.Data.Set.Basic

/-- A **deterministic finite automaton** parameterized by:
    - `α` — the input alphabet (type of symbols the DFA reads)
    - `σ` — the state space (type of internal states)

    We use `Set σ` (not `Finset σ`) for the accept states to avoid requiring
    `DecidableEq σ` everywhere. Finiteness of the state space is enforced
    separately via `[Fintype σ]` when needed (see `IsRegular`). -/
structure DFA (α : Type) (σ : Type) where
  /-- Transition function δ(q, a): given the current state and an input symbol,
      produce the next state. This is the single-step transition. -/
  step : σ → α → σ
  /-- The initial state q₀ where every computation begins. -/
  start : σ
  /-- The set of accepting (final) states F. A word is accepted iff the DFA
      halts in one of these states after processing the entire input. -/
  accept : Set σ

namespace DFA

variable {α : Type} {σ : Type}

/-- The **extended transition function** δ̂(q, w): starting from state `q`,
    process every symbol in the word `w` left-to-right, returning the state
    reached after the last symbol.

    Defined by structural recursion on the input word:
    - `run q []      = q`              — empty word: state unchanged
    - `run q (a :: w) = run (step q a) w` — step on head, recurse on tail

    This is equivalent to `List.foldl M.step q w`, but the explicit recursion
    makes the `run_nil` / `run_cons` simp lemmas definitional equalities. -/
def run (M : DFA α σ) (q : σ) : List α → σ
  | []     => q
  | a :: w => M.run (M.step q a) w

/-- A DFA **accepts** a word `w` when running from the start state on `w`
    reaches a state in the accept set. -/
def accepts (M : DFA α σ) (w : List α) : Prop :=
  M.run M.start w ∈ M.accept

/-- The **language** recognized by a DFA: the set of all words it accepts. -/
def language (M : DFA α σ) : Set (List α) :=
  { w | M.accepts w }

------------------------------------------------------------------------
-- Run lemmas
--
-- These three @[simp] lemmas are the backbone of every proof that reasons
-- about DFA execution.  The pumping lemma proof uses `run_append` to split
-- M.run q₀ (x ++ yⁿ ++ z)  =  M.run (M.run (M.run q₀ x) yⁿ) z
-- and then argue that each piece behaves predictably.
------------------------------------------------------------------------

/-- Running on the empty word is a no-op: the state is unchanged.
    This holds definitionally (by the first clause of `run`). -/
@[simp]
theorem run_nil (M : DFA α σ) (q : σ) :
    M.run q [] = q := rfl

/-- Running on `a :: w` first steps on `a`, then processes the remaining
    word `w`.  Also definitional (by the second clause of `run`). -/
@[simp]
theorem run_cons (M : DFA α σ) (q : σ) (a : α) (w : List α) :
    M.run q (a :: w) = M.run (M.step q a) w := rfl

/-- **Key compositional lemma.** Running on a concatenation `u ++ v` equals
    first running on `u`, then continuing with `v` from the state reached.

    In symbols: `δ̂(q, u ++ v) = δ̂(δ̂(q, u), v)`.

    This is essential for the pumping lemma, where we split `w = x ++ y ++ z`
    and need to reason about each piece independently:
      `M.run q₀ (x ++ yⁿ ++ z) = M.run (M.run (M.run q₀ x) yⁿ) z`

    **Proof by induction on `u`, generalizing `q`.**

    We generalize `q` so that the inductive hypothesis works for *any* starting
    state, not just the original `q`. This is needed because the cons case
    changes the starting state to `M.step q a`.

    - **Base case** (`u = []`):
        `M.run q ([] ++ v) = M.run q v = M.run (M.run q []) v`
        Both sides reduce to `M.run q v` by `List.nil_append` and `run_nil`.

    - **Inductive step** (`u = a :: u'`):
        `M.run q ((a :: u') ++ v)`
        `= M.run q (a :: (u' ++ v))`          — by `List.cons_append`
        `= M.run (M.step q a) (u' ++ v)`      — by `run_cons`
        `= M.run (M.run (M.step q a) u') v`   — by the inductive hypothesis
        `= M.run (M.run q (a :: u')) v`        — by `run_cons` (backwards) -/
@[simp]
theorem run_append (M : DFA α σ) (q : σ) (u v : List α) :
    M.run q (u ++ v) = M.run (M.run q u) v := by
  -- Induct on the first word `u`, generalizing the starting state `q` so
  -- the IH applies to the shifted state `M.step q a` in the cons case.
  induction u generalizing q with
  | nil =>
    -- u = []: M.run q ([] ++ v) = M.run q v = M.run (M.run q []) v
    -- Both sides simplify to M.run q v via List.nil_append and run_nil.
    simp
  | cons a u ih =>
    -- u = a :: u': unfold run on both sides, then the IH closes the goal.
    -- simp applies run_cons and List.cons_append, then ih finishes it.
    simp [ih]

/-- Alternative characterization of acceptance via a **state-sequence witness**.

    Instead of computing the final state recursively, this asserts the existence
    of a run `r : Fin(|w|+1) → σ` that records every intermediate state:
    - `r 0 = M.start`                (the run begins at the start state)
    - `M.step (r i) w[i] = r (i+1)`  (each step follows the transition function)
    - `r |w| ∈ M.accept`             (the final state is accepting)

    This formulation is sometimes more convenient for proofs that need to reason
    about *intermediate* states along the run (e.g., the pigeonhole argument
    that finds two equal states). -/
def accepts' (M : DFA α σ) (w : List α) : Prop :=
  ∃ r : Fin (w.length + 1) → σ,
    -- The run starts at the DFA's initial state.
    (r 0 = M.start) ∧
    -- Each consecutive pair of states respects the transition function:
    -- reading symbol w[i] in state r(i) produces state r(i+1).
    (∀ i : Fin w.length, M.step (r i.castSucc) w[i] = r (i.castSucc + 1)) ∧
    -- The final state is in the accept set.
    (r ⟨w.length, by simp⟩ ∈ M.accept)

end DFA
