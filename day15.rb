NUMBERS = File.readlines('day15_input.txt')[0].chomp.split(',').map(&:to_i).unshift(-1)

def memory_game(numbers, stop)
  number_turns_spoken = {}
  numbers.each_with_index { |n, i| number_turns_spoken[n] = [i] if i.positive? }

  curr_turn = numbers.size
  while curr_turn <= stop
    last_turn = curr_turn - 1
    last_number = numbers[last_turn]
    spoken = 0

    if number_turns_spoken[last_number].nil?
      number_turns_spoken[last_number] = [last_turn]
    else
      spoken = if number_turns_spoken[last_number].size == 1
                 last_turn - number_turns_spoken[last_number][-1]
               else
                 number_turns_spoken[last_number][-1] - number_turns_spoken[last_number][-2]
               end
      if number_turns_spoken[spoken].nil?
        number_turns_spoken[spoken] = [curr_turn]
      else
        number_turns_spoken[spoken] << curr_turn
      end
    end

    numbers[curr_turn] = spoken
    curr_turn += 1
  end

  numbers[stop]
end

# Part 1
puts memory_game(NUMBERS.clone, 2020)

# Part 2
puts memory_game(NUMBERS.clone, 30_000_000)
