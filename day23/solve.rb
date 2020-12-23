#! /usr/bin/env ruby

module Cups
  Cup = Struct.new(:value, :prev, :next)

  def self.play(cups, rounds, max)
    max_cup_value = max

    all_cups = Array.new(max_cup_value+1)
    current_cup = Cup.new(cups[0], nil, nil)
    all_cups[cups[0]] = current_cup

    previous_cup = current_cup
    (1...cups.count).each do |i|
      cup = Cup.new(cups[i], previous_cup, nil)
      all_cups[cups[i]] = cup
      previous_cup.next = cup
      previous_cup = cup
    end

    (cups.max+1..max).each do |i|
      cup = Cup.new(i, previous_cup, nil)
      all_cups[i] = cup
      previous_cup.next = cup
      previous_cup = cup
    end

    previous_cup.next = current_cup
    current_cup.prev = previous_cup

    (0...rounds).each do |i|
      start_pickup_cup = current_cup.next
      middle_pickup_cup = start_pickup_cup.next
      end_pickup_cup = middle_pickup_cup.next
      after_pickup_cup = end_pickup_cup.next

      #Remove cups
      current_cup.next = after_pickup_cup
      after_pickup_cup.prev = current_cup

      #Select destination cup
      destination_cup_value = current_cup.value - 1
      destination_cup_value = max_cup_value if destination_cup_value == 0
        
      while destination_cup_value == start_pickup_cup.value || destination_cup_value == middle_pickup_cup.value || destination_cup_value == end_pickup_cup.value
        destination_cup_value -= 1
        destination_cup_value = max_cup_value if destination_cup_value == 0
      end

      #Place cups
      destination_cup = all_cups[destination_cup_value]
      after_destination_cup = destination_cup.next
      
      destination_cup.next = start_pickup_cup
      start_pickup_cup.prev = destination_cup

      after_destination_cup.prev = end_pickup_cup
      end_pickup_cup.next = after_destination_cup

      current_cup = current_cup.next
    end

    all_cups[1]
  end
end

#cups = [3,8,9,1,2,5,4,6,7]
cups = [1,5,7,6,2,3,9,8,4]

puts "--- Part 1 ---"

one_cup = Cups.play(cups, 100, cups.max)
current_cup = one_cup.next
(0...cups.count-1).each do |i|
  print current_cup.value
  current_cup = current_cup.next
end

puts ""
puts "--- Part 2 ---"

one_cup = Cups.play(cups, 10000000, 1000000)
current_cup = one_cup.next
value = 1
(0...2).each do
  value *= current_cup.value
  current_cup = current_cup.next
end

puts value
