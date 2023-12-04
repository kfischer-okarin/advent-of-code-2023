def test_day04_parse_card(_args, assert)
  expected = {
    winning_numbers: {
      41 => true,
      48 => true,
      83 => true,
      86 => true,
      17 => true
    },
    own_numbers: [83, 86, 6, 31, 17, 9, 48, 53]
  }

  assert.equal! Day04.parse_card('Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'), expected
end

def test_day04_points(_args, assert)
  card = {
    winning_numbers: {
      41 => true,
      48 => true,
      83 => true,
      86 => true,
      17 => true
    },
    own_numbers: [83, 86, 6, 31, 17, 9, 48, 53]
  }

  assert.equal! Day04.points(card), 8
end

def test_day04_total_cards_after_copies(_args, assert)
  matches = [4, 2, 2, 1, 0, 0]

  assert.equal! Day04.total_cards_after_copies(matches), [1, 2, 4, 8, 14, 1]
end
