def test_day02_parse_game_record(_args, assert)
  [
    {
      game_record: 'invalid',
      expected: nil
    },
    {
      game_record: 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
      expected: {
        id: 1,
        sets: [{ blue: 3, red: 4 }, { red: 1, green: 2, blue: 6 }, { green: 2 }]
      }
    }
  ].each do |test_case|
    result = Day02.parse_game_record(test_case[:game_record])

    assert.equal! result,
                  test_case[:expected],
                  "Expected parsed game record for #{test_case[:game_record].inspect} to be #{test_case[:expected]} " \
                  "but was #{result}"
  end
end

def test_day02_possible_set?(_args, assert)
  assert.true! Day02.possible_set?({ red: 12 })
  assert.false! Day02.possible_set?({ red: 13 })
  assert.true! Day02.possible_set?({ green: 13 })
  assert.false! Day02.possible_set?({ green: 14 })
  assert.true! Day02.possible_set?({ blue: 14 })
  assert.false! Day02.possible_set?({ blue: 15 })
end

def test_day02_minimum_possible_bag_content(_args, assert)
  sets = [{ blue: 3, red: 4 }, { red: 1, green: 2, blue: 6 }, { green: 2 }]
  assert.equal! Day02.minimum_possible_bag_content(sets), { red: 4, green: 2, blue: 6 }
end

def test_day02_power(_args, assert)
  assert.equal! Day02.power({ red: 4, green: 2, blue: 6 }), 48
end
