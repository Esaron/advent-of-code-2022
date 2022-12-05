#!/usr/bin/env ruby

class Stacker
  STACK_REGEX = /(?:    |[A-Z])/
  COMMAND_REGEX = /move (\d+) from (\d+) to (\d+)/

  def initialize(input_file)
    @lines = File.readlines(input_file)
  end

  def stacks
    @stacks ||=
      begin
        stacks = []
        @lines.each do |line|
          layer = line.scan(STACK_REGEX)
          break if layer.empty?

          stacks << layer
        end
        stacks.reverse
      end
  end

  def formatted_stacks
    @formatted_stacks ||=
      begin
        formatted_stacks = []
        stacks.each do |layer|
          layer.each_with_index do |container, idx|
            formatted_stacks[idx] ||= []
            formatted_stacks[idx].push(container) unless container.strip.empty?
          end
        end
        formatted_stacks
      end
  end

  def rearrange
    @lines.drop(stacks.length + 2).each do |line|
      count, src, dest = line.match(COMMAND_REGEX).captures
      count.to_i.times do
        formatted_stacks[dest.to_i-1].push(formatted_stacks[src.to_i-1].pop)
      end
    end
  end

  def top_containers
    rearrange
    formatted_stacks.map(&:last)
  end
end

puts Stacker.new('input.txt').top_containers.join
