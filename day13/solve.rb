#! /usr/bin/env ruby

module Solver
  def self.solve_wait(timestamp, buses)
    shortest_wait = timestamp
    earliest_bus = 0

    buses.each do |bus|
      time = (timestamp / bus) * bus
      if time == 0
        lowest = 0
        break
      end

      wait = time + bus - timestamp
      if wait < shortest_wait
        shortest_wait = wait
        earliest_bus = bus
      end
    end

    return shortest_wait * earliest_bus
  end

  def self.solve_schedule(schedule)
    buses = schedule.reject{|e| e==0 }.sort
    total_buses = buses.count

    current_index = 0
    interval = buses[current_index]
    current_offset = schedule.index(interval)
    if current_offset > interval
      time = interval - (current_offset % interval)
    else
      time = interval - current_offset
    end

    while true
      bus = buses[current_index+1]
      bus_offset = schedule.index(bus)
      if bus_offset > bus
        bus_offset = bus_offset % bus
      end

      if (bus - (time % bus) == bus_offset && bus_offset != 0) || (time % bus == bus_offset && bus_offset == 0)
        interval = interval * bus
        current_index += 1
      end

      return time if current_index == total_buses - 1
      time += interval
    end
  end
end

input = File.readlines("input.txt", :chomp => true)

schedule = input[1].split(",").map(&:to_i)

puts Solver.solve_wait(input[0].to_i , schedule.reject{|e| e==0 })
puts Solver.solve_schedule(schedule)
