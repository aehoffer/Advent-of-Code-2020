adapters = File.readlines("day10_input.txt").map(&:to_i).sort
adapters.unshift(0).append(adapters[-1] + 3)

puts "adapters: #{adapters.length}"
differences = [ nil, [], [], [] ]
jolts = adapters[0]
idx = 1

# Part 1
loop do
  break if idx >= adapters.size
  
  (idx...adapters.size).each do |i|
    if adapters[i].between?(jolts, jolts + 3)
      idx = i
      break
    end
  end
  
  differences[adapters[idx] - jolts].append(adapters[idx])
  jolts = adapters[idx]
  
  idx += 1
end
puts "#{ differences[1].size * differences[3].size }"

# Part 2
def total_adapter_lens(adapters)
  adapter_cache = {}

  adapter_len = lambda do |a, idx|
    return adapter_cache[a] unless adapter_cache[a].nil?
    
    next_adapters_indices = (idx + 1...adapters.size).select { |i| a < adapters[i] && adapters[i] <= a + 3 }.take(3)
    return adapter_cache[a] = 1 if next_adapters_indices.empty?

    adapter_cache[a] = next_adapters_indices.map { |i| adapter_len.call(adapters[i], i) }.sum
  end
  
  adapter_len.call(adapters[0], 0)
end
puts "#{total_adapter_lens(adapters)}"
