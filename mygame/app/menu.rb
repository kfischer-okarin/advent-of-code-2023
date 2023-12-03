ALL_DAY_NUMBERS = (1..2).to_a.freeze

class Menu
  def initialize(args)
    ui = args.state.ui

    @buttons = []
    ALL_DAY_NUMBERS.each do |day_number|
      ui.buttons[day_number] = button(
        w: 200, h: 40,
        text: "Day #{day_number}",
        scene: Object.const_get('Day%02d::Screen' % day_number)
      )
      @buttons << ui.buttons[day_number]
    end

    arrange_in_two_columns(@buttons)
  end

  def tick(args)
    clicked_button = @buttons.find { |button| button[:clicked] }
    go_to_scene(args, clicked_button[:scene]) if clicked_button

    args.outputs.primitives << [
      headline('Advent Of Code 2023'),
      button_primitives(@buttons)
    ]
  end
end
