def day01_tick(args)
  day01_setup(args) if args.state.scene_tick.zero?

  state = args.state.day01
  ui = args.state.ui
  line_input = ui.text_fields[:line_input]
  state.result = Day01.calc_calibration_value(line_input[:text]) if line_input[:text_changed]
  state.result_label[:text] = "Result: #{state.result || '???'}"
  state.total_result = Day01.calculate_day01_result if ui.buttons[:calculate][:clicked]
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
    def calculate_day01_result
      lines = $gtk.read_file('inputs/day1.txt').split
      lines.sum { |line| calc_calibration_value(line) }
    end

    DIGITS = ('0'..'9').to_a.freeze

    def calc_calibration_value(line)
      line_chars = line.chars
      first_digit = line_chars.find { |char| DIGITS.include?(char) }
      second_digit = line_chars.reverse.find { |char| DIGITS.include?(char) }
      return unless first_digit && second_digit

      (first_digit.to_i * 10) + second_digit.to_i
    end
  end
end
