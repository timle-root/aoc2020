#! /usr/bin/env ruby
require "set"

module Solver
  def self.solve(input, recursive, threshold)
    while true do
      next_seats = input.map(&:clone)
      input.each_with_index do |line, row|
        (0..line.length-1).each do |column|
          next_seats[row][column] = determine_seat(input, recursive, threshold, row, column)
        end
      end

      return next_seats if next_seats == input
      input = next_seats
    end

    return next_seats
  end

  def self.determine_seat(current_seats, recursive, threshold, row, column)
    current_seat = current_seats[row][column]
    return current_seat if current_seat == "."

    occupied_count = 0
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, -1, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, -1, 0) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, -1, 1) == "#"

    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, 0, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, 0, 1) == "#"

    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, 1, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, 1, 0) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, recursive, row, column, 1, 1) == "#"

    return "#" if occupied_count == 0 && current_seat == "L"
    return "L" if occupied_count >= threshold && current_seat == "#"
    return current_seat
  end

  def self.find_visible_seat(current_seats, recursive, row, column, row_itor, column_itor)
    next_row = row + row_itor
    next_column = column + column_itor

    if next_row < 0
      return "L"
    elsif next_row >= current_seats.length
      return "L"
    elsif next_column < 0
      return "L"
    elsif next_column >= current_seats[row].length
      return "L"
    end

    visible_seat = current_seats[next_row][next_column]
    if visible_seat == "." && recursive
      return find_visible_seat(current_seats, recursive, next_row, next_column, row_itor, column_itor)
    end

    return visible_seat
  end
end

input = File.readlines("input.txt", :chomp => true)
immediate_count = 0
Solver.solve(input, false, 4).each do |line|
  immediate_count += line.count("#")
end
puts immediate_count

los_count = 0
Solver.solve(input, true, 5).each do |line|
  los_count += line.count("#")
end
puts los_count
