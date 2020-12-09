#! /usr/bin/env ruby

module Solver
  def self.solve1(input, preamble_length)
    preamble = []

    for i in preamble_length..input.length
      preamble = input[i-preamble_length, preamble_length]
      valid = false
      for x in 0...preamble.length
        for y in 0...preamble.length
          next if y == x
          valid = true if preamble[x] + preamble[y] == input[i]
          break if valid
        end
        break if valid
      end

      return input[i] if !valid
    end
  end

  def self.solve2(input, weakness, length)
    for i in 0..(input.length - length)
      range = input[i, length]
      return range if input[i, length].sum == weakness
    end

    solve2(input, weakness, length+1)
  end
end

input = File.readlines("input.txt", :chomp => true).map(&:to_i)

weakness = Solver.solve1(input, 25)
puts weakness
range = Solver.solve2(input, weakness, 2)
puts range.max + range.min
