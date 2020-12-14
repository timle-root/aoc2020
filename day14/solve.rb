#! /usr/bin/env ruby

module Solver
  def self.solve_v1(input)
    mask = ""
    memory = {}

    input.each do |line|
      (command, value) = line.split(" = ")
      if command == "mask"
        mask = value
      else
        bvalue = "%036b" % value.to_i
        register = command.chomp("]")[4..]

        mask.each_char.with_index do |char, index|
          next if char == "X"
          bvalue[index] = char
        end
        memory[register] = bvalue
      end
    end

    memory
  end

  def self.solve_v2(input)
    memory = {}
    masks = []

    input.each do |line|
      (command, value) = line.split(" = ")
      if command == "mask"
        number_of_masks = 2 ** value.count("X")
        masks = Array.new(number_of_masks) {|i| value.clone }

        floating_seen = 0
        for i in 0..value.length - 1
          next if value[i] != "X"
          floating_seen += 1
          slice_size = number_of_masks / (2 ** floating_seen)

          masks.each_slice(slice_size).with_index do |slice, index|
            slice.each do |mask|
              mask[i] = (index % 2 == 0) ? "Y" : "Z"
            end
          end
        end
      else
        register = "%036b" % command.chomp("]")[4..]

        masks.each do |mask|
          decoded_register = register.clone
          mask.each_char.with_index do |char, index|
            decoded_register[index] = "1" if char == "1" || char == "Z"
            decoded_register[index] = "0" if char == "Y"
          end

          memory[decoded_register] = value.to_i
        end
      end
    end
    memory
  end
end

input = File.readlines("input.txt", :chomp => true)

puts Solver.solve_v1(input).values.reduce(0) { |sum, register| sum + register.to_i(2) }
puts Solver.solve_v2(input).values.sum
