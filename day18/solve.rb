#! /usr/bin/env ruby

module Solver
  def self.solve(expression, collector)
    collect = [[]]
    collect[0] = []
    lopen = 0
    expression.each_char do |char|
      if char == "("
        lopen += 1
        collect[lopen] = []
      elsif char == ")"
        result = collector.call(collect[lopen])
        lopen -= 1
        collect[lopen] << result
      else
        collect[lopen] << char
      end
    end

    collector.call(collect[0])
  end

  def self.process_left_to_right(sub_expression)
    lop = sub_expression[0].to_i

    (1..sub_expression.count - 1).step(2) do |n|
      lop *= sub_expression[n+1].to_i if sub_expression[n] == "*"
      lop += sub_expression[n+1].to_i if sub_expression[n] == "+"
    end

    lop
  end

  def self.process_add_first(sub_expression)
    reduce = []
    lop = sub_expression[0].to_i

    (1..sub_expression.count - 1).step(2) do |n|
      lop += sub_expression[n+1].to_i if sub_expression[n] == "+"
      if sub_expression[n] == "*"
        reduce << lop
        reduce << sub_expression[n]
        lop = sub_expression[n+1].to_i
      end
    end

    reduce << lop
    process_left_to_right(reduce)
  end
end

input = File.readlines("input.txt", :chomp => true)

puts input.sum { |e| Solver.solve(e.tr(" ", ""), Proc.new {|x| Solver.process_left_to_right(x) }) }
puts input.sum { |e| Solver.solve(e.tr(" ", ""), Proc.new {|x| Solver.process_add_first(x) }) }