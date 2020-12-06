PW_DB_LINES = File.readlines('day2_input.txt').map{ |s| s.chomp.tr!('-:', ' ') }

# Part 1
valid_pws_rule1 = lambda do |line|
  entries = line.split(' ')
  min = entries[0].to_i
  max = entries[1].to_i
  char = entries[2]
  number_chars = entries[3].chars.select{ |c| c == char }.length
  
  number_chars.between?(min, max)
end
puts "#{ PW_DB_LINES.select(&valid_pws_rule1).length }"

# Part 2
valid_pws_rule2 = lambda do |line|
  entries = line.split(' ')
  idx1 = entries[0].to_i - 1
  idx2 = entries[1].to_i - 1
  char = entries[2]
  pw_chars = entries[3].chars
    
  (pw_chars[idx1] == char) ^ (pw_chars[idx2] == char)
end
puts "#{ PW_DB_LINES.select(&valid_pws_rule2).length }"
