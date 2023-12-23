def test_day18_parse_dig_plan(_args, assert)
  dig_plan_string = <<~DIG_PLAN
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    U 2 (#caa173)
  DIG_PLAN

  expected_dig_plan = [
    [:right, 6],
    [:down, 5],
    [:left, 2],
    [:up, 2]
  ]
  assert.equal! Day18.parse_dig_plan(dig_plan_string), expected_dig_plan
end

def test_day18_dig_trench(_args, assert)
  dig_plan = [
    [:right, 6],
    [:down, 5],
    [:left, 2],
    [:up, 2]
  ]

  map = Day18.dig_trench(dig_plan)

  expected_map_string = <<~MAP
    #######
          #
          #
        # #
        # #
        ###
  MAP
  expected_map = parse_as_cells(expected_map_string)
  assert.equal! map, expected_map
end

def test_day18_dig_out_lagoon(_args, assert)
  map_string = <<~MAP
    #######
    #     #
    #     #
    ##### #
        # #
        ###
  MAP
  map = parse_as_cells(map_string)

  Day18.dig_out_lagoon(map)

  expected_map_string = <<~MAP
    #######
    #######
    #######
    #######
        ###
        ###
  MAP
  expected_map = parse_as_cells(expected_map_string)
  assert.equal! map, expected_map
end

def test_day18_lagoon_size(_args, assert)
  map = Day18.dig_trench(Day18Tests.example_plan)
  Day18.dig_out_lagoon(map)

  assert.equal! Day18.lagoon_size(map), 62
end

module Day18Tests
  def self.example_plan
    dig_plan_string = <<~DIG_PLAN
      R 6 (#70c710)
      D 5 (#0dc571)
      L 2 (#5713f0)
      D 2 (#d2c081)
      R 2 (#59c680)
      D 2 (#411b91)
      L 5 (#8ceee2)
      U 2 (#caa173)
      L 1 (#1b58a2)
      U 2 (#caa171)
      R 2 (#7807d2)
      U 3 (#a77fa3)
      L 2 (#015232)
      U 2 (#7a21e3)
    DIG_PLAN
    Day18.parse_dig_plan(dig_plan_string)
  end
end
