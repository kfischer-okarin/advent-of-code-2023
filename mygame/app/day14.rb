module Day14
  class << self
    def result(part)
      platform = parse_platform(read_inputs(14))

      case part
      when 1
        platform = tilt_north(platform)
        platform.sum { |column| load_of_column(column) }
      when 2
        repetition = find_cycle_repetition(platform)
        remaining_cycles = (1_000_000_000 - repetition[:repeated_cycle]) % repetition[:repetition_cycle_length]
        result = do_spin_cycle(repetition[:repeated_state], times: remaining_cycles)
        result.sum { |column| load_of_column(column) }
      end
    end

    def parse_platform(platform_string)
      parse_as_cells(platform_string)
    end

    def roll_rocks_north(column)
      result = column.dup
      (column.size - 1).downto(0).each do |index|
        next unless result[index] == 'O'

        next_wall_index = ((index + 1)...column.size).find { |potential_index|
          %w[O #].include? result[potential_index]
        } || result.size
        next if next_wall_index == (index + 1)

        result[index], result[next_wall_index - 1] = result[next_wall_index - 1], result[index]
      end
      result
    end

    def load_of_column(column)
      column.each_with_index.to_a.sum { |element, index|
        next 0 unless element == 'O'

        index + 1
      }
    end

    def total_load(platform)
      platform.sum { |column| load_of_column(column) }
    end

    def tilt_north(platform)
      platform.map { |column|
        roll_rocks_north(column)
      }
    end

    def rotate_right(platform)
      platform.reverse.transpose
    end

    def do_spin_cycle(platform, times: 1)
      result = platform
      times.times do
        4.times do
          result = tilt_north(result)
          result = rotate_right(result)
        end
      end
      result
    end

    def find_cycle_repetition(platform)
      cycles = 0
      previous_states = [platform]

      loop do
        platform = do_spin_cycle(platform)
        cycles += 1
        repeated_cycle = previous_states.find_index { |previous_state| platform == previous_state }
        if repeated_cycle
          return {
            repeated_cycle: repeated_cycle,
            repeated_state: previous_states[repeated_cycle],
            repetition_cycle_length: cycles - repeated_cycle
          }
        end

        previous_states << platform
      end
    end
  end
end
