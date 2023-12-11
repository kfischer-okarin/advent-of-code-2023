module Day10
  class << self
    def result(part)
      problem = self.problem
      loop = find_loop(problem[:map], problem[:start_position])
      case part
      when 1
        loop.positions.size.idiv(2)
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

    TILE_CONNECTIONS = {
      '|' => %i[n s],
      '-' => %i[e w],
      'L' => %i[n e],
      'J' => %i[n w],
      '7' => %i[s w],
      'F' => %i[e s]
    }.freeze

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
  end
end
