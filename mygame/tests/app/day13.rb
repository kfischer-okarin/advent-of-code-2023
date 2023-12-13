def test_day13_parse_pattern(_args, assert)
  expected_result = [
    %w[# . # # . . # # .],
    %w[. . # . # # . # .],
    %w[# # . . . . . . #],
    %w[# # . . . . . . #],
    %w[. . # . # # . # .],
    %w[. . # # . . # # .],
    %w[# . # . # # . # .]
  ].reverse.transpose
  assert.equal! Day13.parse_pattern(Day13Tests.pattern1), expected_result
end

def test_day13_horizontal_reflection_index(_args, assert)
  pattern = Day13.parse_pattern(Day13Tests.pattern1)

  assert.equal! Day13.horizontal_reflection_index(pattern), 4

  pattern = Day13.parse_pattern(Day13Tests.pattern2)

  assert.nil! Day13.horizontal_reflection_index(pattern)
end

def test_day13_vertical_reflection_index(_args, assert)
  pattern = Day13.parse_pattern(Day13Tests.pattern1)

  assert.nil! Day13.vertical_reflection_index(pattern)

  pattern = Day13.parse_pattern(Day13Tests.pattern2)

  assert.equal! Day13.vertical_reflection_index(pattern), 2
end

def test_day13_pattern_summary_score(_args, assert)
  pattern = Day13.parse_pattern(Day13Tests.pattern1)

  assert.equal! Day13.pattern_summary_score(pattern), 5

  pattern = Day13.parse_pattern(Day13Tests.pattern2)

  assert.equal! Day13.pattern_summary_score(pattern), 400
end

def test_day13_horizontal_reflection_index_with_smudge(_args, assert)
  pattern = Day13.parse_pattern(Day13Tests.pattern1)

  assert.nil! Day13.horizontal_reflection_index(pattern, with_smudge: true)

  pattern = Day13.parse_pattern(Day13Tests.pattern2)

  assert.nil! Day13.horizontal_reflection_index(pattern, with_smudge: true)
end

def test_day13_vertical_reflection_index_with_smudge(_args, assert)
  pattern = Day13.parse_pattern(Day13Tests.pattern1)

  assert.equal! Day13.vertical_reflection_index(pattern, with_smudge: true), 3

  pattern = Day13.parse_pattern(Day13Tests.pattern2)

  assert.equal! Day13.vertical_reflection_index(pattern, with_smudge: true), 5
end

module Day13Tests
  class << self
    def pattern1
      <<~PATTERN
        #.##..##.
        ..#.##.#.
        ##......#
        ##......#
        ..#.##.#.
        ..##..##.
        #.#.##.#.
      PATTERN
    end

    def pattern2
      <<~PATTERN
        #...##..#
        #....#..#
        ..##..###
        #####.##.
        #####.##.
        ..##..###
        #....#..#
      PATTERN
    end
  end
end
