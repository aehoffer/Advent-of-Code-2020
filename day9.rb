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
# Naive brute force for looking for contiguous sum of test number in O(n^3) time.
def contiguous_sum(candidates, target)
  (2...candidates.size).each do |len|
    candidates.each_cons(len) { |cons| return cons if cons.sum == target }
  end
  
  []
end

# Dynamic programming approach. Use all prefix sums of candidates(0...candidates.size)
# to compute arbitrary contiguous size in O(n^2) time until we find the target.
def contiguous_sum_smart(candidates, target)  
  # Prefix sums (i, j) = (offset, size - 1) 
  offset, size = 0, 0
  
  catch :Done do
    sum = 0
    (0...candidates.size).each do |i|
      sum = candidates[i]
      (i + 1...candidates.size).each do |j| 
        sum += candidates[j]
        if sum == target
          offset, size = i, j - i + 1
          throw :Done
        end
      end
    end
  end
  
  candidates[offset...offset + size]
end

# Simplest, smartest approach: Since numbes are positive and generally increasing, add next candidate
# if less than target, otherwise subtract first candidate in current target.
def contiguous_sum_smartest(candidates, target)  
  tail, head = 0
  sum = candidates[0]
  
  while tail <= head && tail < candidates.length do
    break if sum == target
  
    if head == candidates.size
	  sum -= candidates[tail]
      tail += 1
    elsif sum < target
	  head += 1
	  sum += candidates[head]
	elsif sum > target
	  sum -= candidates[tail]
	  tail += 1
	end
  end
  
  candidates[tail...head]
end

contiguous_numbers = contiguous_sum_smart(NUMBERS[0...test_num_idx], test_num)
puts "#{ contiguous_numbers.min + contiguous_numbers.max }" unless contiguous_numbers.empty?
