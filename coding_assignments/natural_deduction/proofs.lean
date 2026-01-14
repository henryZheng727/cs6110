theorem contrapositive:
    (P → Q) → (¬Q → ¬P) := by
      intro ptoq
      intro notq
      false_or_by_contra
      rename_i p
      have q := ptoq p
      contradiction

theorem one :
    (P ∧ Q) → P → Q := by
      intro pq
      exact fun (p : P) => pq.right

theorem two:
    ¬(P ∧ Q) → R → ¬R → Q := by
      intro not_p_and_q
      intro r
      intro not_r
      contradiction

theorem three:
    (P → Q) ∨ P ∧ ¬Q := by
  classical
  by_cases hQ : Q
  case pos =>
    left
    intro p
    exact hQ
  case neg =>
    by_cases hP : P
    case pos =>
      right
      exact And.intro hP hQ
    case neg =>
      left
      intro p
      exfalso
      exact hP p

theorem four:
    ((P → Q) ∧ (P → R)) → (P → Q ∧ R) := by
      intro ptoq_and_ptor
      intro p
      constructor
      exact ptoq_and_ptor.left p
      exact ptoq_and_ptor.right p

theorem five:
    P → ¬¬P := by
      intro p
      intro notp
      contradiction

theorem seven:
    P ∨ ¬P := by
    classical
    exact Classical.em P

theorem six:
    ¬¬(P ∨ ¬P) := by
      apply five seven

-- this is probably overly complicated ngl but we ball
theorem eight {P Q : Prop}:
    ((P → Q) → P) → P := by
      intro assumption
      false_or_by_contra
      rename_i not_p
      have assumption_contrapositive := contrapositive assumption
      have not_ptoq := assumption_contrapositive not_p
      cases three with
      | inl left_true => contradiction
      | inr right_true =>
          have p := right_true.left
          contradiction

theorem nine {A: Prop → Prop}:
    (∀x, A x) → (∃y, A y) := by
      intro ax
      specialize ax True
      exact ⟨True, ax⟩

theorem ten {A B: Prop → Prop}:
    (∀x, A x → B x) → ((∀x, A x) → (∀x, B x)) := by
      intro ax_to_bx
      intro ax
      intro x
      specialize ax x
      specialize ax_to_bx x
      exact ax_to_bx ax

theorem eleven {A B: Prop → Prop}:
    ((∃x, A x) ∨ (∃x, B x)) → ∃x, (A x ∨ B x) := by
      intro assumption
      cases assumption with
      | inl left =>
          cases left with
          | intro x ax => exact ⟨x, Or.inl ax⟩
      | inr right =>
          cases right with
          | intro x bx => exact ⟨x, Or.inr bx⟩
