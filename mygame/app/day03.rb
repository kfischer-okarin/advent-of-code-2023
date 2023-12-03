module Day03
  class << self
    DIGITS = ('0'..'9').freeze

    def result(part)
      schematic_string = read_inputs(3)
      schematic = parse_schematic(schematic_string)

      part_numbers(schematic).sum
    end

    def parse_schematic(schematic_string)
      result = { numbers: [], symbols: [] }

      lines = schematic_string.split.reverse
      current_number = nil
      lines.each_with_index do |line, y|
        line.chars.each_with_index do |char, x|
          if DIGITS.include? char
            current_number ||= { digits: [], x: x, y: y }
            current_number[:digits] << char
          else
            if current_number
              current_number[:number] = current_number.delete(:digits).join.to_i
              result[:numbers] << current_number
              current_number = nil
            end

            result[:symbols] << { symbol: char, x: x, y: y } unless char == '.'
          end
        end
      end

      result
    end

    def part_numbers(schematic)
      result = []
      schematic[:numbers].each { |number|
        result << number[:number] if schematic[:symbols].any? { |symbol| adjacent?(number, symbol) }
      }
      result
    end

    def adjacent?(number, symbol)
      y_diff = (number[:y] - symbol[:y]).abs
      return false if y_diff >= 2

      number_positions = (0...number[:number].to_s.size).map { |x_offset|
        { x: number[:x] + x_offset, y: number[:y] }
      }
      number_positions.any? { |position|
        x_diff = (position[:x] - symbol[:x]).abs
        [x_diff, y_diff].max == 1
      }
    end
  end
end
