#!/usr/bin/env ruby

require 'byebug'

INPUT = 'input.txt'
FILE = File.readlines(INPUT)

COMMAND_REGEX = /^\$ (\w+)(?: (.+))?$/
SIZE_REGEX = /^\d+/
MAX_SIZE = 100_000

class MockConsole
  ROOT = '/'
  PARENT_DIRECTORY = '..'

  attr_accessor :pwd, :file_sizes

  def initialize(pwd = [])
    @pwd = pwd
    @file_sizes = {}
  end

  def cd(directory)
    return pwd.delete_at(-1) if directory == PARENT_DIRECTORY
    return directory.split(ROOT) if directory.start_with?(ROOT)

    pwd << "/#{directory}"
  end

  def record_file_size(file_size)
    pwd.reduce do |parent, directory|
      file_sizes[parent + directory] ||= 0
      file_sizes[parent + directory] += file_size
      parent + directory
    end
  end
end

console = MockConsole.new
directory_sizes = {}
FILE.each do |line|
  command, argument = line.match(COMMAND_REGEX)&.captures
  if command == 'cd'
    console.cd(argument)
  else
    # We can just ignore ls commands and sum the numbers based on the limited command set
    file_size = line.match(SIZE_REGEX)
    console.record_file_size(file_size[0].to_i) unless file_size.nil?
  end
end

puts console.file_sizes.values.sum { |size| size < MAX_SIZE ? size : 0 }

