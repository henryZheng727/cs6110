#lang forge/froglet
-- you may also use #lang forge

sig State {}
one sig Election {
   firstState: one State,
   next: pfunc State -> State
}
sig Process {   
   ID: one Int,
   successor: one Process,
   -- the highest ID seen so far at each State index
   --   this tells us which ID to send to the  
   --   successor at each State
   highestSeenID: pfunc State -> Int
}

fun max2 [a, b: Int] : Int {
    { a >= b => a else b }
}

pred wellformed {
   -- every process can reach every process via successor
   -- Assumption: (successor is linear)
   all p1, p2: Process | reachable[p2,p1,successor]

   -- Every process has a nonzero ID
   all p: Process | p.ID > 0

   -- Every process has a different ID
   all p1, p2: Process | p1 != p2 implies p1.ID != p2.ID
}

-- In the initial state, each process sends its own ID
pred init [t: State] {
    all p: Process | p.highestSeenID[t] = p.ID
}

-- A process has won when all processes have its ID. But how does it learn this?
-- A process "knows" it has won when it *receives* its own ID.
pred winningAfter [t: State, p: Process] {
    -- global 
    all q: Process | q.highestSeenID[t] = p.ID
    
    -- p receives itself
    some tPrev: State, pre: Process |
        Election.next[tPrev] = t and
        pre.successor = p and
        pre.highestSeenID[tPrev] = p.ID
    // p.highestSeenID[t] = p.ID
}

-- Validity check for a transition step taken from state <t1> to state <t2>
-- * Think about how a process updates its highestSeenID for the next
--   state, based on the current state and previous states.
-- * Syntax hints:
--   + if-then-else is written as: { e1 => e2 else e3 }
--   + variable declarations are: { let NAME = e1 | e2 }
pred step [t1, t2: State] {
    all p: Process |
        p.successor.highestSeenID[t2] = max2[p.highestSeenID[t1], p.successor.highestSeenID[t1]]
}

-- Read these constraints to get a sense of how to fill in blanks above.
pred traces {
    wellformed -- require a well formed process ring
    init [Election.firstState] -- require a good starting state
    no prev : State | Election.next[prev] = Election.firstState -- first state doesn't have a predecessor
    
    -- all state transitions should satisfy step
    all t: State |
        some Election.next[t] implies
            step [t, Election.next[t]]
}

-- Show a trace where somebody wins. Try to get a trace that's non-trivial.
pred show {
   traces
   some p: Process, t: State | winningAfter[t, p]
   #Process > 1 -- (don’t let Forge give you a 1-process ring!)
}

example1 : run show for exactly 3 Process, 5 State for { next is linear }

pred winningIsForever {
    traces implies {
        -- When a process wins it stays the winner
        -- What does it mean to stay the winner? Think about every process's highestSeenID
        all t: State, p: Process, t2: State, q: Process |
            (winningAfter[t, p] and reachable[t2,t,Election.next])
                implies q.highestSeenID[t2] = p.ID
    }
}

pred eventuallyElectionEnds {
    traces implies {
	    -- Given <traces>, some process will always eventually win.
        some t: State, p: Process | winningAfter[t, p]
    }
}

-- TODO: all tests should pass
--  When a test fails, Forge will print something like this:
--    ******************** TEST FAILED *******************
--    Test example_fail failed. Stopping execution.
--    Test failed due to unsat/inconsistency. No counterexample to display.
--    *****************************************************
--  If possible, Forge will also open Sterling to show a counterexample.
test expect {
    baselineNotVacuous: {} 
        for 3 Process, 5 State 
        for {next is linear} is sat
    ringNotVacuous: {wellformed} 
        for 3 Process, 5 State 
        for {next is linear} is sat
    tracesNotVacuous: {traces} 
        for 3 Process, 5 State
        for {next is linear} is sat
    winningIsForeverTest: {winningIsForever}
        for 3 Process, 5 State
        for {next is linear} is checked
    eventuallyElectionEndsTest: {eventuallyElectionEnds}
        for exactly 3 Process, 5 State
        for {next is linear} is checked   
}

