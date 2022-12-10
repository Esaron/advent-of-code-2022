#!/usr/bin/env ruby

INPUT = 'input.txt'.freeze
LINES = File.readlines(INPUT).freeze

class CommunicationDevice
  SCREEN_X = 40
  SCREEN_Y = 6

  def initialize
    @current_cycle = 0
    @x = 1
    @history = [@x]
    @screen = Screen.new(SCREEN_X, SCREEN_Y)
  end

  def signal_strength(cycle = @current_cycle + 1)
    @history[cycle - 1] * cycle
  end

  def render
    @screen.render
  end

  def noop
    tick
  end

  def addx(value)
    tick
    tick { @x += value.to_i }
  end

  private

  def tick
    update_screen
    yield if block_given?
    @history << @x
    @current_cycle += 1
  end

  def update_screen
    @screen.set(@current_cycle) if screen_lit?
  end

  def screen_lit?
    ((@x-1)..(@x+1)).include?(@current_cycle % SCREEN_X)
  end
end

class Screen
  LIT = '#'.freeze
  DARK = '.'.freeze

  def initialize(x, y)
    @x = x
    @y = y
    @pixels = Array.new(x * y) { DARK }
  end

  def render
    (0..@y).each { |y| puts @pixels[(y * @x)..((y + 1) * @x - 1)].join }
  end

  def set(index, lit = true)
    @pixels[index] = lit ? LIT : DARK
  end
end

device = CommunicationDevice.new
LINES.each { |command| device.send(*command.split) }

puts 'Part 1:'
puts [20, 60, 100, 140, 180, 220].sum { |cycle| device.signal_strength(cycle) }
puts 'Part2:'
device.render
