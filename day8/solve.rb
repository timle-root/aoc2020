#! /usr/bin/env ruby

module Solver
  def self.solve(input, fix)
    index = 0
    attempt = 0
    encounter = 0
    acc = 0
    visited = []

    while true
      if visited.include?(index)
        if fix
          attempt += 1
          index = 0
          acc = 0
          encounter = 0
          visited = []
        else
          return acc
        end
      end
      if index == input.length
        return acc
      end
      (instruction, value) = input[index].split(" ")
      visited.append(index)
      case instruction
      when "acc"
        acc += value.to_i
        index += 1
      when "jmp"
        if fix && encounter == attempt
          index += 1
        else
          index += value.to_i
        end
        encounter += 1
      when "nop"
        if fix && encounter == attempt
          index += value.to_i
        else
          index += 1
        end
        encounter += 1
      end
    end
  end
end

input = File.readlines("input.txt", :chomp => true)

puts Solver.solve(input, false)
puts Solver.solve(input, true)
