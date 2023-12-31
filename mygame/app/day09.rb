module Day09
  class << self
    def result(part)
      sequences = read_inputs(9).split("\n").map { |line| line.split.map(&:to_i) }
      case part
      when 1
        next_values = sequences.map { |sequence| extrapolate_next_value_from(sequence) }
        next_values.sum
      when 2
        previous_values = sequences.map { |sequence| extrapolate_previous_value_from(sequence) }
        previous_values.sum
      end
    end

    def calc_differences(sequence)
      last_sequence = sequence
      result = []
      until last_sequence.all?(&:zero?)
        next_sequence = (0...(last_sequence.size - 1)).map { |index|
          last_sequence[index + 1] - last_sequence[index]
        }
        result << next_sequence
        last_sequence = next_sequence
      end
      result
    end

    def extrapolate_next_value_from(sequence)
      sequences = [sequence.dup, *calc_differences(sequence)]
      last_index = sequences.size - 1
      sequences[last_index] << 0
      last_index.downto(1).each do |index|
        previous_sequence = sequences[index - 1]
        previous_sequence << (previous_sequence[-1] + sequences[index][-1])
      end
      sequences[0][-1]
    end

    def extrapolate_previous_value_from(sequence)
      sequences = [sequence.dup, *calc_differences(sequence)]
      last_index = sequences.size - 1
      sequences[last_index].unshift 0
      last_index.downto(1).each do |index|
        previous_sequence = sequences[index - 1]
        previous_sequence.unshift (previous_sequence[0] - sequences[index][0])
      end
      sequences[0][0]
    end
  end
end
