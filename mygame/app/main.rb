require_relative 'menu.rb'
require_relative 'day01.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)
  update_cursor(args)

  send(:"#{state.scene}_tick", args)
  state.scene_tick += 1

  go_to_scene(args, :menu) if state.scene != :menu && args.inputs.keyboard.key_down.escape
  return if $gtk.production?

  args.outputs.labels << { x: 0, y: 720, text: $gtk.current_framerate.round.to_s }
end

def setup(args)
  go_to_scene(args, :menu)
end

def headline(text)
  {
    x: 640, y: 700,
    text: text,
    alignment_enum: 1,
    size_enum: 10
  }
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
  args.state.hovered_button = nil
  args.state.ui.buttons.each_value do |button|
    button[:hovered] = mouse.inside_rect? button
    button[:clicked] = button[:hovered] && !mouse.click.nil?

    args.state.hovered_button = button if button[:hovered]
  end
end

def update_cursor(args)
  cursor = if args.state.hovered_button
             'hand'
           else
             'arrow'
           end
  $gtk.set_system_cursor(cursor)
end

def go_to_scene(args, scene)
  state = args.state
  state.scene_tick = 0
  state.scene = scene
  state.ui.buttons = {}
end

$gtk.reset
