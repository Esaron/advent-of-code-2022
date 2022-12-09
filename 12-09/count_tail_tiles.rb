#!/usr/bin/env ruby

require 'matrix'
require 'set'

INPUT = 'input.txt'
LINES = File.readlines(INPUT)

class Knot
  MOVES = {
    'R' => Vector[1, 0],
    'L' => Vector[-1, 0],
    'U' => Vector[0, 1],
    'D' => Vector[0, -1],
  }

  attr_accessor :position, :visited, :previous_position

  def initialize(position: Vector[0,0])
    @position = position
    @visited = Set[position.dup]
  end

  def move(direction)
    self.previous_position = self.position
    self.position += MOVES[direction]
  end

  def follow(other)
    relative_position = other.position - self.position
    return if relative_position[0].abs <= 1 && relative_position[1].abs <= 1

    self.position = other.previous_position.dup
    self.visited << self.position.dup
  end
end

head = Knot.new
tail = Knot.new
LINES.each do |line|
  direction, spaces = line.split
  (1..spaces.to_i).each do
    head.move(direction)
    tail.follow(head)
  end
end

puts tail.visited.size

