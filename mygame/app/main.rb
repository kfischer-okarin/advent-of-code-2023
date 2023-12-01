ALL_DAY_NUMBERS = (1..1).to_a.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)

  send(:"#{state.scene}_tick", args)
  args.state.scene_tick += 1

  return if $gtk.production?
  args.outputs.labels << { x: 0, y: 720, text: $gtk.current_framerate.round.to_s }
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
    button[:bg_alpha] ||= 0
    if button[:hovered]
      button[:bg_alpha] = [button[:bg_alpha] + 15, 255].min
    else
      button[:bg_alpha] = [button[:bg_alpha] - 30, 0].max
    end

    rect = button.slice(:x, :y, :w, :h)
    [
      rect.to_solid(r: 150, g: 230, b: 150, a: button[:bg_alpha]),
      {
        x: button[:x] + button[:w].half,
        y: button[:y] + button[:h].half,
        text: button[:text],
        alignment_enum: 1, vertical_alignment_enum: 1
      },
      rect.to_border
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
  mouse_over_button = false
  args.state.ui.buttons.each_value do |button|
    button[:hovered] = mouse.inside_rect? button
    mouse_over_button = true if button[:hovered]
    button[:clicked] = button[:hovered] && !mouse.click.nil?
  end
  $gtk.set_system_cursor(mouse_over_button ? 'hand' : 'arrow')
end

$gtk.reset
