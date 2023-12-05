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
