ALL_DAY_NUMBERS = (1..1).to_a.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)

  send(:"#{state.scene}_tick", args)
  args.state.scene_tick += 1
end

def setup(args)
  state = args.state
  state.scene_tick = 0
  state.scene = :menu
  state.ui.buttons = {}
end

def menu_tick(args)
  menu_setup(args) if args.state.scene_tick.zero?

  args.outputs.primitives << [
    headline('Advent Of Code 2023'),
    button_primitives(menu_day_buttons(args))
  ]
end

def menu_setup(args)
  buttons = args.state.ui.buttons
  ALL_DAY_NUMBERS.each do |day_number|
    buttons[day_number] = {
      w: 200, h: 40,
      text: "Day #{day_number}",
      day: day_number
    }
  end

  arrange_in_two_columns(
    menu_day_buttons(args)
  )
end

def headline(text)
  {
    x: 640, y: 700,
    text: text,
    alignment_enum: 1,
    size_enum: 10
  }
end

def menu_day_buttons(args)
  buttons = args.state.ui.buttons
  ALL_DAY_NUMBERS.map { |day_number| buttons[day_number] }
end

def button_primitives(buttons)
  buttons = [buttons] if buttons.is_a? Hash
  buttons.map { |button|
    [
      button.slice(:x, :y, :w, :h).border!,
      {
        x: button[:x] + button[:w].half,
        y: button[:y] + button[:h].half,
        text: button[:text],
        alignment_enum: 1, vertical_alignment_enum: 1
      }
    ]
  }
end

def arrange_in_two_columns(rects)
  center_x = 320
  y = 620
  rects.each do |rect|
    rect[:h] ||= 30
    rect[:w] ||= 600
    rect.merge!(
      x: center_x - rect[:w].half,
      y: y - rect[:h]
    )
    y -= (rect[:h] + 10)
  end
end

def handle_button_mouse_input(args)
  mouse = args.inputs.mouse
  args.state.ui.buttons.each_value do |button|
    button[:hovered_ticks] ||= 0
    button[:pressed_ticks] ||= 0
    button[:ticks_since_released] ||= 0
    button[:hovered] = mouse.inside_rect? button
    button[:hovered_ticks] = button[:hovered] ? button[:hovered_ticks] + 1 : 0
    button[:click] = button[:hovered] && mouse.click
    button[:pressed] = button[:hovered] && mouse.button_left
    button[:released] = button[:pressed_ticks].positive? && !mouse.button_left
    button[:pressed_ticks] = button[:pressed] ? button[:pressed_ticks] + 1 : 0
    button[:ticks_since_released] = button[:released] ? 0 : button[:ticks_since_released] + 1
  end
end

$gtk.reset
