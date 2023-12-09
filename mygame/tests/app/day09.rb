def test_day09_calc_differences(_args, assert)
  sequence = [10, 13, 16, 21, 30, 45, 68]
  expected_result = [
    [3, 3, 5, 9, 15, 23],
    [0, 2, 4, 6, 8],
    [2, 2, 2, 2],
    [0, 0, 0]
  ]

  assert.equal! Day09.calc_differences(sequence), expected_result
end

def test_day09_extrapolate_from(_args, assert)
  assert.equal! Day09.extrapolate_from([10, 13, 16, 21, 30, 45]), 68
end
