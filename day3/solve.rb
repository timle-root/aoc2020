#! /usr/bin/env ruby

module Solver
  def self.solve(input, stride_right, stride_down)
    tree = 0
    x_pos = 0
    width = input[0].strip.length
    input.each_with_index do |line, index|
      next if index % stride_down != 0
      tree += 1 if line[x_pos % width] == "#"
      x_pos += stride_right
    end

    return tree
  end
end

input = File.readlines('input.txt')

a = Solver.solve(input, 1, 1)
b = Solver.solve(input, 3, 1)
c = Solver.solve(input, 5, 1)
d = Solver.solve(input, 7, 1)
f = Solver.solve(input, 1, 2)

puts a * b * c * d * f
