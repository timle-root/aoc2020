#! /usr/bin/env ruby

module Solver
  def self.find_loop_size(public_key, subject_number, divisor)
    result = 1
    loop_size = 0
    while result != public_key
      loop_size += 1
      result = (result * subject_number) % divisor
    end

    loop_size
  end

  def self.find_encryption_key(subject_number, loop_size, divisor)
    subject_number.pow(loop_size, divisor)
  end
end

divisor = 20201227
subject_number = 7
card_public_key = 9033205
door_public_key = 9281649

card_loop = Solver.find_loop_size(card_public_key, subject_number, divisor)
door_loop = Solver.find_loop_size(door_public_key, subject_number, divisor)

puts card_loop
puts door_loop
puts Solver.find_encryption_key(card_public_key, door_loop, divisor)
puts Solver.find_encryption_key(door_public_key, card_loop, divisor)
