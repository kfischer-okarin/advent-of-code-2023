require_relative 'layout.rb'
require_relative 'ui.rb'
require_relative 'menu.rb'
require_relative 'day01.rb'
require_relative 'day01/screen.rb'
require_relative 'day02.rb'
require_relative 'day02/screen.rb'

SCREEN = { x: 0, y: 0, w: 1280, h: 720 }.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)
  handle_text_field_input(args)
  update_mouse_cursor(args)

  handle_common_ui_input(args) unless state.scene == :menu
  send(:"#{state.scene}_tick", args)
  render_common_ui(args) unless state.scene == :menu
  state.scene_tick += 1

  go_to_scene(args, :menu) if state.scene != :menu && args.inputs.keyboard.key_down.escape
  start_scene(args, state.next_scene) if state.next_scene
  return if $gtk.production?

  args.outputs.labels << { x: 0, y: 720, text: $gtk.current_framerate.round.to_s }
end

def setup(args)
  args.state.focused_text_field = nil
  start_scene(args, :menu)
end

def handle_common_ui_input(args)
  toggle_part_button = args.state.ui.buttons[:toggle_part]
  args.state.part_changed = false
  if toggle_part_button[:clicked]
    toggle_part_button[:value] = !toggle_part_button[:value]
    args.state.part = toggle_part_button[:value] ? 2 : 1
    args.state.part_changed = true
  end
end

def render_common_ui(args)
  args.outputs.primitives << [
    toggle_part_button_primitives(args)
  ]
end

def toggle_part_button_primitives(args)
  button = args.state.ui.buttons[:toggle_part]
  [
    toggle_button_primitives(button),
    { x: button[:x], y: button[:y] - 5, text: '1' },
    { x: button[:x] + button[:w], y: button[:y] - 5, text: '2', alignment_enum: 2 },
  ]
end

def headline(text)
  {
    x: 640, y: 700,
    text: text,
    alignment_enum: 1,
    size_enum: 10
  }
end

def update_mouse_cursor(args)
  cursor = if args.state.hovered_button
             'hand'
           elsif args.state.hovered_text_field
             'ibeam'
           else
             'arrow'
           end
  $gtk.set_system_cursor(cursor)
end

def go_to_scene(args, scene)
  args.state.next_scene = scene
end

def start_scene(args, scene)
  state = args.state
  state.scene_tick = 0
  state.scene = scene
  state.part = 1
  state.next_scene = nil
  state.ui.buttons = {
    toggle_part: toggle_button(x: 1195, y: 660)
  }
  state.ui.text_fields = {}
end

def fat_border(rect, thickness: 2, **values)
  base = { path: :pixel, **values }
  x = rect[:x] - thickness
  y = rect[:y] - thickness
  w = rect[:w] + (thickness * 2)
  h = rect[:h] + (thickness * 2)
  [
    { x: x, y: y, w: w, h: thickness, **base },
    { x: x, y: y + h - thickness, w: w, h: thickness, **base },
    { x: x, y: y, w: thickness, h: h, **base },
    { x: x + w - thickness, y: y, w: thickness, h: h, **base }
  ]
end

$gtk.reset
