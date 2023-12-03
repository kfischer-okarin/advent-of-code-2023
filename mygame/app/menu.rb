ALL_DAY_NUMBERS = (1..2).to_a.freeze

class Menu
  def initialize(args)
    ui = args.state.ui

    @buttons = []
    ALL_DAY_NUMBERS.each do |day_number|
      ui.buttons[day_number] = {
        w: 200, h: 40,
        text: "Day #{day_number}",
        scene: ('day%02d' % day_number).to_sym
      }
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

def menu_tick(args)
  menu_setup(args) if args.state.scene_tick.zero?

  args.state.screen.tick(args)
end

def menu_setup(args)
  args.state.screen = Menu.new(args)
end
