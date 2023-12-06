def test_day06_parse_races(_args, assert)
  races_string = <<~RACES
    Time:      7  15   30
    Distance:  9  40  200
  RACES

  expected = [
    { time: 7, distance: 9 },
    { time: 15, distance: 40 },
    { time: 30, distance: 200 }
  ]
  assert.equal! Day06.parse_races(races_string), expected
end

def test_day06_winning_charge_times(_args, assert)
  race = { time: 7, distance: 9 }

  assert.equal! Day06.winning_charge_times(race), [2, 3, 4, 5]
end
