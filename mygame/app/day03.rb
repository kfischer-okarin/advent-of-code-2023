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
      Schematic.new(schematic).part_numbers
    end

    class Schematic
      def initialize(schematic)
        @schematic = schematic
      end

      def part_numbers
        result = []
        numbers_by_y.each do |y, numbers|
          possible_symbols = [y - 1, y, y + 1].flat_map { |symbol_y|
            symbols_by_y[symbol_y]
          }.compact

          numbers.each do |number|
            next unless number_x_coordinates(number).any? { |x|
              possible_symbols.any? { |symbol| (x - symbol[:x]).abs <= 1 }
            }

            result << number[:number]
          end
        end
        result
      end

      private

      def numbers_by_y
        @numbers_by_y ||= @schematic[:numbers].group_by { |number| number[:y] }
      end

      def symbols_by_y
        @symbols_by_y ||= @schematic[:symbols].group_by { |symbol| symbol[:y] }
      end

      def number_x_coordinates(number)
        (0...number[:number].to_s.size).map { |offset|
          number[:x] + offset
        }
      end
    end
  end
end
