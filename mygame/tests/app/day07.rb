def test_day07_parse_hand_and_bid(_args, assert)
  assert.equal! Day07.parse_hand_and_bid('32T3K 765'), { hand: [3, 2, 10, 3, 13], bid: 765 }
end

def test_day07_hand_type(_args, assert)
  [
    { hand: [14, 14, 14, 14, 14], result: :five_of_a_kind },
    { hand: [14, 14, 8, 14, 14], result: :four_of_a_kind },
    { hand: [2, 3, 3, 3, 2], result: :full_house },
    { hand: [10, 10, 10, 9, 8], result: :three_of_a_kind },
    { hand: [2, 3, 4, 3, 2], result: :two_pair },
    { hand: [14, 2, 3, 14, 4], result: :one_pair },
    { hand: [2, 3, 4, 5, 6], result: :high_card }
  ].each do |test_case|
    assert.equal! Day07.hand_type(test_case[:hand]), test_case[:result]
  end
end

def test_day07_compare_hands(_args, assert)
  [
    { left: [14, 14, 8, 14, 14], right: [14, 14, 14, 14, 14], winner: -1 },
    { left: [14, 14, 8, 14, 14], right: [2, 3, 3, 3, 2], winner: 1 },
    { left: [3, 3, 3, 3, 2], right: [2, 14, 14, 14, 14], winner: 1 },
    { left: [2, 14, 14, 14, 14], right: [3, 3, 3, 3, 2], winner: -1 },
    { left: [7, 7, 8, 8, 8], right: [7, 7, 7, 8, 8], winner: 1 }
  ].each do |test_case|
    result = Day07.compare_hands(test_case[:left], test_case[:right])
    assert.equal! result,
                  test_case[:winner],
                  "Expected comparison of #{test_case[:left]} and #{test_case[:right]} " \
                  "to be #{test_case[:winner]} but it was #{result}"
  end
end

def test_day07_sort_hand_and_bids(_args, assert)
  hand_and_bids = [
    { hand: [3, 2, 10, 3, 13], bid: 765 },
    { hand: [10, 5, 5, 11, 5], bid: 684 },
    { hand: [13, 13, 6, 7, 7], bid: 28 },
    { hand: [13, 10, 11, 11, 10], bid: 220 },
    { hand: [12, 12, 12, 11, 14], bid: 483 }
  ]

  expected_order = [
    { hand: [3, 2, 10, 3, 13], bid: 765 },
    { hand: [13, 10, 11, 11, 10], bid: 220 },
    { hand: [13, 13, 6, 7, 7], bid: 28 },
    { hand: [10, 5, 5, 11, 5], bid: 684 },
    { hand: [12, 12, 12, 11, 14], bid: 483 }
  ]

  assert.equal! Day07.sort_hand_and_bids(hand_and_bids), expected_order
end

def test_day07_total_winnings(_args, assert)
  hand_and_bids = [
    { hand: [3, 2, 10, 3, 13], bid: 765 },
    { hand: [10, 5, 5, 11, 5], bid: 684 },
    { hand: [13, 13, 6, 7, 7], bid: 28 },
    { hand: [13, 10, 11, 11, 10], bid: 220 },
    { hand: [12, 12, 12, 11, 14], bid: 483 }
  ]

  assert.equal! Day07.total_winnings(hand_and_bids), 6440
end
