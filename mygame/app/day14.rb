module Day14
  class << self
    def result(part)
      platform = parse_platform(read_inputs(14))

      case part
      when 1
        tilt_north(platform)
        platform.sum { |column| load_of_column(column) }
      end
    end

    def parse_platform(platform_string)
      parse_as_cells(platform_string)
    end

    def roll_rocks_north(column)
      (column.size - 1).downto(0).each do |index|
        next unless column[index] == 'O'

        next_wall_index = ((index + 1)...column.size).find { |potential_index|
          %w[O #].include? column[potential_index]
        } || column.size
        next if next_wall_index == (index + 1)

        column[index], column[next_wall_index - 1] = column[next_wall_index - 1], column[index]
      end
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
      platform.each do |column|
        roll_rocks_north(column)
      end
    end
  end
end
