#!/usr/bin/env ruby

INPUT = 'input.txt'

def priority(chr)
  chr == chr.upcase ? chr.ord - 38 : chr.ord - 96
end

total = File.readlines(INPUT).sum(0) do |line|
  first_compartment = line.chars
  second_compartment = first_compartment.slice!(..(first_compartment.length/2 - 1))
  priority(first_compartment.intersection(second_compartment).first)
end
puts total
