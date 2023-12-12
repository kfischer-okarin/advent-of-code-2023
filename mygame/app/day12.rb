module Day12
  class << self
    def result(part)
      lines = read_inputs(12).split("\n")

      case part
      when 1
        records = lines.map { |line| parse_record(line) }
        records.sum { |record| possible_arrangements(record) }
      end
    end

    def parse_record(record_line)
      springs_part, groups_part = record_line.split
      {
        springs: springs_part.chars,
        damaged_groups: groups_part.split(',').map(&:to_i)
      }
    end

    def possible_indexes_for_first_group(record)
      springs = record[:springs]
      damaged_groups = record[:damaged_groups]
      row_length = springs.size
      group_size = damaged_groups.first
      minimum_total_size = damaged_groups.sum + damaged_groups.size - 1
      first_known_damaged_index = springs.index('#')
      max_possible_index = [row_length - minimum_total_size, first_known_damaged_index].compact.min
      placeable_states = %w[# ?]
      emptyable_states = %w[. ?]
      (0..max_possible_index).select { |index|
        next false unless springs[index...(index + group_size)].all? { |status| placeable_states.include? status }
        next true if index == (row_length - group_size)
        next false if damaged_groups.size == 1 && springs[(index + group_size)..].any? { |status| status == '#' }

        emptyable_states.include? springs[index + group_size]
      }
    end

    def place_first_group(record)
      group_size = record[:damaged_groups].first
      possible_indexes = possible_indexes_for_first_group(record)
      possible_indexes.map { |index|
        {
          springs: record[:springs][index + group_size + 1..],
          damaged_groups: record[:damaged_groups][1..]
        }
      }
    end

    def possible_arrangements(record)
      next_choices = place_first_group(record)
      return next_choices.size if record[:damaged_groups].size == 1

      next_choices.sum { |choice|
        possible_arrangements(choice)
      }
    end
  end
end
