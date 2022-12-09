#!/usr/bin/env ruby

INPUT = 'input.txt'
LINES = File.readlines(INPUT)
ROW_COUNT = LINES.size
COLUMN_COUNT = LINES[0].strip.length

def edge?(x, y)
  [0, ROW_COUNT - 1].include?(x) || [0, COLUMN_COUNT - 1].include?(y)
end

def update_tallest_tree(tree, current_tallest)
  return current_tallest unless tree[:height] > current_tallest

  tree[:visible] = true
  tree[:height]
end

tree_grid = LINES.map.with_index do |line, x|
  line.strip.chars.map.with_index do |height, y|
    { height: height.to_i, visible: edge?(x, y) }
  end
end

# I really feel like there's a more elegant way to do this that's just as performant,
# but this'll do.
up_tallest = Array.new(COLUMN_COUNT) { 0 }
down_tallest = Array.new(COLUMN_COUNT) { 0 }
tree_grid.each.with_index do |row, x|
  left_tallest = 0
  right_tallest = 0
  row.each.with_index do |tree, y|
    # Traverse all 4 directions in one pass
    # Horizontal
    left_tallest = update_tallest_tree(tree, left_tallest)
    horizontal_opposite = row[COLUMN_COUNT - y - 1]
    right_tallest = update_tallest_tree(horizontal_opposite, right_tallest)
    
    # Vertical
    up_tallest[y] = update_tallest_tree(tree, up_tallest[y])
    vertical_opposite = tree_grid[ROW_COUNT - x - 1][y]
    down_tallest[y] = update_tallest_tree(vertical_opposite, down_tallest[y])
  end
end

puts tree_grid.sum { |row| row.sum { |tree| tree[:visible] ? 1 : 0 } }
