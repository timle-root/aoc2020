#! /usr/bin/env ruby

module Solver
  def self.read(file)
    input = File.readlines(file, :chomp => true)

    split = input.index("")
    rules = input[0, split]
    messages = input[split+1..]

    return rules, messages
  end

  def self.process_rules(rules)
    map = {}
    rules.each do |rule|
      key, value = rule.split(": ")
      value = value.tr("\"", "")
      map[key] = value
    end

    "^" + compose_regex(map, map["0"]) + "$"
  end

  def self.compose_regex(rules, rule)
    return "" if caller.length > 44
    return "a" if rule == "a"
    return "b" if rule == "b"

    result = "("

    rule.split(" ").each do |step|
      result << "|" if step == "|"
      result << compose_regex(rules, rules[step]) if step != "|"
    end

    result << ")"
    result
  end
end

rules, messages = Solver.read("input.txt")
regex = Regexp.new(Solver.process_rules(rules))
puts messages.sum { |m| regex.match(m) ? 1 : 0}

rules, messages = Solver.read("input-loop.txt")
regex = Regexp.new(Solver.process_rules(rules))
puts messages.sum { |m| regex.match(m) ? 1 : 0}
