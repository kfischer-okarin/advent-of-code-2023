require 'lib/math'
require_relative 'layout'
require_relative 'ui'
require_relative 'menu'
require_relative 'day_screen'
require_relative 'day01'
require_relative 'day01/screen'
require_relative 'day02'
require_relative 'day02/screen'
require_relative 'day03'
require_relative 'day03/screen'
require_relative 'day04'
require_relative 'day04/screen'
require_relative 'day05'
require_relative 'day05/screen'
require_relative 'day06'
require_relative 'day06/screen'
require_relative 'day07'
require_relative 'day07/screen'
require_relative 'day08'
require_relative 'day08/screen'
require_relative 'day09'
require_relative 'day09/screen'
require_relative 'day10'
require_relative 'day10/screen'
require_relative 'day11'
require_relative 'day11/screen'
require_relative 'day12'
require_relative 'day12/screen'

SCREEN = { x: 0, y: 0, w: 1280, h: 720 }.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)
  handle_text_field_input(args)
  update_mouse_cursor(args)

  state.scene.tick(args)

  go_to_scene(args, Menu) if !state.scene.is_a?(Menu) && args.inputs.keyboard.key_down.escape
  start_scene(args, state.next_scene_class) if state.next_scene_class
  return if $gtk.production?

  args.outputs.labels << { x: 0, y: 720, text: $gtk.current_framerate.round.to_s }
end

def setup(args)
  reset_ui(args)
  args.state.focused_text_field = nil
  start_scene(args, Menu)
end

def reset_ui(args)
  state = args.state
  state.ui.buttons = {}
  state.ui.text_fields = {}
end

def read_inputs(day_number)
  $gtk.read_file('inputs/day%02d.txt' % day_number)
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

def go_to_scene(args, scene_class)
  args.state.next_scene_class = scene_class
end

def start_scene(args, scene_class)
  reset_ui(args)
  state = args.state
  state.scene = scene_class.new(args)
  state.scene.prepare_ui(args)
  state.part = 1
  state.next_scene_class = nil
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
