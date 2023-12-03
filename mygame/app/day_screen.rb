class DayScreen
  def tick(args)
    update(args)
    render(args)
    render_common_ui(args)
  end

  protected

  def update(args); end

  def render(args); end

  def render_common_ui(args)
    args.outputs.primitives << [
      headline(title),
      toggle_part_button_primitives(args)
    ]
  end

  def part(args)
    args.state.part
  end

  def part_changed?(args)
    args.state.part_changed
  end
end
