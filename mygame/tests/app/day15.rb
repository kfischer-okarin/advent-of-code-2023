def test_day15_hash_value(_args, assert)
  [
    ['rn=1', 30],
    ['cm-', 253]
  ].each do |string, expected_result|
    result = Day15.hash_value(string)
    assert.equal! result,
                  expected_result,
                  "Expected the hash value of '#{string}' to be #{expected_result}, but it was #{result}"
  end
end

def test_day15_instruction_hash_sum(_args, assert)
  instructions = ['rn=1', 'cm-', 'qp=3', 'cm=2', 'qp-', 'pc=4', 'ot=9', 'ab=5', 'pc-', 'pc=6', 'ot=7']
  assert.equal! Day15.instruction_hash_sum(instructions), 1320
end

def test_day15_execute_instruction(_args, assert)
  boxes = {}

  Day15.execute_instruction('rn=1', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1]] }

  Day15.execute_instruction('cm-', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1]] }

  Day15.execute_instruction('qp=3', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1]], 1 => [[:qp, 3]] }

  Day15.execute_instruction('cm=2', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 1 => [[:qp, 3]] }

  Day15.execute_instruction('qp-', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]] }

  Day15.execute_instruction('pc=4', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:pc, 4]] }

  Day15.execute_instruction('ot=9', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:pc, 4], [:ot, 9]] }

  Day15.execute_instruction('ab=5', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:pc, 4], [:ot, 9], [:ab, 5]] }

  Day15.execute_instruction('pc-', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:ot, 9], [:ab, 5]] }

  Day15.execute_instruction('pc=6', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:ot, 9], [:ab, 5], [:pc, 6]] }

  Day15.execute_instruction('ot=7', boxes)
  assert.equal! boxes, { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:ot, 7], [:ab, 5], [:pc, 6]] }
end

def test_day15_total_focusing_power(_args, assert)
  boxes = { 0 => [[:rn, 1], [:cm, 2]], 3 => [[:ot, 7], [:ab, 5], [:pc, 6]] }

  assert.equal! Day15.total_focusing_power(boxes), 145
end
