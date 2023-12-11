module Day10
  class << self
    def result(part)
      problem = self.problem
      loop = find_loop(problem[:map], problem[:start_position])
      case part
      when 1
        loop.positions.size.idiv(2)
      when 2
        loop.enclosed_positions.size
      end
    end

    def problem
      parse_problem(read_inputs(10))
    end

    def parse_problem(map_string)
      lines_bottom_to_top = map_string.split("\n").reverse

      start_position = nil
      map = lines_bottom_to_top.map_with_index { |line, y|
        tiles = []
        line.chars.each_with_index { |char, x|
          tiles << (TILE_CONNECTIONS[char] || [])
          start_position = [x, y] if char == 'S'
        }
        tiles
      }.transpose
      map[start_position.x][start_position.y] = determine_tile_from_surroundings(map, start_position) if start_position
      {
        map: map,
        start_position: start_position
      }
    end

    def find_loop(map, start_position)
      PipeLoop.new(map, start_position)
    end

    private

    def determine_tile_from_surroundings(map, position)
      north_tile_connected = map[position.x][position.y + 1].include? :s
      south_tile_connected = map[position.x][position.y - 1].include? :n
      west_tile_connected = map[position.x - 1][position.y].include? :e
      east_tile_connected = map[position.x + 1][position.y].include? :w

      if north_tile_connected && south_tile_connected
        TILE_CONNECTIONS['|']
      elsif west_tile_connected && east_tile_connected
        TILE_CONNECTIONS['-']
      elsif north_tile_connected && east_tile_connected
        TILE_CONNECTIONS['L']
      elsif north_tile_connected && west_tile_connected
        TILE_CONNECTIONS['J']
      elsif south_tile_connected && west_tile_connected
        TILE_CONNECTIONS['7']
      elsif south_tile_connected && east_tile_connected
        TILE_CONNECTIONS['F']
      else
        raise 'Invalid start position'
      end
    end
  end

  TILE_CONNECTIONS = {
    '|' => %i[n s],
    '-' => %i[e w],
    'L' => %i[n e],
    'J' => %i[n w],
    '7' => %i[s w],
    'F' => %i[e s]
  }.freeze

  OPPOSITE_DIRECTION = {
    n: :s,
    s: :n,
    w: :e,
    e: :w
  }.freeze

  DIRECTION_OFFSET = {
    n: [0, 1],
    s: [0, -1],
    w: [-1, 0],
    e: [1, 0]
  }.freeze

  class PipeLoop
    attr_reader :map

    def initialize(map, start_position)
      @map = map
      @start_position = start_position
    end

    def positions
      @positions ||= calc_positions
    end

    def include?(position)
      position_set.include?(position)
    end

    def bottom_left_corner
      @bottom_left_corner ||= calc_bottom_left_corner
    end

    def enclosed_positions
      @enclosed_positions ||= calc_enclosed_positions
    end

    private

    def position_set
      @position_set ||= positions.map { |position| [position, true] }.to_h
    end

    def calc_positions
      result = [@start_position]
      position = @start_position.dup
      connections = @map[position.x][position.y]
      loop do
        next_direction = %i[n e s w].find { |direction| connections.include? direction }
        offset = DIRECTION_OFFSET[next_direction]
        position = [position.x + offset.x, position.y + offset.y]
        break if position == @start_position

        result << position
        direction_we_came_from = OPPOSITE_DIRECTION[next_direction]
        connections = @map[position.x][position.y].reject { |direction| direction == direction_we_came_from }
      end
      result
    end

    def calc_bottom_left_corner
      ne_bend_positions = positions.select { |x, y| @map[x][y] == TILE_CONNECTIONS['L'] }
      ne_bend_positions.min_by { |x, y| x + y }
    end

    def calc_enclosed_positions
      floodfill_grid = FloodfillGrid.build(self)
      start_position = floodfill_grid.top_right_of(bottom_left_corner)
      loop_area_grid_positions = floodfill_grid.flood_fill_from(start_position)
      loop_area_map_positions = floodfill_grid.map_positions_of(loop_area_grid_positions)
      loop_area_map_positions.reject! { |position| include? position }
    end
  end

  class FloodfillGrid
    def self.build(loop)
      new(loop)
    end

    def initialize(loop)
      @loop = loop
    end

    def cells
      @cells ||= build_cells
    end

    def top_right_of(position)
      [(position.x * 3) + 2, (position.y * 3) + 2]
    end

    def flood_fill_from(start)
      result = []
      visited = { start.x => { start.y => true } }
      frontier = [start]
      until frontier.empty?
        current = frontier.shift
        result << current
        visited[current] = true
        unvisited_neighbors = [[0, 1], [1, 0], [0, -1], [-1, 0]].map { |offset_x, offset_y|
          x = current.x + offset_x
          y = current.y + offset_y
          next if (visited[x] || {})[y]

          cell = (cells[x] || [])[y]
          next unless cell == '.'

          [x, y]
        }.compact!
        unvisited_neighbors.each do |x, y|
          visited[x] ||= {}
          visited[x][y] = true
        end
        frontier.concat unvisited_neighbors
      end
      result
    end

    def map_positions_of(grid_positions)
      result = {}
      grid_positions.each do |x, y|
        result[[x.idiv(3), y.idiv(3)]] = true
      end
      result.keys
    end

    private

    def build_cells
      result = []
      @loop.map.each_with_index do |column, x|
        column.each_with_index do |connections, y|
          grid_x = x * 3
          grid_y = y * 3
          3.times do |x_offset|
            result[grid_x + x_offset] ||= []
            3.times do |y_offset|
              result[grid_x + x_offset][grid_y + y_offset] = '.'
            end
          end

          cell = @loop.include?([x, y]) ? 'o' : 'x'
          connections.each do |direction|
            result[grid_x + 1][grid_y + 1] = cell
            case direction
            when :n
              result[grid_x + 1][grid_y + 2] = cell
            when :s
              result[grid_x + 1][grid_y] = cell
            when :w
              result[grid_x][grid_y + 1] = cell
            when :e
              result[grid_x + 2][grid_y + 1] = cell
            end
          end
        end
      end
      result
    end
  end
end
