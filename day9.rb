NUMBERS = File.read('day9_input.txt').split.map(&:to_i)

# Part 1
test_num_idx = 0
test_num = 0
step = 25

(step...NUMBERS.size).each do |i|
  test_num_idx = i
  test_num = NUMBERS[i]
  
  candidates = NUMBERS[i - step...i]
  break if candidates.product(candidates).reject { |pair| pair[0] == pair[1] }.find { |pair| pair.sum == test_num } == nil
end
puts "#{ test_num }"

# Part 2
candidates = NUMBERS[0...test_num_idx]
contiguous_numbers = nil

# Brute force for looking for contiguous sum of test number.. Is there a better way?
catch :Done do
  (2...candidates.size).each do |len|
    (0...candidates.size).each do |i|
      contiguous_numbers = candidates[i...i + len]
      throw :Done if contiguous_numbers.sum == test_num
    end
  end
end
puts "#{ contiguous_numbers.min + contiguous_numbers.max }"
