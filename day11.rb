#require 'set'  
  
INTIAL_SEAT_STATES = File.readlines("day11_input.txt").map { |line| line.chomp.chars }  

# Part 1
def print_states(states)
  states.each { |r| puts "#{ r.join('') }" } 
  puts ""
end
  
def seats_occupied_beginning_cycle(seat_states)  
  row_size = seat_states.length  
  column_size = seat_states.first.length

  #puts "(r, c): (#{row_size}, #{column_size})"  
    
  neighbours = lambda do |x, y|  
    [  [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],  
       [x - 1, y]    ,             [x + 1, y]    ,  
       [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]  
    ].select do |pos|  
	  pos[0] >= 0 && pos[0] < row_size &&  
      pos[1] >= 0 && pos[1] < column_size  
    end  
  end

  old_state = seat_states.clone.map(&:clone)
  new_state = nil
    
  loop do  
    new_state = old_state.clone.map(&:clone)
	new_seats_occupied = 0
    new_seats_empty = 0
	
	#print_states(new_state)
		  
    old_state.each_with_index do |r, i|  
	  r.each_with_index do |c, j|  
		surroundings = neighbours.call(i, j)
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
		  if occupied_seats >= 4
		    new_state[i][j] = 'L' 
		    new_seats_empty += 1
		  end
		end  
	  end  
	end  
	
	break if new_seats_occupied + new_seats_empty == 0
	
	old_state = new_state.clone.map(&:clone)
  end

  new_state.flatten.select { |c| c == '#' }.size
end  
  
puts "#{ seats_occupied_beginning_cycle(INTIAL_SEAT_STATES) }"
