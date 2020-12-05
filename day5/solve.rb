#! /usr/bin/env ruby

module Solver
  def self.bsp(bsp, bsp_max, lower_delim, upper_delim)
    lower = 0
    upper = bsp_max
    for i in 0...bsp.length
      delta = (upper - lower + 1) / 2
      lower += delta if bsp[i] == upper_delim
      upper -= delta if bsp[i] == lower_delim
    end
    return upper
  end

  def self.solve(input)
    seat_ids = []
    input.each do |line|
      row = Solver.bsp(line[0,7], 127, "F", "B")
      seat = Solver.bsp(line[7,3], 7, "L", "R")
      seat_ids << (row * 8) + seat
    end

    seat_ids = seat_ids.sort

    for i in 0...(seat_ids.length-1)
      if seat_ids[i+1] - seat_ids[i] != 1
        return [seat_ids.last, seat_ids[i] + 1]
      end
    end
  end
end

input = File.readlines('input.txt')

puts Solver.solve(input)
