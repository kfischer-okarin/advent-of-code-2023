class DayScreen
  def prepare_ui(args)
    args.state.ui.buttons[:toggle_part] = toggle_button(x: 1195, y: 660)
  end

  def tick(args)
    handle_common_ui_input(args)
    update(args)
    render(args)
    render_common_ui(args)
  end

  protected

  def update(args); end

  def render(args); end

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
      headline(title),
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

  def part(args)
    args.state.part
  end

  def part_changed?(args)
    args.state.part_changed
  end
end
