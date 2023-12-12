module Day11
  class << self
    def result(part)
      space = parse_space(read_inputs(11))
      case part
      when 1
        space.expand
        calc_distance_sum(space)
      end
    end

    def parse_space(space_string)
      cells = space_string.split("\n").map(&:chars).reverse.transpose
      Space.new(cells)
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

    def expand
      expand_vertically
      expand_horizontally
    end

    private

    def expand_vertically
      offset = 0
      rows_without_galaxies.each do |y|
        @galaxies.transform_values! do |column_galaxies|
          result = {}
          column_galaxies.each do |galaxy_y, galaxies|
            new_y = galaxy_y > y + offset ? galaxy_y + 1 : galaxy_y
            result[new_y] = galaxies
          end
          result
        end
        offset += 1
      end
      @height += offset
    end

    def expand_horizontally
      offset = 0
      columns_without_galaxies.each do |x|
        result = {}
        @galaxies.each do |galaxy_x, galaxies|
          new_x = galaxy_x > x + offset ? galaxy_x + 1 : galaxy_x
          result[new_x] = galaxies
        end
        @galaxies = result
        offset += 1
      end
      @width += offset
    end
  end
end
