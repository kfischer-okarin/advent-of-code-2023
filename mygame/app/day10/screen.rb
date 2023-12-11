module Day10
  class Screen < DayScreen
    def initialize(args)
      problem = Day10.problem
      map = problem[:map]
      start_position = problem[:start_position]

      loop = Day10.find_loop(map, start_position)

      render_target = args.outputs[:map]
      render_target.width = map.size * 4
      render_target.height = map[0].size * 4

      map.each_with_index do |column, x|
        column.each_with_index do |connections, y|
          position = [x, y]
          color = if position == start_position
                    { r: 0, g: 200, b: 0 }
                  elsif loop.include? position
                    { r: 200, g: 150, b: 0 }
                  else
                    { r: 0, g: 0, b: 0 }
                  end
          connections.each do |connection|
            case connection
            when :n
              render_target.primitives << { x: (x * 4) + 1, y: (y * 4) + 1, w: 2, h: 3, path: :pixel, **color }
            when :s
              render_target.primitives << { x: (x * 4) + 1, y: (y * 4), w: 2, h: 3, path: :pixel, **color }
            when :w
              render_target.primitives << { x: (x * 4), y: (y * 4) + 1, w: 3, h: 2, path: :pixel, **color }
            when :e
              render_target.primitives << { x: (x * 4) + 1, y: (y * 4) + 1, w: 3, h: 2, path: :pixel, **color }
            end
          end
        end
      end
      @map_sprite = { y: 50, w: render_target.width, h: render_target.height, path: :map }
      center_horizontally(@map_sprite, in_rect: SCREEN)
    end

    protected

    def title
      'Pipe Maze'
    end

    def render(args)
      args.outputs.sprites << @map_sprite
    end
  end
end
