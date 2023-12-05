def test_day05_parse_seeds(_args, assert)
  assert.equal! Day05.parse_seeds('seeds: 79 14 55 13'), [79, 14, 55, 13]
end

def test_day05_parse_mappings(_args, assert)
  map_string = <<~MAP
    seed-to-soil map:
    50 98 2
    52 50 48
  MAP

  expected_mappings = [
    { from_range: (98...100), offset: -48 },
    { from_range: (50...98), offset: 2 }
  ]

  assert.equal! Day05.parse_mappings(map_string), expected_mappings
end

def test_day05_map_number(_args, assert)
  mappings = [
    { from_range: (98...100), offset: -48 },
    { from_range: (50...98), offset: 2 }
  ]

  assert.equal! Day05.map_number(mappings, 79), 81
  assert.equal! Day05.map_number(mappings, 14), 14
  assert.equal! Day05.map_number(mappings, 55), 57
  assert.equal! Day05.map_number(mappings, 13), 13
  assert.equal! Day05.map_number(mappings, 98), 50
end

def test_day05_parse_seed_ranges(_args, assert)
  assert.equal! Day05.parse_seed_ranges('seeds: 79 14 55 13'), [(79...93), (55...68)]
end

def test_day05_check_overlap(_args, assert)
  [
    {
      range: (1...10),
      overlapping_range: (7...20),
      result: {
        overlapping: (7...10),
        non_overlapping: [(1...7)]
      }
    },
    {
      range: (10...20),
      overlapping_range: (5...15),
      result: {
        overlapping: (10...15),
        non_overlapping: [(15...20)]
      }
    },
    {
      range: (10...20),
      overlapping_range: (5...25),
      result: {
        overlapping: (10...20),
        non_overlapping: []
      }
    },
    {
      range: (10...20),
      overlapping_range: (13...17),
      result: {
        overlapping: (13...17),
        non_overlapping: [(10...13), (17...20)]
      }
    },
    {
      range: (10...20),
      overlapping_range: (30...40),
      result: {
        overlapping: nil,
        non_overlapping: [(10...20)]
      }
    },
    {
      range: (10...20),
      overlapping_range: (0...3),
      result: {
        overlapping: nil,
        non_overlapping: [(10...20)]
      }
    }
  ].each do |test_case|
    assert.equal! Day05.check_overlap(test_case[:range], test_case[:overlapping_range]),
                  test_case[:result]
  end
end

def test_day05_map_range(_args, assert)
  mappings = [
    { from_range: (98...100), offset: -48 },
    { from_range: (50...98), offset: 2 }
  ]

  [
    { range: (79...93), result: [(81...95)] },
    { range: (40...60), result: [(40...50), (52...62)] },
    { range: (99...105), result: [(51...52), (100...105)] },
    { range: (80...120), result: [(50...52), (82...100), (100...120)] }
  ].each do |test_case|
    result = Day05.map_range(mappings, test_case[:range])
    result = result.sort_by(&:begin)
    assert.equal! result, test_case[:result]
  end
end
