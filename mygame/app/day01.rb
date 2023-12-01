def day01_tick(args)
  day01_setup(args) if args.state.scene_tick.zero?

  state = args.state
  args.outputs.primitives << [
    headline('--- Day 1: Trebuchet?! ---'),
    text_field_primitives(state.ui.text_fields[:line_input])
  ]
end

def day01_setup(args)
  text_fields = args.state.ui.text_fields
  text_fields[:line_input] = { y: 500, w: 500 }
  center_horizontally(text_fields[:line_input], in_rect: SCREEN)
end

module Day01
end
