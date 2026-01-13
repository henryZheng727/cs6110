= Learning Goals
- Practice designing specifications
- Learn how to test a system without fully understanding its internals

= Your Task
Write predicates and generators to test a card game using the Hypothesis library for property based testing (PBT) in Python.
- Download the starter files:
  - `test_card_game.py`
  - `card_game_utils.py`
  - `correct_card_game.py`
- Edit `test_card_game.py`.
  - Implement 3 predicates: `is_valid_deal`, `is_valid_draw`, and `is_valid_play_hand`.
  - Implement 5 generators (Hypothesis calls these "strategies"): `num_players_strat`, `old_hand_strat`, `num_to_draw_strat`, `player_strat`, and `opponent_strat`.
  - Write at least 3 tests, one for each of your predicates. These tests should not use PBT / Hypothesis.
- Do not edit `card_game_utils.py` or `correct_card_game.py`.
  - We recommend that you read `card_game_utils.py`.
  - Ignore `correct_card_game.py` file. You can read it if you want, but the goal is to test it against the informal specification (below), not to understand how this code works.
- Check that all tests pass using `python -m pytest test_card_game.py` (or a similar command)
- Submit your modified `test_card_game.py` with all tests passing.
  - If you collaborated with other students and/or with LLMs such as ChatGPT, write comments to explain where and how.

= Background
Property based testing libraries use *specifications* to generate unit tests. With a few lines of specification, PBT can give the same coverage as many thousands of lines of tests.

A specification (in this assignment) is code that describes how a function should behave on a class of inputs. For example:

For example:
- an addition function should satisfy the specification `0 + n = n` for all numbers `n`
- a JSON encoder/decoder should satisfy `decode(encode(str)) = str` for all strings `str`
- an optimizing compiler should provide the same behavior as a non-optimizing one on all programs (`eval(optimize(p)) = eval(compile(p))`)
By contrast, a normal unit test says what a function does on one input. If you care about lots of inputs then you need to write lots of tests.
 
= Hypothesis
Hypothesis is a PBT library for Python. Hypothesis properties are written like normal tests, but these tests must be decorated with a strategy for discovering inputs.

First, here's a normal test for a factorial function. It tests one input/output example:
```py
# normal unit test, NOT using hypothesis
def test_fact_3():
    assert fact(3) == 3 * fact(2)
```

Second, let's use Hypothesis to test the specification `fact(n) == n * fact(n - 1)` for all numbers greater than zero:
```py
# hypothesis property based test
from hypothesis import given, strategies as st

@given(n=st.integers(min_value=1))
def test_fact_spec(n):
    assert fact(n) == n * fact(n - 1)
```

The `@given` decorator tells Hypothesis what class of inputs we care about. In this case, we care about positive integers. Hypothesis samples this class for integers `n`, then checks that the tests pass for every `n` that it finds.

Running the test on a bad implementation of fact reports an error:
```py
def fact(n):
    if n < 2:
        return 1
    if n > 10:
        return math.inf
    else:
        return n * fact(n-1)
```

```sh
# python -m pytest fact.py
=== short test summary info
FAILED fact.py::test_fact_spec - assert inf == (11 * 3628800)
```

Huzzah!

= Setup
To install Hypothesis and Pytest:
```sh
python -m pip install hypothesis pytest
```

That's all the software you need for this assignment.

Alternatively, follow the instructions here to open VSCode with the required file in your browser: https://github.com/utahplt/pbt-gitpod

= Five-Card Draw
The card game that you will test in this assignment is a simple variant of 5-card-draw poker. Our rules are different than the normal rules:

- Every player starts off with 5 cards from a deck.
  - Each card has a suit and rank. A suit is either spade, heart, diamond, or club. A rank is either a number 2-10 or jack, queen, king, or ace.
  - There are no duplicate cards in the deck. Every player's hand must have distinct cards. For example, a player can't have two copies of the king of diamonds. Two players can't both have a 5 of hearts in their hands.
- A player can choose to discard any number of cards from their hand and redraw.
  - The player chooses *only* the number of cards. The dealer gets to choose the actual cards to replace.
- Two players can go head-to-head to see who has the stronger hand.
  - The first step in matching is to group cards by rank.
    - 4 of the same rank ("of a kind") beats 3 or fewer of a kind.
    - 3 of a kind beats 2 or fewer.
    - 2 of a kind beats 1 of a kind.
  - If two players have the same "kind" of hand, the next step is to check for the *lowest* ranked high-kind group. For example:
    - 2 jacks beats 2 aces
    - 4 twos beats 4 jacks

*This card game is much simpler than popular kinds of poker.*

It may help to ask yourself the following questions before you start designing properties and generators:
- Could I explain Five-Card Draw to another programmer?
- Do I understand what the inputs to every function are supposed to be?
- What inputs are permitted but feel like they *shouldn't* be (if any)?
- Same for the outputs - can I describe them, and are there legal outputs feel like they *shouldn't* be legal?
Thinking through these questions may save time and grief later on.

= Hint
Your generators (aka strategies) should use the Hypothesis helpers `builds()` and `sampled_from()` at least once.
 
= Links
- #link("https://hypothesis.readthedocs.io/en/latest/")[Hypothesis documentation]
- #link("https://docs.python.org/3/tutorial/index.html")[Python tutorial]
- #link("https://docs.python.org/3/library/stdtypes.html")[Python docs: built-in types]
