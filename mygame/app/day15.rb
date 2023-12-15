module Day15
  class << self
    def result(part)
      instructions = parse_instructions(read_inputs(15))

      case part
      when 1
        instruction_hash_sum(instructions)
      end
    end

    def parse_instructions(instructions_string)
      instructions_string.strip.split(',')
    end

    def hash_value(string)
      result = 0
      string.chars.each do |char|
        result += char.ord
        result *= 17
        result = result % 256
      end
      result
    end

    def instruction_hash_sum(instructions)
      instructions.sum { |instruction| hash_value(instruction) }
    end
  end
end
