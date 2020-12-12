#! /usr/bin/env ruby

HEADINGS = { 0 => "E", 90 => "S", 180 => "W", 270 => "N" }

ROTATIONS = {
  0   => ->(we, wn, e, n) { return  we,  wn, e, n },
  90  => ->(we, wn, e, n) { return  wn, -we, e, n },
  180 => ->(we, wn, e, n) { return -we, -wn, e, n },
  270 => ->(we, wn, e, n) { return -wn,  we, e, n }
}

HEADING_COMMANDS = {
  "N" => ->(we, wn, value, e, n) { return we, wn, e, n + value },
  "E" => ->(we, wn, value, e, n) { return we, wn, e + value, n },
  "S" => ->(we, wn, value, e, n) { return we, wn, e, n - value },
  "W" => ->(we, wn, value, e, n) { return we, wn, e - value, n },
  "F" => ->(we, wn, value, e, n) { return HEADING_COMMANDS[HEADINGS[we]].call(we, wn, value, e, n) },
  "R" => ->(we, wn, value, e, n) { return (we + value >= 360 ? we + value - 360 : we + value), wn , e, n },
  "L" => ->(we, wn, value, e, n) { return HEADING_COMMANDS["R"].call(we, wn, 360 - value, e, n) },
}

WAYPOINT_COMMANDS = {
  "N" => ->(we, wn, value, e, n) { return we, wn + value, e, n },
  "E" => ->(we, wn, value, e, n) { return we + value, wn, e, n },
  "S" => ->(we, wn, value, e, n) { return we, wn - value, e, n },
  "W" => ->(we, wn, value, e, n) { return we - value, wn, e, n },
  "F" => ->(we, wn, value, e, n) { return we, wn, (e + (we * value)), (n + (wn * value)) },
  "R" => ->(we, wn, value, e, n) { return ROTATIONS[value].call(we, wn, e, n) },
  "L" => ->(we, wn, value, e, n) { return WAYPOINT_COMMANDS["R"].call(we, wn, 360 - value, e, n) },
}

input = File.readlines("input.txt", :chomp => true)

solve = ->(data, commands, values) { data.reduce(values) { |values, line| values = commands[line[0]].call(values[0], values[1], line[1..].to_i, values[2], values[3]) }[2, 2].sum {|e| e.abs} }

puts solve.call(input, HEADING_COMMANDS, [0, 0, 0, 0])
puts solve.call(input, WAYPOINT_COMMANDS, [0, 0, 10, 1])
