NUMBERS = File.read('day9_input.txt').split.map(&:to_i)

# Part 1
test_num_idx = 0
test_num = 0
step = 25

(step...NUMBERS.size).each do |i|
  test_num_idx = i
  test_num = NUMBERS[i]
  
  candidates = NUMBERS[i - step...i]
  break if candidates.combination(2).find { |pair| pair.sum == test_num } == nil
end
puts "#{ test_num }"

# Part 2
# Brute force for looking for contiguous sum of test number.. Is there a better way?
def contiguous_sum(candidates, target)
  (2...candidates.size).each do |len|
    candidates.each_cons(len) { |cons| return cons if cons.sum == target }
  end
  
  nil
end

contiguous_numbers = contiguous_sum(NUMBERS[0...test_num_idx], test_num)
puts "#{ contiguous_numbers.min + contiguous_numbers.max }"
