module Day13
  class << self
    def result(part)
      pattern_strings = read_inputs(13).split("\n\n")
      patterns = pattern_strings.map { |pattern_string| parse_pattern(pattern_string) }

      case part
      when 1
        patterns.sum { |pattern| pattern_summary_score(pattern) }
      when 2
        patterns.sum { |pattern| pattern_summary_score(pattern, with_smudge: true) }
      end
    end

    def parse_pattern(pattern_string)
      pattern_string.split("\n").reverse.map(&:chars).transpose
    end

    def horizontal_reflection_index(pattern, with_smudge: false)
      if with_smudge
        candidates = (0...(pattern.size - 1)).select { |index|
          [0, 1].include? differences(pattern[index], pattern[index + 1])
        }

        candidates.find { |candidate|
          total_difference = (0..candidate).to_a.sum { |index|
            left = pattern[index]
            right = pattern[candidate + 1 + (candidate - index)] || left
            differences(left, right)
          }
          total_difference == 1
        }
      else
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
    end

    def vertical_reflection_index(pattern, with_smudge: false)
      horizontal_reflection_index(pattern.transpose, with_smudge: with_smudge)
    end

    def pattern_summary_score(pattern, with_smudge: false)
      score = 0
      horizontal_index = horizontal_reflection_index(pattern, with_smudge: with_smudge)
      score += (horizontal_index + 1) if horizontal_index
      vertical_index = vertical_reflection_index(pattern, with_smudge: with_smudge)
      score += (pattern[0].size - vertical_index - 1) * 100 if vertical_index
      score
    end

    private

    def differences(line1, line2)
      (0...line1.length).count { |index| line1[index] != line2[index] }
    end
  end
end
