ALL_DAY_NUMBERS = (1..1).to_a.freeze

def menu_tick(args)
  menu_setup(args) if args.state.scene_tick.zero?

  buttons = menu_day_buttons(args)

  clicked_button = buttons.find { |button| button[:clicked] }
  go_to_scene(args, clicked_button[:scene]) if clicked_button

  args.outputs.primitives << [
    headline('Advent Of Code 2023'),
    button_primitives(buttons)
  ]
end

def menu_setup(args)
  buttons = args.state.ui.buttons
  ALL_DAY_NUMBERS.each do |day_number|
    buttons[day_number] = {
      w: 200, h: 40,
      text: "Day #{day_number}",
      scene: ('day%02d' % day_number).to_sym
    }
  end

  arrange_in_two_columns(
    menu_day_buttons(args)
  )
end

def menu_day_buttons(args)
  buttons = args.state.ui.buttons
  ALL_DAY_NUMBERS.map { |day_number| buttons[day_number] }
end
