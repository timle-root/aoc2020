#! /usr/bin/env ruby
require "set"

module Solver
  def self.solve(input)
    allergens = {}
    ingredients = {}

    input.each do |food|
      ingredients_list, allergens_list = food.split(" (contains ")
      fingredients = ingredients_list.split(" ")
      fallergens = allergens_list.chomp(")").split(", ")
      
      fallergens.each do |fa|
        allergens[fa] ||= Set.new(fingredients)
        allergens[fa] &= Set.new(fingredients)
      end

      fingredients.each do |fi|
        ingredients[fi] ||= 0
        ingredients[fi] += 1
      end
    end

    safe_ingredients = Set.new(ingredients.keys)
    allergens.each do |k, v|
      safe_ingredients = safe_ingredients - v
    end

    safe_occurances = safe_ingredients.reduce(0) { |acc, i| acc + ingredients[i] }

    unsolved_allergens = allergens.keys.sort_by { |a| allergens[a].count }
    while true
      unsolved_allergens.each do |a|
        if allergens[a].count == 1
          unsolved_allergens.delete(a)
          allergens.each do |k, v|
            next if k == a
            allergens[k] = v - allergens[a]
          end
        end
      end
      break if unsolved_allergens.count == 0
    end
    
    danger_list = allergens.keys.sort.map { |k| allergens[k].first }.join(",")
    
    return safe_occurances, danger_list
  end
end

input = File.readlines("input.txt", :chomp => true)
puts Solver.solve(input)
