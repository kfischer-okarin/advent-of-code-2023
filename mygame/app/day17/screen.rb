module Day17
  class Screen < DayScreen
    def initialize(args)
      @map = Day17.map
      render_target = args.outputs[:map]
      render_target.width = @map.size * 4
      render_target.height = @map[0].size * 4
      @map.each_with_index do |column, x|
        column.each_with_index do |heat_loss, y|
          render_target.sprites << { x: x * 4, y: y * 4, w: 4, h: 4, path: :pixel, r: 0, g: 0, b: 150 + 10 * heat_loss }
        end
      end
      @map_sprite = {
        x: (1280 - render_target.width).idiv(2),
        y: 50,
        w: render_target.width,
        h: render_target.height,
        path: :map
      }
      @pathfinder = Day17::Pathfinder.new(@map)
      @started = false
    end

    protected

    def update(args)
      return if !@started || @pathfinder.finished?

      1000.times do
        @pathfinder.step
        if @pathfinder.finished?
          optimal_path = @pathfinder.optimal_path_to_current
          optimal_path.shift # ignore first tile
          set_answer(args, optimal_path.sum { |x, y| @map[x][y] })
          break
        end
      end
    end

    def render(args)
      args.outputs.sprites << @map_sprite
      @pathfinder.optimal_path_to_current.each do |x, y|
        args.outputs.sprites << {
          x: @map_sprite[:x] + (x * 4),
          y: @map_sprite[:y] + (y * 4),
          w: 4, h: 4, r: 255, g: 255, b: 255, path: :pixel
        }
      end
    end

    def on_calc_day_answer(_args)
      @started = true
    end

    def title
      'Clumsy Crucible'
    end
  end
end
