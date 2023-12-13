def arrange_in_two_columns(rects)
  column = { x: 0, w: 640 }
  y = 620
  rects.each do |rect|
    if (y - rect[:h]).negative?
      column[:x] += 640
      y = 620
    end

    rect[:w] ||= 600
    center_horizontally(rect, in_rect: column)
    rect[:y] = y - rect[:h]

    y -= (rect[:h] + 10)
  end
end

def center_horizontally(rect, in_rect:)
  center_x = in_rect[:x] + in_rect[:w].half
  rect[:x] = center_x - rect[:w].half
end

def align_left(rects)
  x = rects.first[:x]
  rects.each do |rect|
    rect[:x] = x
  end
end
