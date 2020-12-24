#! /usr/bin/env ruby

module Solver
  Position = Struct.new(:x, :y, :z) do
    def neighbors
      n = []

      DIRECTIONS.each do |dir, command|
        nx, ny, nz = command.call(self.x, self.y, self.z)
        n << Position.new(nx, ny, nz)
      end

      n
    end
  end

  DIRECTIONS = {
    "ne" => ->(x,y,z) { return x+1, y,   z-1 },
    "e"  => ->(x,y,z) { return x+1, y-1, z },
    "se" => ->(x,y,z) { return x,   y-1, z+1 },
    "sw" => ->(x,y,z) { return x-1, y,   z+1 },
    "w"  => ->(x,y,z) { return x-1, y+1, z },
    "nw" => ->(x,y,z) { return x,   y+1, z-1 },
  }

  def self.initial_floor_layout(input)
    tiles = {}

    input.each do |directions|
      offset = 0
      position = Position.new(0, 0, 0)
      while true
        break if directions[offset] == "\n"

        step = directions[offset]
        if step == "s" || step == "n"
          step << directions[offset+1]
          offset += 1
        end
        offset += 1

        position = Position.new(*DIRECTIONS[step].call(position.x, position.y, position.z))
      end
      tiles[position] = 1 unless tiles.delete(position)
    end

    tiles
  end

  def self.evolve_floor(tiles, times)
    (0...times).each do |round|
      new_layout = tiles.clone

      all_off_neighbors = Hash.new(0)
      tiles.each do |tile, value|
        neighbors = tile.neighbors
        on_neighbors = neighbors.reduce(0) { |acc, n| acc += 1 if tiles[n]; acc }
        new_layout.delete(tile) if on_neighbors == 0 || on_neighbors > 2

        neighbors.reject { |n| tiles[n] }.each do |n|
          all_off_neighbors[n] = all_off_neighbors[n] + 1
        end
      end

      all_off_neighbors.select { |n, v| v == 2 }.each do |k,v|
        new_layout[k] = v
      end

      tiles = new_layout
    end

    tiles
  end
end

input = File.readlines("input.txt")
tiles = Solver.initial_floor_layout(input)
puts tiles.count

tiles = Solver.evolve_floor(tiles, 100)
puts tiles.count
