#! /usr/bin/env ruby

module Solver
  HEADINGS = { 0 => "E", 90 => "S", 180 => "W", 270 => "N" }

  def self.solve_ship(input, heading)
    east = 0
    north = 0

    input.each do |line|
      command = line[0]
      value = line[1..].to_i
      command = HEADINGS[heading] if command == "F"

      if command == "L"
        command = "R"
        value = 360 - value
      end

      case command
      when "N"
        north += value
      when "S"
        north -= value
      when "E"
        east += value
      when "W"
        east -= value
      when "R"
        heading += value
        heading = heading - 360 if heading >= 360
      end
    end

    east.abs + north.abs
  end

  def self.solve_waypoint(input, waypoint_east, waypoint_north)
    east = 0
    north = 0

    input.each do |line|
      command = line[0]
      value = line[1..].to_i

      if command == "L"
        command = "R"
        value = 360 - value
      end

      case command
      when "N"
        waypoint_north += value
      when "S"
        waypoint_north -= value
      when "E"
        waypoint_east += value
      when "W"
        waypoint_east -= value
      when "R"
        temp = waypoint_east
        waypoint_east = waypoint_north if value == 90
        waypoint_east = 0 - waypoint_north if value == 270
        waypoint_east = 0 - waypoint_east if value == 180

        waypoint_north = 0 - temp if value == 90
        waypoint_north = temp if value == 270
        waypoint_north = 0 - waypoint_north if value == 180
      when "F"
        east += waypoint_east * value
        north += waypoint_north * value
      end
    end

    east.abs + north.abs
  end
end

input = File.readlines("input.txt", :chomp => true)

puts Solver.solve_ship(input, 0)
puts Solver.solve_waypoint(input, 10, 1)
