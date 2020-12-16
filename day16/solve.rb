#! /usr/bin/env ruby

module Solver
  def self.find_invalid_sections(rules, nearby_tickets)
    invalid_ticket_sections = []

    nearby_tickets.each do |ticket|
      sections = ticket.split(",").map(&:to_i)
      sections.each do |section|
        valid = false
        rules.each do |key, value|
          next if valid
          value.each do |range|
            next if valid
            valid = range.cover?(section)
          end
        end
        invalid_ticket_sections << section if !valid
      end
    end

    invalid_ticket_sections
  end

  def self.find_valid_tickets(rules, nearby_tickets)
    valid_tickets = []

    nearby_tickets.each do |ticket|
      invalid_ticket_sections = []
      sections = ticket.split(",").map(&:to_i)
      sections.each do |section|
        valid = false
        rules.each do |key, value|
          next if valid
          value.each do |range|
            next if valid
            valid = range.cover?(section)
          end
        end
        invalid_ticket_sections << section if !valid
      end

      valid_tickets << ticket if invalid_ticket_sections.length == 0
    end

    valid_tickets
  end

  def self.valid_indexes(rule, valid_tickets)
    index_match_count = Array.new(valid_tickets.first.split(",").count, 0)

    valid_tickets.each do |ticket|
      sections = ticket.split(",").map(&:to_i)
      sections.each_with_index do |section, index|
        rule.each do |range|
          if range.cover?(section)
            index_match_count[index] += 1
            break
          end
        end
      end
    end

    index_match_count.map { |count| count == valid_tickets.length ? 1 : 0 }
  end
end

input = File.readlines("input.txt", :chomp => true)

raw_rules = input[0,input.index("your ticket:")-1]
my_ticket = input[input.index("your ticket:")+1,1][0]
nearby_tickets = input[input.index("nearby tickets:")+1..]

rules = raw_rules.reduce({}) do |map, rule|
  key, value = rule.split(": ")
  ranges = value.split(" or ").map do |range|
    limits = range.split("-").map(&:to_i)
    Range.new(limits[0], limits[1])
  end
  map[key] = ranges
  map
end

valid_tickets = Solver.find_valid_tickets(rules, nearby_tickets)
rules_sections = rules.map { |k,v| [k, Solver.valid_indexes(v, valid_tickets)] }
sorted_rules_sections = rules_sections.sort_by { |valid_sections| valid_sections[1].sum }

sorted_rules_sections.each do |rule_section|
  raise if rule_section[1].sum != 1
  section_index = rule_section[1].index(1)

  sorted_rules_sections.each do |srs|
    next if srs[0] == rule_section[0]
    srs[1][section_index] = 0
  end
end

result = 1
my_ticket_sections = my_ticket.split(",").map(&:to_i)
sorted_rules_sections.each do |rule_section|
  next unless rule_section[0].start_with?("departure")
  result *= my_ticket_sections[rule_section[1].index(1)]
end

puts Solver.find_invalid_sections(rules, nearby_tickets).sum
puts result
