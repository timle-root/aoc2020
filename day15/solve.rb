#! /usr/bin/env ruby

module Solver
  def self.solve(input, last_turn)
    spoken = {}

    input.each_with_index do |number, index|
      spoken[number] = [index + 1]
    end

    prior_number = input.last
    for turn in (input.length + 1)..last_turn
      turns_spoken = spoken[prior_number]
      times_spoken = turns_spoken.length
      prior_number = times_spoken == 1 ? 0 : turns_spoken[times_spoken-1] - turns_spoken[times_spoken-2]

      spoken[prior_number] = [] if spoken[prior_number] == nil
      spoken[prior_number] << turn
    end

    prior_number
  end
end

input = File.readlines("input.txt", :chomp => true)[0].split(",").map(&:to_i)

puts Solver.solve(input, 2020)
puts Solver.solve(input, 30000000)
