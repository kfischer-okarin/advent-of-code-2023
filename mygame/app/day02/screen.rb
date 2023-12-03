module Day02
  class Screen < DayScreen
    def initialize(args)
      @total_result = nil
      @total_result_label = { y: 270, size_enum: 5 }

      ui = args.state.ui
      @calculate_button = ui.buttons[:calculate] = button(x: 200, y: 300, w: 200, text: 'Calculate')
      align_left(
        [
          @calculate_button,
          @total_result_label
        ]
      )
    end

    def tick(args)
      @total_result = Day02.send(:result, part(args)) if @calculate_button[:clicked]
      @total_result_label[:text] = "Total Result: #{@total_result || '???'}"

      args.outputs.primitives << [
        button_primitives(@calculate_button),
        @total_result_label
      ]
      render_common_ui(args)
    end

    def title
      '--- Day 2: Cube Conundrum ---'
    end
  end
end
