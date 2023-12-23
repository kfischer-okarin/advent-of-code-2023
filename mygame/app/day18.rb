module Day18
  class << self
    def result(part)
      case part
      when 1
        map = dig_trench(dig_plan)
        dig_out_lagoon(map)
        lagoon_size(map)
      when 2
      end
    end

    def dig_plan
      @dig_plan ||= parse_dig_plan(read_inputs(18))
    end

    def parse_dig_plan(dig_plan_string)
      dig_plan_string.split("\n").map { |line|
        direction_part, steps_part, _ = line.split
        [
          DIRECTIONS[direction_part],
          steps_part.to_i
        ]
      }
    end

    DIRECTIONS = { 'U' => :up, 'R' => :right, 'D' => :down, 'L' => :left }.freeze

    def dig_trench(dig_plan)
      x, y, width, height = determine_dimensions(dig_plan)
      result = (0...width).map { (0...height).map { ' ' } }
      result[x][y] = '#'
      dig_plan.each do |direction, steps|
        case direction
        when :up
          steps.times do
            y += 1
            result[x][y] = '#'
          end
        when :right
          steps.times do
            x += 1
            result[x][y] = '#'
          end
        when :down
          steps.times do
            y -= 1
            result[x][y] = '#'
          end
        when :left
          steps.times do
            x -= 1
            result[x][y] = '#'
          end
        end
      end
      result
    end

    def dig_out_lagoon(map)
      bottom_left = find_bottom_left(map)
      start = [bottom_left.x + 1, bottom_left.y + 1]
      frontier = [start]
      until frontier.empty?
        x, y = frontier.pop
        map[x][y] = '#'
        [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |offset_x, offset_y|
          neighbor_x = x + offset_x
          neighbor_y = y + offset_y
          next if map[neighbor_x][neighbor_y] == '#'

          frontier << [neighbor_x, neighbor_y]
        end
      end
    end

    def lagoon_size(map)
      map.sum { |column| column.count { |field| field == '#'  } }
    end

    gprivate

    def determine_dimensions(dig_plan)
      start_x = 0
      start_y = 0
      width = 1
      height = 1
      x = 0
      y = 0
      dig_plan.each do |direction, steps|
        case direction
        when :up
          y += steps
          height = [height, y + 1].max
        when :right
          x += steps
          width = [width, x + 1].max
        when :down
          y -= steps
          if y.negative?
            start_y -= y
            height -= y
            y = 0
          end
        when :left
          x -= steps
          if x.negative?
            start_x -= x
            width -= x
            x = 0
          end
        end
      end

      [start_x, start_y, width, height]
    end

    def find_bottom_left(map)
      from_bottom_left = 0
      loop do
        (0..from_bottom_left).each do |value|
          return [from_bottom_left, value] if map[from_bottom_left][value] == '#'
          next if from_bottom_left == value

          return [value, from_bottom_left] if map[value][from_bottom_left] == '#'
        end
        from_bottom_left += 1
      end
    end
  end
end
