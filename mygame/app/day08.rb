module Day08
  class << self
    def result(part)
      case part
      when 1
        steps_until_goal(problem)
      when 2
        steps_until_goal_for_ghosts(problem)
      end
    end

    def problem
      parse_problem(read_inputs(8))
    end

    def parse_problem(problem_string)
      instructions_line, map_part = problem_string.split("\n\n")
      {
        instructions: parse_instructions(instructions_line),
        map: parse_map(map_part)
      }
    end

    def steps_until_goal(problem)
      map = problem[:map]
      current_node = :AAA
      steps = 0
      problem[:instructions].cycle do |next_direction|
        current_node = map[current_node][next_direction]
        steps += 1
        break if current_node == :ZZZ
      end
      steps
    end

    def initial_nodes_for_ghosts(problem)
      problem[:map].keys.select { |node| node.end_with? 'A' }
    end

    def find_next_ghost_goal(problem, start:, next_instruction_index: 0)
      map = problem[:map]
      instructions = problem[:instructions]
      state = { node: start, steps: 0, next_instruction_index: next_instruction_index }
      loop do
        next_direction = instructions[state[:next_instruction_index]]
        state[:next_instruction_index] = (state[:next_instruction_index] + 1) % instructions.size
        state[:node] = map[state[:node]][next_direction]
        state[:steps] += 1
        break if state[:node].end_with? 'Z'
      end
      state
    end

    def steps_until_goal_for_ghosts(problem)
      start_nodes = initial_nodes_for_ghosts(problem)
      first_goals = start_nodes.map { |start_node| find_next_ghost_goal(problem, start: start_node) }
      all_steps = first_goals.map { |goal| goal[:steps] }
      Math.least_common_multiple(*all_steps)
    end

    private

    def parse_instructions(instructions_line)
      instructions_line.strip.chars.map { |char|
        case char
        when 'L'
          :left
        when 'R'
          :right
        else
          raise "Unknown instruction character: #{char}"
        end
      }
    end

    def parse_map(map_string)
      result = {}
      map_string.split("\n").each do |line|
        source_node_part, destinations_part = line.split(' = ')
        left_destination, right_destination = destinations_part[1..-2].split(', ').map(&:to_sym)
        result[source_node_part.to_sym] = { left: left_destination, right: right_destination }
      end
      result
    end
  end
end
