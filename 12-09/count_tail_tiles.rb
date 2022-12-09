#!/usr/bin/env ruby

require 'matrix'
require 'set'

INPUT = 'input.txt'
LINES = File.readlines(INPUT)

KNOT_COUNT = 10

class Knot
  MOVES = {
    'R' => Vector[1, 0],
    'L' => Vector[-1, 0],
    'U' => Vector[0, 1],
    'D' => Vector[0, -1],
  }

  attr_reader :position, :visited

  def initialize(position: Vector[0,0])
    @position = position
    @visited = Set[position.dup]
  end

  def move(direction)
    @position += MOVES[direction]
  end

  def follow(other)
    relative_position = other.position - @position
    return if relative_position[0].abs <= 1 && relative_position[1].abs <= 1

    @position += relative_position.map { |it| it <=> 0 }
    @visited << @position.dup
  end
end

head = Knot.new
knots = Array.new(KNOT_COUNT - 1) { Knot.new }
LINES.each do |line|
  direction, spaces = line.split
  (1..spaces.to_i).each do
    head.move(direction)
    knots.reduce(head) do |memo, knot|
      knot.follow(memo)
      knot
    end
  end
end

puts knots.last.visited.size

