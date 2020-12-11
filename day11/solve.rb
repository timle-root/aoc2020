#! /usr/bin/env ruby
require "set"

module Solver
  def self.solve(input)
    while true do
      next_seats = input.map(&:clone)
      input.each_with_index do |line, row|
        (0..line.length-1).each do |column|
          next_seats[row][column] = determine_seat2(input, row, column)
        end
      end

      return next_seats if next_seats == input
      input = next_seats
    end

    return next_seats
  end

  def self.determine_seat1(current_seats, row, column)
    current_seat = current_seats[row][column]
    return current_seat if current_seat == "."

    occupied_count = 0
    previous_row = row - 1
    next_row = row + 1

    (-1..1).each do |i|
      next if column+i < 0
      next if column+i >= current_seats[row].length

      if previous_row >= 0
        occupied_count += 1 if current_seats[previous_row][column+i] == "#"
      end

      if next_row < current_seats.length
        occupied_count += 1 if current_seats[next_row][column+i] == "#"
      end

      occupied_count += 1 if current_seats[row][column+i] == "#" && i != 0
    end

    return "#" if occupied_count == 0 && current_seat == "L"
    return "L" if occupied_count >= 4 && current_seat == "#"
    return current_seat
  end

  def self.determine_seat2(current_seats, row, column)
    current_seat = current_seats[row][column]
    return current_seat if current_seat == "."

    occupied_count = 0
    occupied_count += 1 if find_visible_seat(current_seats, row, column, -1, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, row, column, -1, 0) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, row, column, -1, 1) == "#"

    occupied_count += 1 if find_visible_seat(current_seats, row, column, 0, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, row, column, 0, 1) == "#"

    occupied_count += 1 if find_visible_seat(current_seats, row, column, 1, -1) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, row, column, 1, 0) == "#"
    occupied_count += 1 if find_visible_seat(current_seats, row, column, 1, 1) == "#"

    return "#" if occupied_count == 0 && current_seat == "L"
    return "L" if occupied_count >= 5 && current_seat == "#"
    return current_seat
  end

  def self.find_visible_seat(current_seats, row, column, row_itor, column_itor)
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
    if visible_seat == "."
      return find_visible_seat(current_seats, next_row, next_column, row_itor, column_itor)
    end

    return visible_seat
  end
end

input = File.readlines("input.txt", :chomp => true)
count = 0
Solver.solve(input).each do |line|
  count += line.count("#")
end

puts count
