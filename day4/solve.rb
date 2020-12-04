#! /usr/bin/env ruby

module Solver
  def self.solve(input)
    valid1_count = 0
    valid2_count = 0
    fields = []
    validations_met = 0
    input.each do |line|
      if line == "\n"
        all = fields.join
        valid1 = false
        valid1 = true if fields.count == 8
        valid1 = true if fields.count == 7 && all !~ /cid/

        if valid1
          valid1_count += 1

          fields.each do |field|
            token, value = field.split(":")
            value = value.strip
            case token
            when "byr"
              validations_met += 1 if value.length == 4 && value.to_i >= 1920 && value.to_i <= 2002
            when "iyr"
              validations_met += 1 if value.length == 4 && value.to_i >= 2010 && value.to_i <= 2020
            when "eyr"
              validations_met += 1 if value.length == 4 && value.to_i >= 2020 && value.to_i <= 2030
            when "hgt"
              measure = value[-2..-1]
              validations_met += 1 if measure == "cm" && value.to_i >= 150 && value.to_i <= 193
              validations_met += 1 if measure == "in" && value.to_i >= 59 && value.to_i <= 76
            when "hcl"
              validations_met += 1 if value =~ /^#\h{6}$/
            when "ecl"
              validations_met += 1 if value =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/
            when "pid"
              validations_met += 1 if value =~ /^\d{9}$/
            end
          end

          valid2_count += 1 if validations_met == 7
          validations_met = 0
        end
        fields = []
        next
      end
      fields = fields + line.split(" ")
    end

    return [valid1_count, valid2_count]
  end
end

input = File.readlines('input.txt')

puts Solver.solve(input)
