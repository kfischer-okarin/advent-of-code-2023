class DayScreen
  def initialize(args); end

  def prepare_ui(args)
    ui = args.state.ui
    ui.buttons[:toggle_part] = toggle_button(x: 1190, y: 660)
    ui.buttons[:calc_day_answer] = button(x: 1060, y: 580, w: 200, text: 'Calculate Answer')
  end

  def tick(args)
    handle_common_ui(args)
    update(args)
    render(args)
    render_common_ui(args)
  end

  protected

  def update(args); end

  def render(args); end

  def handle_common_ui(args)
    state = args.state
    toggle_part_button = state.ui.buttons[:toggle_part]
    state.part_changed = false
    if toggle_part_button[:clicked]
      toggle_part_button[:value] = !toggle_part_button[:value]
      state.part = toggle_part_button[:value] ? 2 : 1
      state.part_changed = true
    end

    calc_day_answer_button = state.ui.buttons[:calc_day_answer]
    calc_day_answer_button[:answer] = nil if state.part_changed
    calc_day_answer_button[:answer] = day_module.result(state.part) if calc_day_answer_button[:clicked]
  end

  def render_common_ui(args)
    ui = args.state.ui
    args.outputs.primitives << [
      headline(title),
      toggle_part_button_primitives(args),
      button_primitives(ui.buttons[:calc_day_answer]),
      day_answer_label(args)
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

  def day_answer_label(args)
    { x: 1060, y: 570, text: "Answer: #{args.state.ui.buttons[:calc_day_answer][:answer]}" }
  end

  def part(args)
    args.state.part
  end

  def part_changed?(args)
    args.state.part_changed
  end

  def day_module
    day_module_name, _ = self.class.name.split('::')
    Object.const_get(day_module_name)
  end
end
