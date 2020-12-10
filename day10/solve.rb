#! /usr/bin/env ruby
require "set"

module Solver
  def self.solve1(input)
    one = 0
    three = 0
    for i in 0..(input.length-2)
      diff = input[i+1] - input[i]
      one += 1 if diff == 1
      three += 1 if diff == 3
    end

    one * three
  end

  def self.solve2(input, counts, adapter)
    return 1 if adapter == 0
    return 0 if !input.include?(adapter)
    return counts[adapter] if counts[adapter]

    counts[adapter] = (1..3).sum do |i|
      solve2(input, counts, adapter - i)
    end
  end
end

input = File.readlines("input.txt", :chomp => true).map(&:to_i)
input << 0
input << input.max + 3
input = input.sort

puts Solver.solve1(input)
puts Solver.solve2(input, {}, input.last)
