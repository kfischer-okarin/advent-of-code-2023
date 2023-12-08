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

def test_day08_initial_nodes_for_ghosts(_args, assert)
  expected_result = %i[11A 22A]
  assert.equal! Day08.initial_nodes_for_ghosts(Day08Tests.part2_example_problem), expected_result
end

def test_day08_find_next_ghost_goal(_args, assert)
  problem = Day08Tests.part2_example_problem
  assert.equal! Day08.find_next_ghost_goal(problem, start: :'11A'), { node: :'11Z', steps: 2, next_instruction_index: 0 }
end

def test_day08_steps_until_goal_for_ghosts(_args, assert)
  assert.equal! Day08.steps_until_goal_for_ghosts(Day08Tests.part2_example_problem), 6
end

module Day08Tests
  def self.part2_example_problem
    {
      instructions: %i[left right],
      map: {
        '11A': { left: :'11B', right: :XXX },
        '11B': { left: :XXX, right: :'11Z' },
        '11Z': { left: :'11B', right: :XXX },
        '22A': { left: :'22B', right: :XXX },
        '22B': { left: :'22C', right: :'22C' },
        '22C': { left: :'22Z', right: :'22Z' },
        '22Z': { left: :'22B', right: :'22B' },
        XXX: { left: :XXX, right: :XXX }
      }
    }
  end
end
