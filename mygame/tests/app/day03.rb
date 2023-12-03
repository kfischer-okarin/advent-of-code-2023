def test_day03_parse_schematic(_args, assert)
  schematic_string = <<~SCHEMATIC
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  SCHEMATIC

  expected_result = {
    numbers: [
      { number: 664, x: 1, y: 0 },
      { number: 598, x: 5, y: 0 },
      { number: 755, x: 6, y: 2 },
      { number: 592, x: 2, y: 3 },
      { number:  58, x: 7, y: 4 },
      { number: 617, x: 0, y: 5 },
      { number:  35, x: 2, y: 7 },
      { number: 633, x: 6, y: 7 },
      { number: 467, x: 0, y: 9 },
      { number: 114, x: 5, y: 9 }
    ],
    symbols: [
      { symbol: '$', x: 3, y: 1 },
      { symbol: '*', x: 5, y: 1 },
      { symbol: '+', x: 5, y: 4 },
      { symbol: '*', x: 3, y: 5 },
      { symbol: '#', x: 6, y: 6 },
      { symbol: '*', x: 3, y: 8 }
    ]
  }

  assert.equal! Day03.parse_schematic(schematic_string), expected_result
end

def test_day03_part_numbers(_args, assert)
  schematic = {
    numbers: [
      { number: 664, x: 1, y: 0 },
      { number: 598, x: 5, y: 0 },
      { number: 755, x: 6, y: 2 },
      { number: 592, x: 2, y: 3 },
      { number:  58, x: 7, y: 4 },
      { number: 617, x: 0, y: 5 },
      { number:  35, x: 2, y: 7 },
      { number: 633, x: 6, y: 7 },
      { number: 467, x: 0, y: 9 },
      { number: 114, x: 5, y: 9 }
    ],
    symbols: [
      { symbol: '$', x: 3, y: 1 },
      { symbol: '*', x: 5, y: 1 },
      { symbol: '+', x: 5, y: 4 },
      { symbol: '*', x: 3, y: 5 },
      { symbol: '#', x: 6, y: 6 },
      { symbol: '*', x: 3, y: 8 }
    ]
  }

  expected_result = [
    664,
    598,
    755,
    592,
    617,
    35,
    633,
    467
  ]
  assert.equal! Day03.part_numbers(schematic), expected_result
end
