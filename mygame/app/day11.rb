module Day11
  class << self
    def result(part)
      space = parse_space(read_inputs(11))
      case part
      when 1
        space.expand
      when 2
        space.expand(factor: 1_000_000)
      end
      calc_distance_sum(space)
    end

    def parse_space(space_string)
      Space.new(parse_as_cells(space_string))
    end

    def calc_distance_sum(space)
      space.galaxies.combination(2).to_a.sum { |galaxy1, galaxy2|
        (galaxy1.x - galaxy2.x).abs + (galaxy1.y - galaxy2.y).abs
      }
    end
  end

  class Space
    attr_reader :cells

    def initialize(cells)
      @galaxies = {}
      cells.each_with_index do |column, x|
        column.each_with_index do |cell, y|
          next unless cell == '#'

          @galaxies[x] ||= {}
          @galaxies[x][y] = true
        end
      end
      @width = cells.size
      @height = cells[0].size
    end

    def [](x, y)
      (@galaxies[x] || {})[y] ? '#' : '.'
    end

    def galaxies
      result = []
      @galaxies.each do |x, column_galaxies|
        column_galaxies.each_key do |y|
          result << [x, y]
        end
      end
      result
    end

    def columns_without_galaxies
      (0...@width).reject { |x| @galaxies.key?(x) }
    end

    def rows_without_galaxies
      (0...@height).reject { |y|
        @galaxies.values.any? { |column_galaxies| column_galaxies.key?(y) }
      }
    end

    def expand(factor: 2)
      expand_vertically(factor)
      expand_horizontally(factor)
    end

    private

    def expand_vertically(factor)
      increment = factor - 1
      offset = 0
      rows_without_galaxies.each do |y|
        @galaxies.transform_values! do |column_galaxies|
          result = {}
          column_galaxies.each do |galaxy_y, galaxies|
            new_y = galaxy_y > y + offset ? galaxy_y + increment : galaxy_y
            result[new_y] = galaxies
          end
          result
        end
        offset += increment
      end
      @height += offset
    end

    def expand_horizontally(factor)
      increment = factor - 1
      offset = 0
      columns_without_galaxies.each do |x|
        result = {}
        @galaxies.each do |galaxy_x, galaxies|
          new_x = galaxy_x > x + offset ? galaxy_x + increment : galaxy_x
          result[new_x] = galaxies
        end
        @galaxies = result
        offset += increment
      end
      @width += offset
    end
  end
end
