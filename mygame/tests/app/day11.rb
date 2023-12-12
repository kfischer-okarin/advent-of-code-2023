def test_day11_parse_space(_args, assert)
  space_string = <<~SPACE
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  SPACE
  space = Day11.parse_space(space_string)

  assert.equal! space[0, 0], '#'
  assert.equal! space[1, 0], '.'
  assert.equal! space[4, 0], '#'
  assert.equal! space[0, 7], '#'

  expected_galaxies = [
    [0, 0],
    [0, 7],
    [1, 4],
    [3, 9],
    [4, 0],
    [6, 5],
    [7, 1],
    [7, 8],
    [9, 3]
  ]
  assert.equal! space.galaxies.sort, expected_galaxies

  assert.equal! space.columns_without_galaxies, [2, 5, 8]
  assert.equal! space.rows_without_galaxies, [2, 6]
end

def test_day11_parse_space_expand(_args, assert)
  space_string = <<~SPACE
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  SPACE
  space = Day11.parse_space(space_string)
  space.expand

  expected_galaxies = [
    [0, 0],
    [0, 9],
    [1, 5],
    [4, 11],
    [5, 0],
    [8, 6],
    [9, 1],
    [9, 10],
    [12, 4]
  ]
  assert.equal! space.galaxies, expected_galaxies
end

def test_day11_calc_distance_sum(_args, assert)
  space_string = <<~SPACE
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  SPACE
  space = Day11.parse_space(space_string)
  space.expand

  assert.equal! Day11.calc_distance_sum(space), 374

  space = Day11.parse_space(space_string)
  space.expand(factor: 10)
  assert.equal! Day11.calc_distance_sum(space), 1030

  space = Day11.parse_space(space_string)
  space.expand(factor: 100)
  assert.equal! Day11.calc_distance_sum(space), 8410
end
