module Day02
  class Screen < DayScreen
    def initialize(args)
      @minimum_bag = {}
      @bag_cubes = []

      ui = args.state.ui
      @line_input = ui.text_fields[:line_input] = text_field(
        y: 500, w: 700,
        text: '3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'
      )
      update_bag_cubes
      center_horizontally(@line_input, in_rect: SCREEN)
    end

    protected

    def title
      'Cube Conundrum'
    end

    def update(args)
      if @line_input[:text_changed]
        update_bag_cubes
      end
    end

    def render(args)
      args.outputs.primitives << [
        text_field_primitives(@line_input),
        @bag_cubes
      ]
    end

    def update_bag_cubes
      parsed_game = Day02.parse_game_record("Game 1: #{@line_input[:text]}")
      new_minimum_bag = Day02.minimum_necessary_bag_content(parsed_game[:sets])
      return if @minimum_bag == new_minimum_bag

      @minimum_bag = new_minimum_bag
      @bag_cubes = []
      @minimum_bag.each do |color, number_of_cubes|
        @bag_cubes << number_of_cubes.map {
          {
            x: 300 + rand(600), y: 50 + rand(420), w: 10, h: 10,
            angle: rand(360), path: :pixel,
            **cube_color(color)
          }
        }
      end
    end

    def cube_color(color)
      case color
      when :red
        { r: 200, g: 0, b: 0 }
      when :blue
        { r: 0, g: 0, b: 200 }
      when :green
        { r: 0, g: 200, b: 0 }
      else
        { r: 100, g: 100, b: 100 }
      end
    end
  end
end
