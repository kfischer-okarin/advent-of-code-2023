def test_day17_neighbors(_args, assert)
  map = [[1] * 5] * 5
  [
    {
      current: [0, 0, :right, 0],
      result: [[0, 1, :up, 1], [1, 0, :right, 1]]
    },
    {
      current: [2, 1, :right, 2],
      result: [[2, 2, :up, 1], [3, 1, :right, 3], [2, 0, :down, 1]]
    },
    {
      current: [3, 1, :right, 3],
      result: [[3, 2, :up, 1], [3, 0, :down, 1]]
    },
  ].each do |test_case|
    result = Day17.neighbors(test_case[:current], map)
    assert.equal! result,
                  test_case[:result],
                  "Expected neighbors of #{test_case[:current]} to be #{test_case[:result]} but they were #{result}"
  end
end

def test_day17_optimal_path(_args, assert)
  expected_path = [
    [0, 12],
    [1, 12],
    [2, 12],
    [2, 11],
    [3, 11],
    [4, 11],
    [5, 11],
    [5, 12],
    [6, 12],
    [7, 12],
    [8, 12],
    [8, 11],
    [8, 10],
    [9, 10],
    [10, 10],
    [10, 9],
    [10, 8],
    [11, 8],
    [11, 7],
    [11, 6],
    [11, 5],
    [12, 5],
    [12, 4],
    [12, 3],
    [12, 2],
    [11, 2],
    [11, 1],
    [11, 0],
    [12, 0]
  ]
  assert.equal! Day17.optimal_path(Day17Tests.map), expected_path
end

def test_day17_minimal_heat_loss(_args, assert)
  assert.equal! Day17.minimal_heat_loss(Day17Tests.map), 102
end

def test_day17_neighbors_ultra_crucibles(_args, assert)
  map = [[1] * 15] * 15
  [
    {
      current: [0, 0, :right, 0],
      result: [[0, 1, :up, 1], [1, 0, :right, 1]]
    },
    {
      current: [2, 1, :right, 2],
      result: [[3, 1, :right, 3]]
    },
    {
      current: [3, 1, :right, 4],
      result: [[3, 2, :up, 1], [4, 1, :right, 5]]
    },
    {
      current: [3, 1, :right, 10],
      result: [[3, 2, :up, 1]]
    },
    {
      current: [13, 1, :right, 1],
      result: []
    },
    {
      current: [13, 1, :right, 3],
      result: [[14, 1, :right, 4]]
    },
    {
      current: [2, 1, :down, 3],
      result: [[2, 0, :down, 4]]
    },
    {
      current: [2, 1, :down, 2],
      result: []
    },
    {
      current: [2, 2, :down, 2],
      result: [[2, 1, :down, 3]]
    },
    {
      current: [1, 0, :down, 5],
      result: [[2, 0, :right, 1]]
    },
  ].each do |test_case|
    result = Day17.neighbors_ultra_crucibles(test_case[:current], map)
    assert.equal! result,
                  test_case[:result],
                  "Expected neighbors of #{test_case[:current]} to be #{test_case[:result]} but they were #{result}"
  end
end

def test_day17_optimal_path_ultra_crucible(_args, assert)
  expected_path = [
    [0, 12],
    [1, 12],
    [2, 12],
    [3, 12],
    [4, 12],
    [5, 12],
    [6, 12],
    [7, 12],
    [8, 12],
    [8, 11],
    [8, 10],
    [8, 9],
    [8, 8],
    [9, 8],
    [10, 8],
    [11, 8],
    [12, 8],
    [12, 7],
    [12, 6],
    [12, 5],
    [12, 4],
    [12, 3],
    [12, 2],
    [12, 1],
    [12, 0]
  ]
  assert.equal! Day17.optimal_path(Day17Tests.map, ultra_crucible: true), expected_path

  expected_path = [
    [0, 4],
    [1, 4],
    [2, 4],
    [3, 4],
    [4, 4],
    [5, 4],
    [6, 4],
    [7, 4],
    [7, 3],
    [7, 2],
    [7, 1],
    [7, 0],
    [8, 0],
    [9, 0],
    [10, 0],
    [11, 0]
  ]
  assert.equal! Day17.optimal_path(Day17Tests.map2, ultra_crucible: true), expected_path
end

def test_day17_minimal_heat_loss_ultra_crucible(_args, assert)
  assert.equal! Day17.minimal_heat_loss(Day17Tests.map, ultra_crucible: true), 94
  assert.equal! Day17.minimal_heat_loss(Day17Tests.map2, ultra_crucible: true), 71
end

module Day17Tests
  def self.map
    map_string = <<~MAP
      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533
    MAP

    Day17.parse_map(map_string)
  end

  def self.map2
    map_string = <<~MAP
      111111111111
      999999999991
      999999999991
      999999999991
      999999999991
    MAP
    Day17.parse_map(map_string)
  end
end
