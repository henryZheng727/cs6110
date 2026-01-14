from hypothesis import given, settings, strategies as st
from card_game_utils import MAX_PLAYERS, Hand, HAND_SIZE, GameResult, Card, Rank, Suit, rank_counts
from correct_card_game import deal, draw, play_hand

MAX_EXAMPLES = 1_000 # lower number => faster, but less coverage
settings.register_profile("my_profile", settings(max_examples=MAX_EXAMPLES, deadline=None))
settings.load_profile("my_profile")

def is_valid_hand(h: Hand) -> bool:
    '''
    (HELPER FUNCTION) Check that h is a valid hand: has `HAND_SIZE` cards, all unique.
    '''
    if len(h) != HAND_SIZE:
        return False
    return len(set(h)) == HAND_SIZE

def is_valid_deal(num_players: int, dealt_hands: list[Hand]) -> bool:
    '''
    Check that `dealt_hands` is a valid deal for `num_players`.

    Every player needs `HAND_SIZE` cards. All cards must be unique, no duplicates.
    It is illegal to call deal with no players or with more than `MAX_PLAYERS` players.
    '''
    if len(dealt_hands) != num_players:
        return False
    if any(not is_valid_hand(h) for h in dealt_hands):
        return False

    all_cards = [c for h in dealt_hands for c in h]
    return len(all_cards) == num_players * HAND_SIZE and len(set(all_cards)) == len(all_cards)

def is_valid_draw(old_hand: Hand, num_to_draw: int, new_hand: Hand) -> bool:
    '''
    Check that new_hand is a valid result for `draw(old_hand, num_to_draw)`

    The new hand should have `num_to_draw` cards replaced with different cards.
    It is illegal to call draw on an invalid hand or with a negative
    `num_to_draw` or with a `num_to_draw` that is greater than the number of cards.
    '''
    old_set = set(old_hand)
    new_set = set(new_hand)
    kept = old_set.intersection(new_set)
    added = new_set - old_set

    return len(kept) == HAND_SIZE - num_to_draw and len(added) == num_to_draw

def is_valid_play_hand(player: Hand, opponent: Hand, result: GameResult) -> bool:
    '''
    Check that result is a valid outcome of `play_hand(player, opponent)`
    from the perspective of the player.
    '''
    if not is_valid_hand(player) or not is_valid_hand(opponent):
        return False
    if any(card in opponent for card in player):
        return False
    
    pc = rank_counts(player)
    oc = rank_counts(opponent)

    p_max = max(pc.values())
    o_max = max(oc.values())

    if p_max > o_max:
        expected = GameResult.WIN
    elif p_max < o_max:
        expected = GameResult.LOSS
    else:
        p_low = min(rank.value for (rank, count) in pc.items() if count == p_max)
        o_low = min(rank.value for (rank, count) in oc.items() if count == o_max)
        if p_low == o_low:
            expected = GameResult.TIE
        elif p_low > o_low:
            expected = GameResult.LOSS
        else:
            expected = GameResult.WIN
    
    return result == expected

def card_strat(suits: list[Suit] | None = None):
    '''
    (HELPER FUNCTION) Strategy to generate a single `Card`.
    '''
    suit_choices = suits if suits is not None else list(Suit)
    return st.builds(
        Card,
        rank=st.sampled_from(list(Rank)),
        suit=st.sampled_from(suit_choices)
    )

def num_players_strat():
    return st.integers(min_value=1, max_value=MAX_PLAYERS)

@given(num_players=num_players_strat())
def test_deal(num_players: int):
    dealt_hands = deal(num_players)
    assert is_valid_deal(num_players, dealt_hands)

def old_hand_strat():
    return st.lists(card_strat(), min_size=HAND_SIZE, max_size=HAND_SIZE, unique=True)

def num_to_draw_strat():
    return st.integers(min_value=0, max_value=HAND_SIZE)

@given(old_hand=old_hand_strat(), num_to_draw=num_to_draw_strat())
def test_draw(old_hand: Hand, num_to_draw: int):
    new_hand = draw(old_hand, num_to_draw)
    assert is_valid_draw(old_hand, num_to_draw, new_hand)

def player_strat():
    return st.lists(
        card_strat([Suit.CLUBS, Suit.DIAMONDS]),
        min_size=HAND_SIZE,
        max_size=HAND_SIZE,
        unique=True
    )

def opponent_strat():
    return st.lists(
        card_strat([Suit.HEARTS, Suit.SPADES]),
        min_size=HAND_SIZE,
        max_size=HAND_SIZE,
        unique=True
    )

@given(player=player_strat(), opponent=opponent_strat())
def test_play_hand(player: Hand, opponent: Hand):
    result = play_hand(player, opponent)
    assert is_valid_play_hand(player, opponent, result)

## ---
# Write at least one test for each of the is_valid functions.
# These tests do NOT need to use hypothesis.

def test_is_valid_deal_1():
    raise NotImplementedError

def test_is_valid_draw_1():
    raise NotImplementedError

def test_is_valid_play_hand_1():
    raise NotImplementedError

