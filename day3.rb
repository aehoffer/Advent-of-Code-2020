AREA_MAP = File.readlines("day3_input.txt").map { |line| line.chomp.chars }

def tree_count(map, vel)
  trees = 0
  pos = [0, 0]
  
  line_length = map.first.length
  map_length = map.length
  
  loop do
    pos[0] += vel[0]
    pos[1] += vel[1]
    
    break unless pos[0] < map_length
    
    pos[1] %= line_length
    trees += 1 if map[pos[0]][pos[1]] == "#"
  end

  trees
end

# Part 1
puts "#{ tree_count(AREA_MAP, [1, 3]) }"

# Part 2
puts "#{ [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]].map { |v| tree_count(AREA_MAP, v) }.reduce(:*) }"
