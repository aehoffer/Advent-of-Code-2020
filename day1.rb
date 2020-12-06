EXPENSES = File.read('day1_input.txt').split.map(&:to_i)

def combination_sum(n, target)
  EXPENSES.combination(n).to_a.select { |c| c.reduce(:+) == target }.first.reduce(:*)
end

# Part 1
puts "#{ combination_sum(2, 2020) }"

# Part 2
puts "#{ combination_sum(3, 2020) }"
