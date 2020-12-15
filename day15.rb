NUMBERS = File.readlines('day15_input.txt')[0].chomp.split(',').map(&:to_i).unshift(-1)

def memory_game(numbers, stop)
  number_turns_spoken = {}
  numbers.each_with_index { |n, i| number_turns_spoken[n] = { last_two: [i], count: 1 } if i.positive? }

  tail_head_indexes = lambda do |n|
    [(number_turns_spoken[n][:count] - 2) % 2,
     (number_turns_spoken[n][:count] - 1) % 2]
  end

  curr_turn = numbers.size
  while curr_turn <= stop
    last_turn = curr_turn - 1
    last_number = numbers[last_turn]
    spoken = 0

    if number_turns_spoken[last_number].nil?
      number_turns_spoken[last_number] = { last_two: [last_turn], count: 1 }
    else
      if number_turns_spoken[last_number][:count] == 1
        spoken = last_turn - number_turns_spoken[last_number][:last_two][0]
      else
        (tail, head) = tail_head_indexes.call(last_number)

        spoken = number_turns_spoken[last_number][:last_two][head] - number_turns_spoken[last_number][:last_two][tail]
      end
      number_turns_spoken[last_number][:count] += 1

      if number_turns_spoken[spoken].nil?
        number_turns_spoken[spoken] = { last_two: [curr_turn], count: 1 }
      elsif number_turns_spoken[spoken][:count] == 1
        number_turns_spoken[spoken][:last_two][1] = curr_turn

        number_turns_spoken[spoken][:count] = 2
      else
        (tail, head) = tail_head_indexes.call(spoken)

        number_turns_spoken[spoken][:last_two][head] = number_turns_spoken[spoken][:last_two][tail]
        number_turns_spoken[spoken][:last_two][tail] = curr_turn

        number_turns_spoken[spoken][:count] += 1
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
