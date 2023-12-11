def test_day10_parse_problem(_args, assert)
  map_string = <<~MAP
    .....
    .F-7.
    .|.|.
    .L-J.
    .....
  MAP

  result = Day10.parse_problem(map_string)
  assert.nil! result[:start_position]
  assert.equal! result[:map][0][0], []
  assert.equal! result[:map][1][1], %i[n e]
  assert.equal! result[:map][1][2], %i[n s]
  assert.equal! result[:map][1][3], %i[e s]
  assert.equal! result[:map][2][1], %i[e w]
  assert.equal! result[:map][3][1], %i[n w]
  assert.equal! result[:map][3][3], %i[s w]
end

def test_day10_parse_problem_start_position_vertical_pipe(_args, assert)
  Day10Tests::SOUTH_CONNECTED_TILES.each do |north_tile|
    Day10Tests::NORTH_CONNECTED_TILES.each do |south_tile|
      map_string = <<~MAP
        .x.
        .S.
        .y.
      MAP
      map_string.sub!('x', north_tile)
      map_string.sub!('y', south_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[n s]
    end
  end
end

def test_day10_parse_problem_start_position_horizontal_pipe(_args, assert)
  Day10Tests::EAST_CONNECTED_TILES.each do |west_tile|
    Day10Tests::WEST_CONNECTED_TILES.each do |east_tile|
      map_string = <<~MAP
        ...
        xSy
        ...
      MAP
      map_string.sub!('x', west_tile)
      map_string.sub!('y', east_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[e w]
    end
  end
end

def test_day10_parse_problem_start_position_ne_bend(_args, assert)
  Day10Tests::SOUTH_CONNECTED_TILES.each do |north_tile|
    Day10Tests::WEST_CONNECTED_TILES.each do |east_tile|
      map_string = <<~MAP
        .x.
        .Sy
        ...
      MAP
      map_string.sub!('x', north_tile)
      map_string.sub!('y', east_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[n e]
    end
  end
end

def test_day10_parse_problem_start_position_nw_bend(_args, assert)
  Day10Tests::SOUTH_CONNECTED_TILES.each do |north_tile|
    Day10Tests::EAST_CONNECTED_TILES.each do |west_tile|
      map_string = <<~MAP
        .x.
        yS.
        ...
      MAP
      map_string.sub!('x', north_tile)
      map_string.sub!('y', west_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[n w]
    end
  end
end

def test_day10_parse_problem_start_position_sw_bend(_args, assert)
  Day10Tests::NORTH_CONNECTED_TILES.each do |south_tile|
    Day10Tests::EAST_CONNECTED_TILES.each do |west_tile|
      map_string = <<~MAP
        ...
        yS.
        .x.
      MAP
      map_string.sub!('x', south_tile)
      map_string.sub!('y', west_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[s w]
    end
  end
end

def test_day10_parse_problem_start_position_se_bend(_args, assert)
  Day10Tests::NORTH_CONNECTED_TILES.each do |south_tile|
    Day10Tests::WEST_CONNECTED_TILES.each do |east_tile|
      map_string = <<~MAP
        ...
        .Sy
        .x.
      MAP
      map_string.sub!('x', south_tile)
      map_string.sub!('y', east_tile)

      result = Day10.parse_problem(map_string)
      assert.equal! result[:start_position], [1, 1]
      assert.equal! result[:map][1][1], %i[e s]
    end
  end
end

def test_day10_loop_positions(_args, assert)
  map_string = <<~MAP
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
  MAP
  problem = Day10.parse_problem(map_string)
  loop = Day10.find_loop(problem[:map], problem[:start_position])

  expected_positions = [
    [1, 3],
    [2, 3],
    [3, 3],
    [3, 2],
    [3, 1],
    [2, 1],
    [1, 1],
    [1, 2]
  ]
  assert.equal! loop.positions, expected_positions
  assert.true! loop.include?([3, 3])
  assert.false! loop.include?([0, 0])
end

module Day10Tests
  SOUTH_CONNECTED_TILES = %w[F 7 |].freeze
  NORTH_CONNECTED_TILES = %w[L J |].freeze
  EAST_CONNECTED_TILES = %w[F L -].freeze
  WEST_CONNECTED_TILES = %w[7 J -].freeze
end
