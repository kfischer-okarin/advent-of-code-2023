def day02_tick(args)
  day02_setup(args) if args.state.scene_tick.zero?

  state = args.state.day02
  ui = args.state.ui
  state.total_result = Day02.send(:result, 1) if ui.buttons[:calculate][:clicked]
  state.total_result_label[:text] = "Total Result: #{state.total_result || '???'}"

  args.outputs.primitives << [
    headline('--- Day 2: Cube Conundrum ---'),
    button_primitives(ui.buttons[:calculate]),
    state.total_result_label
  ]
end

def day02_setup(args)
  state = args.state
  state.day02.total_result = nil
  state.day02.total_result_label = { y: 270, size_enum: 5 }

  ui = state.ui
  ui.buttons[:calculate] = { x: 200, y: 300, w: 200, text: 'Calculate' }
  align_left(
    [
      ui.buttons[:calculate],
      state.day02.total_result_label
    ]
  )
end

module Day02
  class << self
    def result(part)
      lines = $gtk.read_file('inputs/day2.txt').split("\n")
      parsed_games = lines.map { |line| parse_game_record(line) }
      possible_games = parsed_games.select { |game| game[:sets].all? { |set| possible_set?(set) } }
      possible_games.sum { |game| game[:id] }
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
          number, color = cube_string.split(' ')
          next unless %w(blue red green).include? color

          set[color.to_sym] = number.to_i
        end
        set
      }
      return if sets.all? { |set| set == {} }

      { id: id, sets: sets }
    end

    def possible_set?(set)
      set.fetch(:red, 0) <= 12 && set.fetch(:green, 0) <= 13 && set.fetch(:blue, 0) <= 14
    end
  end
end
