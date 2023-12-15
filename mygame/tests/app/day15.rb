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
  instructions = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7\n"
  assert.equal! Day15.instruction_hash_sum(instructions), 1320
end
