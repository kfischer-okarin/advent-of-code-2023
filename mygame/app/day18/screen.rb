module Day18
  class Screen < DayScreen
    def initialize(args)
      @map = Day18.dig_trench(Day18.dig_plan)
      Day18.dig_out_lagoon(@map)
      render_target = args.outputs[:map]
      render_target.width = @map.size * 2
      render_target.height = @map[0].size * 2
      @map.each_with_index do |column, x|
        column.each_with_index do |field, y|
          next if field == ' '

          render_target.sprites << { x: x * 2, y: y * 2, w: 2, h: 2, path: :pixel, r: 0, g: 0, b: 0 }
        end
      end
      @map_sprite = {
        x: (1280 - render_target.width).idiv(2),
        y: 50,
        w: render_target.width,
        h: render_target.height,
        path: :map
      }
    end

    protected

    def title
      'Lavaduct Lagoon'
    end

    def render(args)
      args.outputs.sprites << @map_sprite
    end
  end
end
