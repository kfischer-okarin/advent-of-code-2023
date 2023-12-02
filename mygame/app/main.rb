require_relative 'layout.rb'
require_relative 'menu.rb'
require_relative 'day01.rb'

SCREEN = { x: 0, y: 0, w: 1280, h: 720 }.freeze

def tick(args)
  setup(args) if args.tick_count.zero?

  state = args.state

  handle_button_mouse_input(args)
  handle_text_field_input(args)
  update_mouse_cursor(args)

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

    button[:h] ||= 30

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
    text_field[:text] ||= ''
    text_field[:char_offsets] ||= calc_char_offsets(text_field)
    text_field[:hovered] = mouse.inside_rect? text_field
    text_field[:click] = text_field[:hovered] && mouse.click
    text_field[:cursor_index] = calc_cursor_index(text_field) if text_field[:click]

    text_field[:focused_ticks] ||= 0
    text_field[:focused_ticks] = text_field[:focused] ? text_field[:focused_ticks] + 1 : 0
    text_field[:ticks_since_last_input] ||= 0
    text_field[:ticks_since_last_input] = -1 if text_field[:click]
    text_field[:text_changed] = false

    state.hovered_text_field = text_field if text_field[:hovered]
  end

  if mouse.click
    release_text_field_focus(args) if state.focused_text_field && state.hovered_text_field != state.focused_text_field
    focus_text_field(args, state.hovered_text_field) if state.hovered_text_field && !state.focused_text_field
  end

  handle_text_field_keyboard_input(args, state.focused_text_field) if state.focused_text_field

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
  args.state.focused_text_field = text_field
  text_field[:focused] = true
end

def release_text_field_focus(args)
  state = args.state
  state.focused_text_field[:focused] = false
  state.focused_text_field = nil
end

def handle_text_field_keyboard_input(args, text_field)
  input_chars = args.inputs.text

  if keyboard_key_input(args, :left)
    text_field[:cursor_index] = [text_field[:cursor_index] - 1, 0].max
    text_field[:ticks_since_last_input] = -1
  elsif keyboard_key_input(args, :right)
    text_field[:cursor_index] = [text_field[:cursor_index] + 1, text_field[:text].length].min
    text_field[:ticks_since_last_input] = -1
  elsif input_chars.any?
    input_chars.each do |char|
      text_field[:text].insert(text_field[:cursor_index], char)
      text_field[:cursor_index] += 1
    end
    handle_text_change(text_field)
    text_field[:ticks_since_last_input] = -1
  elsif keyboard_key_input(args, :backspace) && text_field[:cursor_index].positive?
    text_field[:text][text_field[:cursor_index] - 1] = ''
    text_field[:cursor_index] -= 1
    handle_text_change(text_field)
    text_field[:ticks_since_last_input] = -1
  end
end

def handle_text_change(text_field)
  text_field[:text_changed] = true
  text_field[:char_offsets] = calc_char_offsets(text_field)
end

def keyboard_key_input(args, key, repeat_delay: 30, repeat_rate: 5)
  keyboard = args.inputs.keyboard
  return true if keyboard.key_down.send(key)

  held_since_tick = keyboard.key_held.send(key)
  return false unless held_since_tick

  press_duration = args.tick_count - held_since_tick
  return false if press_duration < repeat_delay
  return true if press_duration == repeat_delay

  (press_duration - repeat_delay).mod_zero? repeat_rate
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

def toggle_button(x:, y:)
  { x: x, y: y, w: 70, h: 40, value: true }
end

def toggle_button_primitives(toggle_buttons)
  toggle_buttons = [toggle_buttons] if toggle_buttons.is_a? Hash

  toggle_buttons.map { |toggle_button|
    rect = toggle_button.slice(:x, :y, :w, :h)
    switch_x = toggle_button[:value] ? (rect[:x] + 33) : (rect[:x] + 3)
    [
      rect.to_border,
      { x: switch_x, y: rect[:y] + 3, w: 34, h: 34, r: 0, g: 0, b: 200 }.to_solid
    ]
  }
end

$gtk.reset
