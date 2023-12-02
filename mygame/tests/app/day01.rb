def test_day01_calc_calibration_value_part1(_args, assert)
  [
    { line: 'invalid', expected: nil },
    { line: '1abc2', expected: 12 },
    { line: 'pqr3stu8vwx', expected: 38 },
    { line: 'a1b2c3d4e5f', expected: 15 },
    { line: 'treb7uchet', expected: 77 }
  ].each do |test_case|
    result = Day01.calc_calibration_value(test_case[:line], part: 1)

    assert.equal! result,
                  test_case[:expected],
                  "Expected calibration value for #{test_case[:line].inspect} to be #{test_case[:expected]} " \
                  "but was #{result}"
  end
end

def test_day01_calc_calibration_value_part2(_args, assert)
  [
    { line: 'invalid', expected: nil },
    { line: 'two1nine', expected: 29 },
    { line: 'eightwothree', expected: 83 },
    { line: 'abcone2threexyz', expected: 13 },
    { line: 'xtwone3four', expected: 24 },
    { line: '4nineeightseven2', expected: 42 },
    { line: 'zoneight234', expected: 14 },
    { line: '7pqrstsixteen', expected: 76 }
  ].each do |test_case|
    result = Day01.calc_calibration_value(test_case[:line], part: 2)

    assert.equal! result,
                  test_case[:expected],
                  "Expected calibration value for #{test_case[:line].inspect} to be #{test_case[:expected]} " \
                  "but was #{result}"
  end
end
