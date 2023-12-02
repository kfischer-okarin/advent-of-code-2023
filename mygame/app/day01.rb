def day01_tick(args)
  day01_setup(args) if args.state.scene_tick.zero?

  state = args.state.day01
  ui = args.state.ui
  line_input = ui.text_fields[:line_input]
  state.result = Day01.send(:calc_calibration_value, line_input[:text], part: state.part) if line_input[:text_changed]
  state.result_label[:text] = "Result: #{state.result || '???'}"
  state.total_result = Day01.send(:result, state.part) if ui.buttons[:calculate][:clicked]
  state.total_result_label[:text] = "Total Result: #{state.total_result || '???'}"

  args.outputs.primitives << [
    headline('--- Day 1: Trebuchet?! ---'),
    text_field_primitives(line_input),
    state.result_label,
    button_primitives(ui.buttons[:calculate]),
    state.total_result_label
  ]
end

def day01_setup(args)
  state = args.state
  ui = state.ui
  line_input = ui.text_fields[:line_input] = { y: 500, w: 500 }
  center_horizontally(line_input, in_rect: SCREEN)

  state.day01.part = 1
  state.day01.result = nil
  state.day01.total_result = nil
  state.day01.result_label = { y: 480, size_enum: 5 }
  state.day01.total_result_label = { y: 270, size_enum: 5 }
  ui.buttons[:calculate] = { y: 300, w: 200, text: 'Calculate' }
  align_left(
    [
      line_input,
      state.day01.result_label,
      ui.buttons[:calculate],
      state.day01.total_result_label
    ]
  )
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
      DIGITS_PART1
    end
  end
end
