module Day08
  class << self
    def result(part)
      problem  = parse_problem(read_inputs(8))
      steps_until_goal(problem)
    end

    def parse_problem(problem_string)
      instructions_line, map_part = problem_string.split("\n\n")
      {
        instructions: parse_instructions(instructions_line),
        map: parse_map(map_part)
      }
    end

    def steps_until_goal(problem)
      current_node = :AAA
      steps = 0
      problem[:instructions].cycle do |next_direction|
        current_node = problem[:map][current_node][next_direction]
        steps += 1
        break if current_node == :ZZZ
      end
      steps
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
