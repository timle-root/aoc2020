#! /usr/bin/env ruby

module Solver
  def self.valid(limits, char, password)
      min, max = limits.split("-").map(&:to_i)
      count = password.count(char)
      return count >= min && count <= max
  end

  def self.tob_valid(limits, char, password)
    first_pos, second_pos = limits.split("-").map(&:to_i)
    first_test = password[first_pos-1]
    second_test = password[second_pos-1]
    return (first_test == char) ^ (second_test == char)
  end
end

input = File.readlines('input.txt').map { |line| line.split(" ") }

puts input.reduce(0) { |value, test| Solver.valid(test[0], test[1].chomp(":"), test[2]) ? value + 1 : value }
puts input.reduce(0) { |value, test| Solver.tob_valid(test[0], test[1].chomp(":"), test[2]) ? value + 1 : value }
