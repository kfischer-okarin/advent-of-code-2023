require_relative 'menu.rb'
require_relative 'day01.rb'

SCREEN = { x: 0, y: 0, w: 1280, h: 720 }.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)
  handle_text_field_input(args)
  update_cursor(args)

  send(:"#{state.scene}_tick", args)
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
      rect.to_sprite(path: :pixel, r: 150, g: 230, b: 150, a: button[:bg_alpha]),
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

def text_field_primitives(text_fields)
  text_fields = [text_fields] if text_fields.is_a? Hash
  text_fields.map { |text_field|
    text_field[:h] ||= 30
    text_field[:padding_x] ||= 5
    text_field[:padding_y] ||= 2
    rect = text_field.slice(:x, :y, :w, :h)
    result = [
      rect.to_sprite(path: :pixel, r: 200, g: 200, b: 200),
      {
        x: rect[:x] + text_field[:padding_x],
        y: rect[:y] + text_field[:padding_y],
        text: text_field[:text],
        vertical_alignment_enum: 0
      }
    ]

    if text_field[:focused]
      char_offset = text_field[:char_offsets][text_field[:cursor_index]]
      if text_field[:ticks_since_last_input] % 60 < 30
        result << {
          x: text_field[:x] + char_offset,
          y: text_field[:y] + text_field[:padding_y] + 2, w: 1, h: 20,
          path: :pixel, r: 0, g: 0, b: 0
        }.to_sprite
      end
      result << fat_border(rect, thickness: 3, r: 100, g: 100, b: 200)
    end

    result
  }
end

def arrange_in_two_columns(rects)
  column = { x: 0, w: 640 }
  y = 620
  rects.each do |rect|
    rect[:w] ||= 600
    rect[:h] ||= 30
    center_horizontally(rect, in_rect: column)
    rect[:y] = y - rect[:h]

    y -= (rect[:h] + 10)
  end
end

def center_horizontally(rect, in_rect:)
  center_x = in_rect[:x] + in_rect[:w].half
  rect[:x] = center_x - rect[:w].half
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

def handle_text_field_input(args)
  mouse = args.inputs.mouse
  state = args.state
  text_fields = state.ui.text_fields.values

  state.hovered_text_field = nil
  text_fields.each do |text_field|
    text_field[:text] ||= 'abc'
    text_field[:char_offsets] ||= calc_char_offsets(text_field)
    text_field[:hovered] = mouse.inside_rect? text_field
    text_field[:click] = text_field[:hovered] && mouse.click
    text_field[:cursor_index] = calc_cursor_index(text_field) if text_field[:click]

    text_field[:focused_ticks] ||= 0
    text_field[:focused_ticks] = text_field[:focused] ? text_field[:focused_ticks] + 1 : 0
    text_field[:ticks_since_last_input] ||= 0
    text_field[:ticks_since_last_input] = -1 if text_field[:click]

    state.hovered_text_field = text_field if text_field[:hovered]
  end

  if mouse.click
    release_text_field_focus(args) if state.focused_text_field && state.hovered_text_field != state.focused_text_field
    focus_text_field(args, state.hovered_text_field) if state.hovered_text_field && !state.focused_text_field
  end

  text_fields.each do |text_field|
    text_field[:ticks_since_last_input] += 1
  end
end

def calc_char_offsets(text_field)
  padding_x = text_field[:padding_x]
  result = [padding_x]
  text = text_field[:text]
  text_so_far = ''
  (0...text.size).each do |char_index|
    text_so_far += text[char_index]
    text_so_far_w, _ = $gtk.calcstringbox(text_so_far)
    result << (padding_x + text_so_far_w - 1).round
  end
  result
end

def calc_cursor_index(text_field)
  result = 0
  click_offset = text_field[:click].x - text_field[:x]
  text_field[:char_offsets][1..].each do |offset|
    break if click_offset <= offset

    result += 1
  end
  result
end

def focus_text_field(args, text_field)
  puts "focus #{text_field}"
  args.state.focused_text_field = text_field
  text_field[:focused] = true
end

def release_text_field_focus(args)
  state = args.state
  puts "release focus #{state.focused_text_field}"
  state.focused_text_field[:focused] = false
  state.focused_text_field = nil
end

def update_cursor(args)
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
  state.next_scene = nil
  state.ui.buttons = {}
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
