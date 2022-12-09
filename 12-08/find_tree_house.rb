#!/usr/bin/env ruby

INPUT = 'input.txt'
LINES = File.readlines(INPUT)
ROW_COUNT = LINES.size
COLUMN_COUNT = LINES[0].strip.length

def tree_grid
  @tree_grid ||=
    LINES.map.with_index do |line, x|
      line.strip.chars.map.with_index do |height, y|
        { height: height.to_i, visible: edge?(x, y), up: 0, down: 0, left: 0, right: 0 }
      end
    end
end

def edge?(x, y)
  [0, ROW_COUNT - 1].include?(x) || [0, COLUMN_COUNT - 1].include?(y)
end

def update_tree_visibility(tree, current_tallest, direction, index, orthogonal_index, distance_from_edge = index)
  if current_tallest.nil? || tree[:height] > current_tallest[:height]
    tree[:visible] = true

    # Since we can see it from the edge, the distance score is the current distance_from_edge
    tree[direction] = distance_from_edge
    tree
  else
    # Scan for the score - Just take the naive approach with a big ugly case statement since I kinda coded myself into
    # a corner here
    case direction
    when :left, :up
      update_direction_score(index, orthogonal_index, tree, direction)
    when :right
      update_direction_score(index, orthogonal_index, tree, direction, COLUMN_COUNT)
    when :down
      update_direction_score(index, orthogonal_index, tree, direction, ROW_COUNT)
    else
      raise 'Invalid direction'
    end
    current_tallest
  end
end

def update_direction_score(starting_index, orthogonal_index, tree, direction, stop_index = -1)
  invert = [:up, :down].include?(direction)
  step = [:left, :up].include?(direction) ? -1 : 1
  current_index = starting_index + step
  while current_index != stop_index && tree(orthogonal_index, current_index, invert)[:height] < tree[:height]
    tree[direction] += 1
    current_index += step
  end
  tree[direction] += 1 if tree(orthogonal_index, current_index, invert)[:height] == tree[:height]
end

def tree(x, y, invert)
  invert ? tree_grid[y][x] : tree_grid[x][y]
end

# I really feel like there's a more elegant way to do this that's just as performant,
# but this'll do.
up_tallest = Array.new(COLUMN_COUNT)
down_tallest = Array.new(COLUMN_COUNT)
tree_grid.each.with_index do |row, x|
  left_tallest = nil
  right_tallest = nil
  row.each.with_index do |tree, y|
    # Traverse all 4 directions in one pass
    # Horizontal
    left_tallest = update_tree_visibility(tree, left_tallest, :left, y, x)
    horizontal_opposite_index = COLUMN_COUNT - y - 1
    horizontal_opposite = row[horizontal_opposite_index]
    right_tallest = update_tree_visibility(horizontal_opposite, right_tallest, :right, horizontal_opposite_index, x, y)
    
    # Vertical
    up_tallest[y] = update_tree_visibility(tree, up_tallest[y], :up, x, y)
    vertical_opposite_index = ROW_COUNT - x - 1
    vertical_opposite = tree_grid[vertical_opposite_index][y]
    down_tallest[y] = update_tree_visibility(vertical_opposite, down_tallest[y], :down, vertical_opposite_index, y, x)
  end
end

puts 'Part 1:'
puts tree_grid.sum { |row| row.sum { |tree| tree[:visible] ? 1 : 0 } }
puts 'Part 2:'
puts tree_grid.map { |row| row.map { |tree| tree.slice(:up, :down, :left, :right).values.reduce(:*) }.max }.max
