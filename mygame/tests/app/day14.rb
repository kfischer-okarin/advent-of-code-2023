def test_day14_roll_rocks_north(_args, assert)
  row = %w[O . . O # . . . O .]

  Day14.roll_rocks_north(row)

  assert.equal! row, %w[. . O O # . . . . O]
end

def test_day14_load_of_column(_args, assert)
  assert.equal! Day14.load_of_column(%w[# # . . . . O O O O]), 34
  assert.equal! Day14.load_of_column(%w[. . . . . . . O O O]), 27
  assert.equal! Day14.load_of_column(%w[. . O O # . . . . O]), 17
  assert.equal! Day14.load_of_column(%w[. . . . . . # . . O]), 10
  assert.equal! Day14.load_of_column(%w[. . . . . . . O # .]), 8
  assert.equal! Day14.load_of_column(%w[# # . # . . O # . #]), 7
  assert.equal! Day14.load_of_column(%w[. # . . . . O # . .]), 7
  assert.equal! Day14.load_of_column(%w[. # . O # . . . . O]), 14
  assert.equal! Day14.load_of_column(%w[. . . . . # . . . .]), 0
  assert.equal! Day14.load_of_column(%w[. . . O # . . O # .]), 12
end

def test_day14_total_load(_args, assert)
  platform = Day14Tests.platform
  Day14.tilt_north(platform)

  assert.equal! Day14.total_load(platform), 136
end

def test_day14_tilt_north(_args, assert)
  platform = Day14Tests.platform

  Day14.tilt_north(platform)

  expected_platform = [
    %w[O O O O . # . O . .],
    %w[O O . . # . . . . #],
    %w[O O . . O # # . . O],
    %w[O . . # . O O . . .],
    %w[. . . . . . . . # .],
    %w[. . # . . . . # . #],
    %w[. . O . . # . O . O],
    %w[. . O . . . . . . .],
    %w[# . . . . # # # . .],
    %w[# . . . . # . . . .]
  ].reverse.transpose
  assert.equal! platform, expected_platform
end

module Day14Tests
  class << self
    def platform
       platform_string = <<~PLATFORM
         O....#....
         O.OO#....#
         .....##...
         OO.#O....O
         .O.....O#.
         O.#..O.#.#
         ..O..#O..O
         .......O..
         #....###..
         #OO..#....
       PLATFORM

       Day14.parse_platform(platform_string)
    end
  end
end
