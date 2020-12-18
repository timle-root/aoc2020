#! /usr/bin/env ruby

module Solver
  OPERATOR_PREF_ADD_FIRST = [["+"], ["*"]]
  OPERATOR_PREF_LEFT_TO_RIGHT = [["+", "*"]]
  OPERATOR_PREF_MULTI_FIRST = [["*"], ["+"]]

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

    collector.call(collect[lopen])
  end

  def self.collect_with_precedence(sub_expression, preference)
    reduce = []
    
    lop = 0
    preference.each do |operators|
      lop = sub_expression[0].to_i
      (1..sub_expression.count - 1).step(2) do |n|
        if operators.include?(sub_expression[n])
          lop = lop.method(sub_expression[n]).(sub_expression[n+1].to_i)
        else
          reduce << lop
          reduce << sub_expression[n]
          lop = sub_expression[n+1].to_i
        end
      end

      reduce << lop
      sub_expression = reduce
    end

    lop
  end
end

input = File.readlines("input.txt", :chomp => true)

puts input.sum { |e| Solver.solve(e.tr(" ", ""), Proc.new {|x| Solver.collect_with_precedence(x, Solver::OPERATOR_PREF_LEFT_TO_RIGHT) }) }
puts input.sum { |e| Solver.solve(e.tr(" ", ""), Proc.new {|x| Solver.collect_with_precedence(x, Solver::OPERATOR_PREF_ADD_FIRST) }) }
puts input.sum { |e| Solver.solve(e.tr(" ", ""), Proc.new {|x| Solver.collect_with_precedence(x, Solver::OPERATOR_PREF_MULTI_FIRST) }) }