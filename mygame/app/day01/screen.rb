module Day01
  class Screen < DayScreen
    def initialize(args)
      @result = nil
      @total_result = nil
      @result_label = { y: 480, size_enum: 5 }
      @total_result_label = { y: 270, size_enum: 5 }

      ui = args.state.ui
      @line_input = ui.text_fields[:line_input] = text_field(y: 500, w: 500)
      center_horizontally(@line_input, in_rect: SCREEN)
      @calculate_button = ui.buttons[:calculate] = button(y: 300, w: 200, text: 'Calculate')
      align_left(
        [
          @line_input,
          @result_label,
          @calculate_button,
          @total_result_label
        ]
      )
    end

    def tick(args)
      if @line_input[:text_changed] || part_changed?(args)
        @result = Day01.send(:calc_calibration_value, @line_input[:text], part: part(args))
      end
      @result_label[:text] = "Result: #{@result || '???'}"
      @total_result = Day01.send(:result, part(args)) if @calculate_button[:clicked]
      @total_result_label[:text] = "Total Result: #{@total_result || '???'}"

      args.outputs.primitives << [
        text_field_primitives(@line_input),
        @result_label,
        button_primitives(@calculate_button),
        @total_result_label
      ]
      render_common_ui(args)
    end

    def title
      '--- Day 1: Trebuchet?! ---'
    end
  end
end
