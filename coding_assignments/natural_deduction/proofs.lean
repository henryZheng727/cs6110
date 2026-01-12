theorem one :
    (P ∧ Q) → P → Q := by
      intro pq
      exact fun (p : P) => pq.right

theorem two:
    ¬(P ∧ Q) → R → ¬ R → Q := by
      sorry

theorem three:
    (P → Q) ∨ P ∧ ¬Q := by
      sorry

theorem four:
    ((P → Q) ∧ (P → R)) -> (P → Q ∧ R) := by
      sorry

theorem five:
    P → ¬¬P := by
      sorry

theorem six:
    ¬¬(P ∧ ¬P) := by
      sorry

theorem seven:
    P ∧ ¬P := by
      sorry

theorem eight {P Q : Prop}:
    ((P → Q) → P) → P := by
      sorry

theorem nine {A: U → Prop}:
    (∀x, A x) → (∃y, A y) := by
      sorry

theorem ten {A B: U → Prop}:
    (∀x, A x → B x) → ((∀x, A x) → (∀x, B x)) := by
      sorry

theorem eleven {A B: U → Prop}:
    ((∃x, A x) ∨ (∃x, B x)) → ∃x, (A x ∨ B x) := by
      sorry
