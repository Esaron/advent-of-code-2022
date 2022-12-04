#!/usr/bin/env ruby

INPUT = 'input.txt'
LINE_REGEX = /(\d+)-(\d+),(\d+)-(\d+)/

class Range
  def contains?(range)
    cover?(range.first) && cover?(range.last)
  end
end

count = File.readlines(INPUT).count do |line|
  elf1_start, elf1_end, elf2_start, elf2_end = line.match(LINE_REGEX).captures.map(&:to_i)
  elf1_sections = elf1_start..elf1_end
  elf2_sections = elf2_start..elf2_end
  elf1_sections.contains?(elf2_sections) || elf2_sections.contains?(elf1_sections)
end
puts count
