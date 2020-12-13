#! /usr/bin/env ruby

HEADINGS = { 0 => "E", 90 => "S", 180 => "W", 270 => "N" }

ROTATIONS = {
  0   => ->(ship) { },
  90  => ->(ship) { ship.update_waypoints(ship.waypoint_north, -ship.waypoint_east) },
  180 => ->(ship) { ship.update_waypoints(-ship.waypoint_east, -ship.waypoint_north) },
  270 => ->(ship) { ship.update_waypoints(-ship.waypoint_north, ship.waypoint_east) }
}

HEADING_COMMANDS = {
  "N" => ->(ship, value) { ship.north += value },
  "E" => ->(ship, value) { ship.east += value },
  "S" => ->(ship, value) { ship.north -= value },
  "W" => ->(ship, value) { ship.east -= value },
  "F" => ->(ship, value) { HEADING_COMMANDS[HEADINGS[ship.heading]].call(ship, value) },
  "R" => ->(ship, value) { ship.heading += value; ship.heading -= 360 if ship.heading >= 360 },
  "L" => ->(ship, value) { HEADING_COMMANDS["R"].call(ship, 360 - value) },
}

WAYPOINT_COMMANDS = {
  "N" => ->(ship, value) { ship.waypoint_north += value },
  "E" => ->(ship, value) { ship.waypoint_east += value },
  "S" => ->(ship, value) { ship.waypoint_north -= value },
  "W" => ->(ship, value) { ship.waypoint_east -= value },
  "F" => ->(ship, value) { ship.east += ship.waypoint_east * value; ship.north += ship.waypoint_north * value },
  "R" => ->(ship, value) { ROTATIONS[value].call(ship) },
  "L" => ->(ship, value) { WAYPOINT_COMMANDS["R"].call(ship, 360 - value) },
}

input = File.readlines("input.txt", :chomp => true)
solve = ->(commands, ship) { input.reduce(ship) { |ship, line| commands[line[0]].call(ship, line[1..].to_i); ship } }

Ship = Struct.new(:heading, :waypoint_east, :waypoint_north, :east, :north) do
  def manhattan_distance
    east.abs + north.abs
  end

  def update_waypoints(we, wn)
    self.waypoint_east = we
    self.waypoint_north = wn
  end
end

puts solve.call(HEADING_COMMANDS, Ship.new(0, 0, 0, 0, 0)).manhattan_distance
puts solve.call(WAYPOINT_COMMANDS, Ship.new(0, 10, 1, 0, 0)).manhattan_distance