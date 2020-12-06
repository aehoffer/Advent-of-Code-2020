SEAT_IDS = File.readlines('day5_input.txt').map { |s| s.chomp.tr!('FBLR', '0101').to_i(2) }

# Part 1
max_id = SEAT_IDS.max
puts "#{ max_id }"

# part 2
min_id = SEAT_IDS.min
puts "#{ (((max_id - min_id + 1) * (min_id + max_id)) / 2) - SEAT_IDS.reduce(:+) }"
