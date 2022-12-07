#!/usr/bin/env ruby

INPUT = 'input.txt'
FILE = File.readlines(INPUT)

COMMAND_REGEX = /^\$ (\w+)(?: (.+))?$/
SIZE_REGEX = /^\d+/
MAX_SIZE = 100_000
TOTAL_SPACE = 70_000_000
REQUIRED_SPACE = 30_000_000

class MockConsole
  ROOT = '/'
  PARENT_DIRECTORY = '..'

  attr_accessor :pwd, :system_capacity, :file_sizes

  def initialize(pwd: [], system_capacity:)
    @pwd = pwd
    @system_capacity = system_capacity
    @file_sizes = {}
  end

  def cd(directory)
    return pwd.delete_at(-1) if directory == PARENT_DIRECTORY

    pwd << directory
  end

  def record_file_size(file_size)
    pwd.reduce('') do |parent, directory|
      absolute_path = directory == ROOT ? ROOT : "#{parent}/#{directory}"
      file_sizes[absolute_path] ||= 0
      file_sizes[absolute_path] += file_size.to_i
      absolute_path
    end
  end

  def available_space
    system_capacity - consumed_space
  end

  def consumed_space
    file_sizes[ROOT].to_i
  end
end

console = MockConsole.new(system_capacity: TOTAL_SPACE)
FILE.each do |line|
  command, argument = line.match(COMMAND_REGEX)&.captures
  if command == 'cd'
    console.cd(argument)
  else
    # We can just ignore ls commands and sum the numbers based on the limited command set
    file_size = line.match(SIZE_REGEX)
    console.record_file_size(file_size[0]) unless file_size.nil?
  end
end

# Part 1
puts "Part 1: #{console.file_sizes.values.sum { |size| size < MAX_SIZE ? size : 0 }}"
# Part 2
minimum_space_to_free_up = REQUIRED_SPACE - console.available_space
puts "Part 2: #{console.file_sizes.values.filter { |size| size > minimum_space_to_free_up }.min}"
