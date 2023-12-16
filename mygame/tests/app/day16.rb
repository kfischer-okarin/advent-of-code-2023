def test_day16_advance_beam(_args, assert)
  layout_string = <<~LAYOUT
    ......
    .\\....
    ../...
    ...|..
    ....-.
    ......
  LAYOUT
  layout = Day16.parse_layout(layout_string)

  [
    { beam: [0, 5, :right], result: { x: 5, y: 5, directions: [] } },
    { beam: [0, 4, :right], result: { x: 1, y: 4, directions: %i[down] } },
    { beam: [0, 3, :right], result: { x: 2, y: 3, directions: %i[up] } },
    { beam: [0, 2, :right], result: { x: 3, y: 2, directions: %i[up down] } },
    { beam: [0, 1, :right], result: { x: 5, y: 1, directions: [] } },
    { beam: [0, 0, :up], result: { x: 0, y: 5, directions: [] } },
    { beam: [1, 0, :up], result: { x: 1, y: 4, directions: %i[left] } },
    { beam: [2, 0, :up], result: { x: 2, y: 3, directions: %i[right] } },
    { beam: [3, 0, :up], result: { x: 3, y: 5, directions: [] } },
    { beam: [4, 0, :up], result: { x: 4, y: 1, directions: %i[left right] } },
    { beam: [5, 5, :left], result: { x: 0, y: 5, directions: [] } },
    { beam: [5, 4, :left], result: { x: 1, y: 4, directions: %i[up] } },
    { beam: [5, 3, :left], result: { x: 2, y: 3, directions: %i[down] } },
    { beam: [5, 2, :left], result: { x: 3, y: 2, directions: %i[up down] } },
    { beam: [5, 1, :left], result: { x: 0, y: 1, directions: [] } },
    { beam: [0, 5, :down], result: { x: 0, y: 0, directions: [] } },
    { beam: [1, 5, :down], result: { x: 1, y: 4, directions: %i[right] } },
    { beam: [2, 5, :down], result: { x: 2, y: 3, directions: %i[left] } },
    { beam: [3, 5, :down], result: { x: 3, y: 0, directions: [] } },
    { beam: [4, 5, :down], result: { x: 4, y: 1, directions: %i[left right] } }
  ].each do |test_case|
    result = Day16.advance_beam(test_case[:beam], layout)
    assert.equal! result,
                  test_case[:result],
                  "Expected beam result of #{test_case[:beam]} to be #{test_case[:result]}, but it was #{result}"
  end
end

def test_day16_energized_tile_count(_args, assert)
  layout_string = <<~LAYOUT
    .|...\\....
    |.-.\\.....
    .....|-...
    ........|.
    ..........
    .........\\
    ..../.\\\\..
    .-.-/..|..
    .|....-|.\\
    ..//.|....
  LAYOUT
  layout = Day16.parse_layout(layout_string)

  assert.equal! Day16.energized_tile_count(layout, [-1, 9, :right]), 46
  assert.equal! Day16.energized_tile_count(layout, [3, 10, :down]), 51
  assert.equal! Day16.max_energized_tile_count(layout), 51
end
