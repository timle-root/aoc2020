#! /usr/bin/env ruby

module Solver
  def self.solve1(input)
    count = 0
    bags = ["shiny gold bag"]
    i = 0
    groups = input.map { |line| line.split(" contain ") }

    while true
      groups.each do |group|
        if group[1].include?(bags[i])
          bags.append(group[0])
        end
      end

      i += 1
      break if i >= bags.count
    end

    bags.uniq.count - 1
  end

  def self.recurse(bag, groups, multiplier)
    if groups[bag] == "no other bag"
      return multiplier
    end

    result = multiplier
    bags = groups[bag].split(", ")
    bags.each do |count_bag|
      result += Solver.recurse(count_bag[2..], groups, count_bag.to_i * multiplier)
    end

    result
  end

  def self.solve2(input, start)
    groups = input.map { |line| line.split(" contain ") }.to_h

    Solver.recurse(start, groups, 1) - 1
  end
end

input = File.read("input.txt").gsub("bags", "bag").tr(".", "").split("\n")

puts Solver.solve1(input)
puts Solver.solve2(input, "shiny gold bag")
