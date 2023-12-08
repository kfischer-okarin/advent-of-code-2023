def test_day08_parse_problem(_args, assert)
  problem_string = <<~PROBLEM
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
  PROBLEM

  expected_result = {
    instructions: %i[left left right],
    map: {
      AAA: { left: :BBB, right: :BBB },
      BBB: { left: :AAA, right: :ZZZ },
      ZZZ: { left: :ZZZ, right: :ZZZ }
    }
  }

  assert.equal! Day08.parse_problem(problem_string), expected_result
end

def test_day08_steps_until_goal(_args, assert)
  problem = {
    instructions: %i[left left right],
    map: {
      AAA: { left: :BBB, right: :BBB },
      BBB: { left: :AAA, right: :ZZZ },
      ZZZ: { left: :ZZZ, right: :ZZZ }
    }
  }

  assert.equal! Day08.steps_until_goal(problem), 6
end
