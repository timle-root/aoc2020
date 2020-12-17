#! /usr/bin/env ruby

module Solver
  def self.solve(input, cycles)
    pocket_dimension = Hash.new(".")

    max_z = 0
    max_w = 0
    max_y = input.length - 1
    max_x = input[0].length - 1

    input.each_with_index do |line, y|
      line.each_char.with_index do |char, x|
        pocket_dimension[[x,y,max_z,max_w]] = char
      end
    end


    for i in 1..cycles
      max_w += 1
      max_z += 1
      max_y += 1
      max_x += 1

      new_pocket_dimension = pocket_dimension.clone

      for w in 0-i..max_w
        for z in 0-i..max_z
          for y in 0-i..max_y
            for x in 0-i..max_x
              key = [x,y,z,w]
              value = pocket_dimension[key]

              active_neighbors = 0

              for delta_w in -1..1
                for delta_z in -1..1
                  for delta_y in -1..1
                    for delta_x in -1..1
                      next if delta_x == 0 && delta_y == 0 && delta_z == 0 && delta_w == 0
                      active_neighbors +=1 if pocket_dimension[[key[0]+delta_x, key[1]+delta_y, key[2]+delta_z, key[3]+delta_w]] == "#"
                    end
                  end
                end
              end
      
              if value == "#"
                new_pocket_dimension[key] = (active_neighbors == 2 || active_neighbors == 3) ? "#" : "."
              else
                new_pocket_dimension[key] = active_neighbors == 3 ? "#" : "."
              end
            end
          end
        end
      end

      pocket_dimension = new_pocket_dimension
    end

    pocket_dimension
  end
end

input = File.readlines("input.txt", :chomp => true)

pp Solver.solve(input, 6).select { |k, v| v == "#" }.count