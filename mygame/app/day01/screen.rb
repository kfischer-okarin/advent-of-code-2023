module Day01
  class Screen < DayScreen
    def initialize(args)
      @result = nil
      @result_label = { y: 480, size_enum: 5 }

      ui = args.state.ui
      @line_input = ui.text_fields[:line_input] = text_field(y: 500, w: 500)
      center_horizontally(@line_input, in_rect: SCREEN)
      align_left(
        [
          @line_input,
          @result_label
        ]
      )
    end

    protected

    def title
      '--- Day 1: Trebuchet?! ---'
    end

    def update(args)
      if @line_input[:text_changed] || part_changed?(args)
        @result = Day01.send(:calc_calibration_value, @line_input[:text], part: part(args))
      end
    end

    def render(args)
      @result_label[:text] = "Result: #{@result || '???'}"

      args.outputs.primitives << [
        text_field_primitives(@line_input),
        @result_label
      ]
    end
  end
end
