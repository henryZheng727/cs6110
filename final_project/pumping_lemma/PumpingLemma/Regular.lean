-- Regular.lean
-- Definition of regular languages via DFA recognition.
--
-- A language is *regular* iff it is recognized by some DFA whose state space
-- is finite.  The finiteness constraint (`Fintype σ`) is the key ingredient
-- that connects DFA recognition to the pumping lemma: it gives us a concrete
-- pumping length  p = Fintype.card σ  and lets us invoke the pigeonhole
-- principle on the sequence of states visited during a run.

import Mathlib.Data.Fintype.Basic   -- for the Fintype typeclass
import PumpingLemma.DFA

/-- A language `L` over alphabet `α` is **regular** if there exists:

    1. A type `σ` to serve as the DFA's state space,
    2. A proof that `σ` is finite (`Fintype σ`), and
    3. A DFA `M : DFA α σ` whose recognized language equals `L`.

    The existential over `σ` is necessary because different regular languages
    may need DFAs with different numbers of states (e.g., the language
    "strings with at most k consecutive a's" needs at least k+2 states).

    The `Fintype σ` instance is the bridge to the pumping lemma: it guarantees
    a finite state count, so we can define the pumping length as
    `p = Fintype.card σ` and apply the pigeonhole principle to argue that any
    sufficiently long run must revisit a state. -/
def IsRegular {α : Type} (L : Set (List α)) : Prop :=
  ∃ (σ : Type) (_ : Fintype σ) (M : DFA α σ), M.language = L
