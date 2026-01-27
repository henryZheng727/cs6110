= Invariants for a Sorting Algorithm
== Your Task
Add invariants to a Dafny implementation of insertion sort. (You may also use Verus.)
- Download the starter code:
  - `isort_stencil.dfy`
- Add invariants to make verification succeed.
  - In VSCode, get rid of all the red squigglies!
  - It's possible to succeed with 5 lines of `invariant`
Do not change the `requires` and `ensures` statements on the main MergeSort method.

== Optional Extra Challenge
Prove merge sort correct: `merge_stencil.dfy`

== Setup
Use VSCode and Dotnet. There's a #link("https://marketplace.visualstudio.com/items?itemName=dafny-lang.ide-vscode")[Dafny extension] on the marketplace
- For macOS M1/M2, homebrew may not work to install dotnet. Go to #link("https://dotnet.microsoft.com/en-us/")[Microsoft] instead
#link("https://github.com/utahplt/dafny-gitpod")[Gitpod]
 
== Learning Goals
- Understand why loop invariants matter and how to write them.
- Convert specifications into formal logic, this time for a sorting algorithm.

== External Links
- #link("https://dafny.org/latest/DafnyRef/DafnyRef")[Dafny reference]
- #link("https://program-proofs.com/assets/pdf/Dafny-cheat-sheet.pdf")[Dafny cheat sheet]
- #link("https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/krml220.pdf")[Getting Started with Dafny: A Guide]
- #link("https://mitpress.mit.edu/9780262546232/program-proofs/")[Program Proofs (the Dafny book)]
- #link("https://verus-lang.github.io/verus/guide/")[Verus tutorial]
