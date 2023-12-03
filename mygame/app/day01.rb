def day01_tick(args)
  day01_setup(args) if args.state.scene_tick.zero?

  args.state.screen.tick(args)
end

def day01_setup(args)
  args.state.screen = Day01::Screen.new(args)
end

def day01_result_label(value, x:)
  { x: x, y: 480, text: value, size_enum: 5 }
end

module Day01
  class << self
    def result(part)
      lines = $gtk.read_file('inputs/day1.txt').split
      lines.sum { |line| calc_calibration_value(line, part: part) }
    end

    DIGITS_PART1 = ('0'..'9').map { |digit|
      { text: digit, digit: digit.to_i }
    }.freeze

    DIGIT_WORDS = %w(zero one two three four five six seven eight nine).freeze

    DIGITS_PART2 = DIGITS_PART1 + DIGIT_WORDS.map_with_index { |word, index|
      { text: word, digit: index }
    }

    def calc_calibration_value(line, part:)
      first_digit = first_digit_from_left(line, part: part)
      second_digit = first_digit_from_right(line, part: part)
      return unless first_digit && second_digit

      (first_digit * 10) + second_digit
    end

    private

    def first_digit_from_left(line, part:)
      result = nil
      result_index = nil

      digits_for_part(part).each do |digit|
        index = line.index(digit[:text])
        next unless index
        next if result_index && result_index < index

        result = digit
        result_index = index
      end

      result&.digit
    end

    def first_digit_from_right(line, part:)
      result = nil
      result_index = nil

      digits_for_part(part).each do |digit|
        index = line.rindex(digit[:text])
        next unless index
        next if result_index && result_index > index

        result = digit
        result_index = index
      end

      result&.digit
    end

    def digits_for_part(part)
      case part
      when 1
        DIGITS_PART1
      when 2
        DIGITS_PART2
      end
    end
  end
end
