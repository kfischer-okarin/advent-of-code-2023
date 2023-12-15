module Day15
  class << self
    def result(part)
      instructions = parse_instructions(read_inputs(15))

      case part
      when 1
        instruction_hash_sum(instructions)
      when 2
        boxes = {}
        instructions.each do |instruction|
          execute_instruction(instruction, boxes)
        end
        total_focusing_power(boxes)
      end
    end

    def parse_instructions(instructions_string)
      instructions_string.strip.split(',')
    end

    def hash_value(string)
      result = 0
      string.chars.each do |char|
        result += char.ord
        result *= 17
        result = result % 256
      end
      result
    end

    def instruction_hash_sum(instructions)
      instructions.sum { |instruction| hash_value(instruction) }
    end

    def execute_instruction(instruction, boxes)
      if instruction.end_with?('-')
        label = instruction[0..-2]
        box_number = hash_value(label)
        box = boxes[box_number]
        return unless box

        box.reject! { |lens| lens[0] == label.to_sym }
        boxes.delete box_number if box.empty?
      else
        label, focal_length_string = instruction.split('=')
        box_number = hash_value(label)
        box = boxes[box_number] ||= []
        lens_to_insert = [label.to_sym, focal_length_string.to_i]
        existing_lens_index = box.find_index { |lens| lens[0] == lens_to_insert[0] }
        if existing_lens_index
          box[existing_lens_index] = lens_to_insert
        else
          box << lens_to_insert
        end
      end
    end

    def total_focusing_power(boxes)
      boxes.keys.sum { |box_number|
        box = boxes[box_number]
        box.each_with_index.to_a.sum { |lens, index|
          (box_number + 1) * (index + 1) * lens[1]
        }
      }
    end
  end
end
