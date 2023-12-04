module Day02
  class << self
    def result(part)
      lines = read_inputs(2).split("\n")
      parsed_games = lines.map { |line| parse_game_record(line) }
      case part
      when 1
        possible_games = parsed_games.select { |game| game[:sets].all? { |set| possible_set?(set) } }
        possible_games.sum { |game| game[:id] }
      when 2
        minimum_bags_contents = parsed_games.map { |game| minimum_necessary_bag_content(game[:sets]) }
        minimum_bags_contents.sum { |bag_content|
          power(bag_content)
        }
      end
    end

    def parse_game_record(game_record)
      id_string, sets_string = game_record.split(':').map(&:strip)
      id = id_string.split(' ')[1].to_i
      return unless sets_string

      set_strings = sets_string.split(';').map(&:strip)
      sets = set_strings.map { |set_string|
        cube_strings = set_string.split(',').map(&:strip)
        set = {}
        cube_strings.each do |cube_string|
          number_of_cubes, color = cube_string.split(' ')
          next unless %w[blue red green].include? color

          set[color.to_sym] = number_of_cubes.to_i
        end
        set
      }
      return if sets.all? { |set| set == {} }

      { id: id, sets: sets }
    end

    def possible_set?(set)
      set.fetch(:red, 0) <= 12 && set.fetch(:green, 0) <= 13 && set.fetch(:blue, 0) <= 14
    end

    def minimum_necessary_bag_content(sets)
      result = {}
      sets.each do |set|
        set.each do |color, number_of_cubes|
          result[color] = [result.fetch(color, 0), number_of_cubes].max
        end
      end
      result
    end

    def power(set)
      set[:red] * set[:green] * set[:blue]
    end
  end
end
