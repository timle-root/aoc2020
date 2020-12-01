#! /usr/bin/env ruby

module Solver
  def self.solve(input:, combine_count:)
    combinations = input.combination(combine_count)

    combinations.each do |combo|
      if combo.reduce(0, :+) == 2020
        return combo.reduce(:*)
      end
    end
  end
end

input = Array.new
File.readlines('input.txt').each do |line|
  input << line.to_i
end

puts Solver.solve(:input => input, :combine_count => 2)
puts Solver.solve(:input => input, :combine_count => 3)
