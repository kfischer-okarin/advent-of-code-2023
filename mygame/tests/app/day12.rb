def test_day12_parse_record(_args, assert)
  record_line = '???.### 1,1,3'

  expected_record = {
    springs: %w[? ? ? . # # #],
    damaged_groups: [1, 1, 3]
  }
  assert.equal! Day12.parse_record(record_line), expected_record
end

def test_day12_possible_indexes_for_first_group(_args, assert)
  [
    {
      record: Day12Tests.examples[0],
      result: [0]
    },
    {
      record: Day12Tests.examples[1],
      result: [1, 2, 5, 6]
    },
    {
      record: Day12Tests.examples[2],
      result: [1]
    },
    {
      record: Day12Tests.examples[3],
      result: [0]
    },
    {
      record: Day12Tests.examples[4],
      result: [0, 1, 2, 3]
    },
    {
      record: Day12Tests.examples[5],
      result: [1]
    },
    {
      record: {
        springs: %w[# # #],
        damaged_groups: [3]
      },
      result: [0]
    },
    {
      record: {
        springs: %w[? # ? ? ? ? ? ? # ? ? # ? .],
        damaged_groups: [2, 1, 1, 2]
      },
      result: [0, 1]
    },
    {
      record: {
        springs: %w[# ? ? # ? .],
        damaged_groups: [2]
      },
      result: []
    }
  ].each do |test_case|
    result = Day12.possible_indexes_for_first_group(test_case[:record])
    assert.equal! result,
                  test_case[:result],
                  "Expected possible indexes for #{test_case[:record]} to be #{test_case[:result]} " \
                  "but it was #{result}"
  end
end

def test_day12_place_first_group(_args, assert)
  record = {
    springs: %w[. ? ? . . ? ? . . . ? # # .],
    damaged_groups: [1, 1, 3]
  }

  expected_result = [
    {
      springs: %w[. . ? ? . . . ? # # .],
      damaged_groups: [1, 3]
    },
    {
      springs: %w[. ? ? . . . ? # # .],
      damaged_groups: [1, 3]
    },
    {
      springs: %w[. . . ? # # .],
      damaged_groups: [1, 3]
    },
    {
      springs: %w[. . ? # # .],
      damaged_groups: [1, 3]
    }
  ]
  assert.equal! Day12.place_first_group(record), expected_result
end

def test_day12_possible_arrangements(_args, assert)
  [
    {
      record: Day12Tests.examples[0],
      result: 1
    },
    {
      record: Day12Tests.examples[1],
      result: 4
    },
    {
      record: Day12Tests.examples[2],
      result: 1
    },
    {
      record: Day12Tests.examples[3],
      result: 1
    },
    {
      record: Day12Tests.examples[4],
      result: 4
    },
    {
      record: Day12Tests.examples[5],
      result: 10
    },
    {
      record: {
        springs: %w[# # #],
        damaged_groups: [4]
      },
      result: 0
    },
    {
      record: {
        springs: %w[? # ? ? ? ? ? ? # ? ? # ? .],
        damaged_groups: [2, 1, 1, 2]
      },
      result: 14
    }
  ].each do |test_case|
    result = Day12.possible_arrangements(test_case[:record])
    assert.equal! result,
                  test_case[:result],
                  "Expected possible arrangements for #{test_case[:record]} to be #{test_case[:result]} " \
                  "but it was #{result}"
  end
end

module Day12Tests
  class << self
    def examples
      [
        { springs: %w[? ? ? . # # #], damaged_groups: [1, 1, 3] },
        { springs: %w[. ? ? . . ? ? . . . ? # # .], damaged_groups: [1, 1, 3] },
        { springs: %w[? # ? # ? # ? # ? # ? # ? # ?], damaged_groups: [1, 3, 1, 6] },
        { springs: %w[? ? ? ? . # . . . # . . .], damaged_groups: [4, 1, 1] },
        { springs: %w[? ? ? ? . # # # # # # . . # # # # # .], damaged_groups: [1, 6, 5] },
        { springs: %w[? # # # ? ? ? ? ? ? ? ?], damaged_groups: [3, 2, 1] }
      ]
    end
  end
end
