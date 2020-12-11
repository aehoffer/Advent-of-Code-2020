INTIAL_SEAT_STATES = File.readlines("day11_input.txt").map { |line| line.chomp.chars }  

def print_states(states)
  states.each { |r| puts "#{ r.join('') }" } 
  puts ""
end

def between_boundary?(x, y, r, c)
  (0...r).include?(x) && (0...c).include?(y)
end
  
def seats_occupied_when_finished(seat_states, surroundings_rule, seat_occupied_threshold)
  row_size = seat_states.length  
  column_size = seat_states.first.length
  #puts "(r, c): (#{row_size}, #{column_size})"  

  old_state = seat_states.clone.map(&:clone)
  new_state = nil
    
  loop do  
    new_state = old_state.clone.map(&:clone)
    new_seats_occupied = 0
    new_seats_empty = 0
    
    #print_states(new_state)
    old_state.each_with_index do |r, i|  
      r.each_with_index do |c, j|  
        surroundings = surroundings_rule.call(i, j, old_state)
        #puts "(c, i, j): (#{c}, #{i}, #{j}),  #{surroundings}"
    
        seats = surroundings.map{ |x, y| old_state[x][y] }.select { |c| ['L', '#'].include?(c) }  
        empty_seats = seats.select { |s| s == 'L' }.size
        occupied_seats = seats.select { |s| s == '#' }.size
  
        case c  
        when 'L'
          if seats.size == empty_seats
            new_state[i][j] = '#' 
            new_seats_occupied += 1
          end
        when '#'
          if occupied_seats >= seat_occupied_threshold
            new_state[i][j] = 'L' 
            new_seats_empty += 1
          end
        end  
      end  
    end  
  
    break if new_seats_occupied + new_seats_empty == 0
  
    old_state = new_state
  end

  new_state.flatten.select { |c| c == '#' }.size
end

# Part 1
nearest_surroundings = lambda do |x, y, states|
  r = states.length  
  c = states.first.length
  
  [  [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],  
     [x - 1, y]    ,             [x + 1, y]    ,  
     [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]  
  ].select { |pos| between_boundary?(pos[0], pos[1], r, c) }  
end  
puts "#{ seats_occupied_when_finished(INTIAL_SEAT_STATES, nearest_surroundings, 4) }"

# Part 2
line_of_sight_surroundings = lambda do |x, y, states|
  line_of_sight = lambda do |orig, dir|
    r = states.length  
    c = states.first.length
  
    los_cells = []
    x_pos = orig[0]
    y_pos = orig[1]
    
    loop do 
      x_pos += dir[0]
      y_pos += dir[1]
    
      los_cells << [x_pos, y_pos] if between_boundary?(x_pos, y_pos, r, c)
              
      break unless between_boundary?(x_pos, y_pos, r, c) && states[x_pos][y_pos] == '.'
    end
  
    # puts "(x, y): (#{x}, #{y}), surroundings: #{los_cells}"
    los_cells
  end
  
  [ [-1, -1], [0, -1], [1, -1],  
    [-1,  0],          [1,  0],
    [-1,  1], [0,  1], [1,  1],
  ].map { |dir| line_of_sight.call([x, y], dir).reject { |p| p.empty? } }
   .flatten(1)
end
puts "#{ seats_occupied_when_finished(INTIAL_SEAT_STATES, line_of_sight_surroundings, 5) }"
