#!/usr/bin/env ruby

INPUT = 'input.txt'

def priority(chr)
  chr == chr.upcase ? chr.ord - 38 : chr.ord - 96
end

total = File.readlines(INPUT).each_slice(3).sum do |group|
  common_item = group.map(&:chars).reduce { |common_items, rucksack| common_items.intersection(rucksack) }.first
  priority(common_item)
end
puts total
