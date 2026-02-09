= Your Task
Write up the following (roughly 1 page):
1. *Title*: Describe what you want to do in one line.
2. *Motivation*: What problem do you want to address? Why is this problem significant?
3. *Prior Work*: What have others done to address this problem, or closely related ones? Mention at least 2 prior works.
4. *Goal*: What kind of solution do you want to achieve?
5. *Approach*: How will you address the problem? For example, what tools or techniques will you use?
6. *Timeline*: List concrete plans for two milestones:
  - What do you hope to accomplish by early March, before Spring break?
  - What do you hope to accomplish by the end of March, soon before presentations begin?

Aim big, but make sure the goal is something feasible within a 2-month timeframe.

Projects should relate to software verification, but we'll be flexible with this requirement. Talk to the instructor.

Examples: #link("https://utah.instructure.com/courses/1213725/pages/guidelines-project-proposal")[Guidelines: Project Proposal.]
#pagebreak()

1. *Title*: Modeling Finite-State Automata in Lean
2. *Motivation*: there exist very few libraries for automata theory in Lean. This project, as well as helping reinforce understanding of automata theory, may be useful for people seeking to write more extensive proofs on automata in Lean without having to write everything from scratch.
3. #block[
  *Prior Work*:
  #enum(
    numbering: "a)",
    [_Software Foundations Volume 1: Logical Foundations_ includes, as an exercise, a proof of the Pumping Lemma in Rocq.],
    [`nelsmartin` on GitHub has defined DFAs and worked through a brief part of Michael Sipser's _Introduction to the Theory of Computation_ in Lean.],
  )
]
4. *Goal*: prove the Pumping Lemma for regular languages. As a stretch goal, prove several other properties of regular languages (closure under union, concatenation, star; equivalence of DFAs, NFAs, REs).
5. *Approach*: using Lean, define a DFA and use the Pigeonhole Principle to argue for the Pumping Lemma.
6. #block[
  *Timeline*:
  #enum(
    numbering: "a)",
    [By March 1st, we hope to have all necessary formal definitions in place (of DFAs and of the Pumping Lemma itself).],
    [By March 31st, we hope to have a valid proof of the Pumping Lemma for regular languages.],
  )
]
