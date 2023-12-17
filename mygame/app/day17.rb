module Day17
  class << self
    def result(part)
      case part
      when 1
        minimal_heat_loss(map)
      when 2
      end
    end

    def map
      @map ||= parse_map(read_inputs(17))
    end

    def parse_map(map_string)
      parse_as_cells(map_string).map { |column| column.map(&:to_i) }
    end

    def neighbors(state, map)
      width = map.size
      height = map[0].size
      x, y, direction, steps = state
      result = []
      [
        [x, y + 1, :up],
        [x + 1, y, :right],
        [x, y - 1, :down],
        [x - 1, y, :left]
      ].each do |neighbor_x, neighbor_y, next_direction|
        next if neighbor_x.negative? || neighbor_x >= width || neighbor_y.negative? || neighbor_y >= height
        next if opposite_direction?(direction, next_direction)

        same_direction = direction == next_direction
        next if same_direction && steps == 3

        result << [neighbor_x, neighbor_y, next_direction, same_direction ? steps + 1 : 1]
      end
      result
    end

    def neighbors_ultra_crucibles(state, map)
      width = map.size
      height = map[0].size
      x, y, direction, steps = state
      result = []
      [
        [x, y + 1, :up],
        [x + 1, y, :right],
        [x, y - 1, :down],
        [x - 1, y, :left]
      ].each do |neighbor_x, neighbor_y, next_direction|
        next if neighbor_x.negative? || neighbor_x >= width || neighbor_y.negative? || neighbor_y >= height
        next if opposite_direction?(direction, next_direction)

        same_direction = direction == next_direction
        next_steps = same_direction ? steps + 1 : 1
        next if !same_direction && steps.between?(1, 3)
        next if same_direction && steps == 10

        if next_steps < 4
          case next_direction
          when :up
            next if neighbor_y >= height - 1
          when :right
            next if neighbor_x >= width - 1
          when :down
            next if neighbor_y <= 0
          when :left
            next if neighbor_x <= 0
          end
        end

        result << [neighbor_x, neighbor_y, next_direction, same_direction ? steps + 1 : 1]
      end
      result
    end

    def optimal_path(map, ultra_crucible: false)
      pathfinder = Pathfinder.new(map, ultra_crucible: ultra_crucible)
      pathfinder.step until pathfinder.finished?
      pathfinder.optimal_path_to_current
    end

    def minimal_heat_loss(map, ultra_crucible: false)
      optimal_path = optimal_path(map, ultra_crucible: ultra_crucible)
      optimal_path.shift # ignore first tile
      optimal_path.sum { |x, y| map[x][y] }
    end

    private

    def opposite_direction?(direction1, direction2)
      directions = [direction1, direction2].sort
      [%i[left right], %i[down up]].include? directions
    end
  end

  class Pathfinder
    def initialize(map, ultra_crucible: false)
      @map = map
      @width = map.size
      @height = map[0].size
      start = [0, @height - 1, :right, 0]
      @goal = [@width - 1, 0]
      @frontier = DragonSkeleton::Pathfinding::PriorityQueue.new
      @came_from = MultiDimHash.new(start => nil)
      # @came_from = { start => nil }
      @cost_so_far = MultiDimHash.new(start => 0)
      # @cost_so_far = { start => 0 }
      @frontier.insert start, 0
      @current = nil
      @finished = false
      @ultra_crucible = ultra_crucible
    end

    def finished?
      @frontier.empty? || @finished
    end

    def step
      @current = @frontier.pop
      if @current[0..1] == @goal
        @goal = @current
        @finished = true
        return
      end

      neighbors(@current).each do |neighbor|
        cost = @map[neighbor[0]][neighbor[1]]
        total_cost = @cost_so_far[@current] + cost
        next if @cost_so_far[neighbor] && @cost_so_far[neighbor] <= total_cost

        heuristic_value = (neighbor[0] - @goal[0]).abs + (neighbor[1] - @goal[1]).abs
        priority = total_cost + heuristic_value
        @frontier.insert neighbor, priority
        @came_from[neighbor] = @current
        @cost_so_far[neighbor] = total_cost
      end
    end

    def optimal_path_to_current
      optimal_path_to(@current)
    end

    private

    def optimal_path_to(coordinates)
      result = []
      current = coordinates
      until current.nil?
        result.unshift current[0..1]
        current = @came_from[current]
      end
      result
    end

    def neighbors(cell)
      if @ultra_crucible
        Day17.neighbors_ultra_crucibles(cell, @map)
      else
        Day17.neighbors(cell, @map)
      end
    end
  end
end
