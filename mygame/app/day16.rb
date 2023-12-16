module Day16
  class << self
    def result(part)
      layout = parse_layout(read_inputs(16))

      case part
      when 1
        energized_tile_count(layout)
      when 2
      end
    end

    def parse_layout(layout_string)
      parse_as_cells(layout_string)
    end

    def advance_beam(beam, layout)
      x, y, direction = beam
      new_directions = nil
      case direction
      when :right
        width = layout.size

        until x == width - 1
          x += 1
          new_directions = new_beam_directions(layout[x][y], direction)
          break if new_directions
        end
      when :up
        height = layout[0].size
        until y == height - 1
          y += 1
          new_directions = new_beam_directions(layout[x][y], direction)
          break if new_directions
        end
      when :left
        until x.zero?
          x -= 1
          new_directions = new_beam_directions(layout[x][y], direction)
          break if new_directions
        end
      when :down
        until y.zero?
          y -= 1
          new_directions = new_beam_directions(layout[x][y], direction)
          break if new_directions
        end
      end
      { x: x, y: y, directions: new_directions || [] }
    end

    def energized_tile_count(layout)
      tiles_energy = layout.map { |column| column.map { 0 } }
      processed_beams = {}
      beams = [[-1, layout[0].size - 1, :right]]
      until beams.empty?
        beam = beams.shift
        next if processed_beams.key? beam

        beam_end = advance_beam(beam, layout)

        left, right = [beam[0], beam_end[:x]].sort
        bottom, top = [beam[1], beam_end[:y]].sort
        (left..right).each do |x|
          next if x == -1

          (bottom..top).each do |y|
            tiles_energy[x][y] = 1
          end
        end

        beam_end[:directions].each do |new_direction|
          beams << [beam_end[:x], beam_end[:y], new_direction]
        end
        processed_beams[beam] = true
      end

      tiles_energy.sum(&:sum)
    end

    private

    def new_beam_directions(cell, direction)
      case cell
      when '\\'
        case direction
        when :right
          %i[down]
        when :up
          %i[left]
        when :left
          %i[up]
        when :down
          %i[right]
        end
      when '/'
        case direction
        when :right
          %i[up]
        when :up
          %i[right]
        when :left
          %i[down]
        when :down
          %i[left]
        end
      when '|'
        case direction
        when :left, :right
          %i[up down]
        end
      when '-'
        case direction
        when :up, :down
          %i[left right]
        end
      end
    end
  end
end
