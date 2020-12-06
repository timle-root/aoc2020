#! /usr/bin/env ruby

module Solver
  def self.solve_anyone(input)
    input.map { |group| group.tr("\n", "").split("").uniq }.sum { |e| e.count }
  end

  def self.solve_everyone(input)
    input.map { |group| group.split("\n").map { |ans| ans.split("") } }.sum { |ans| ans.reduce { |i, e| i & e }.count }
  end
end

input = File.read("input.txt").split("\n\n")

puts Solver.solve_anyone(input)
puts Solver.solve_everyone(input)
