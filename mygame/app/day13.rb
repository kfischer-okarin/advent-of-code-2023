module Day13
  class << self
    def result(part)
      pattern_strings = read_inputs(13).split("\n\n")
      patterns = pattern_strings.map { |pattern_string| parse_pattern(pattern_string) }

      case part
      when 1
        patterns.sum { |pattern| pattern_summary_score(pattern) }
      end
    end

    def parse_pattern(pattern_string)
      pattern_string.split("\n").reverse.map(&:chars).transpose
    end

    def horizontal_reflection_index(pattern)
      candidates = (0...(pattern.size - 1)).select { |index|
        pattern[index] == pattern[index + 1]
      }
      candidates.find { |candidate|
        (0..candidate).all? { |index|
          left = pattern[index]
          right = pattern[candidate + 1 + (candidate - index)] || left
          left == right
        }
      }
    end

    def vertical_reflection_index(pattern)
      horizontal_reflection_index(pattern.transpose)
    end

    def pattern_summary_score(pattern)
      score = 0
      horizontal_index = horizontal_reflection_index(pattern)
      score += (horizontal_index + 1) if horizontal_index
      vertical_index = vertical_reflection_index(pattern)
      score += (pattern[0].size - vertical_index - 1) * 100 if vertical_index
      score
    end
  end
end
