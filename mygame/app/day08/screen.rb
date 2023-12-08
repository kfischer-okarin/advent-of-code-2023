module Day08
  class Screen < DayScreen
    def initialize(args)
      @initial_nodes = Day08.initial_nodes_for_ghosts(Day08.problem).map { |node|
        first_goal = Day08.find_next_ghost_goal(Day08.problem, start: node)
        {
          node: node,
          first_goal: first_goal,
          second_goal: Day08.find_next_ghost_goal(
            Day08.problem,
            start: first_goal[:node],
            next_instruction_index: first_goal[:next_instruction_index]
          )
        }
      }
    end

    def render(args)
      @initial_nodes.each_with_index do |node, index|
        args.outputs.labels << { x: 100, y: 500 - (80 * index), text: node[:node].to_s }
        args.outputs.labels << { x: 200, y: 500 - (80 * index), text: "First reached goal: #{node[:first_goal]}" }
        args.outputs.labels << { x: 200, y: 470 - (80 * index), text: "Second reached goal: #{node[:second_goal]}" }
      end
    end

    protected

    def title
      'Haunted Wasteland'
    end
  end
end
