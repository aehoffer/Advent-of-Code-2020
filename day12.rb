INSTRUCTIONS = File.readlines("day12_input.txt").map { |line| [line.chomp[0], line.chomp[1..].to_i] }

# Part 1
def move_ship1(ship, instructions)
  instructions.each do |instr|
    case instr[0]
    when 'E'
      ship[:pos][:x] += instr[1]
    when 'N'
      ship[:pos][:y] += instr[1]
    when 'W'
      ship[:pos][:x] -= instr[1]
    when 'S'
      ship[:pos][:y] -= instr[1]
    when /[LR]/
      sign = sign = instr[0] == 'L' ? 1 : -1
      ship[:degrees] = (ship[:degrees] + sign * instr[1]) % 360
    when 'F'
      case ship[:degrees]
      # Note: normally would do Math.cos/sin(degrees * Math.PI / 180) for x / y normally,
      #       but easier this way since no need to deal with floats here, All
      #       angles are given as integral multiples of 180 degrees.
      when 0
        # E
        ship[:pos][:x] += instr[1]
      when 90
        # N
        ship[:pos][:y] += instr[1]
      when 180
        # W
        ship[:pos][:x] -= instr[1]
      when 270
        # S
        ship[:pos][:y] -= instr[1]
      end
    end
    #puts "instr: #{instr}, ship: #{ship}"
  end
end

ship1 = { pos: { x: 0, y: 0 }, degrees: 0 }
move_ship1(ship1, INSTRUCTIONS)

puts "#{ ship1[:pos][:x].abs + ship1[:pos][:y].abs }"

# Part 2
def move_ship2(ship, waypoint, instructions)
  instructions.each do |instr|
    case instr[0]
    when 'E'
      waypoint[:pos][:x] += instr[1]
    when 'N'
      waypoint[:pos][:y] += instr[1]
    when 'W'
      waypoint[:pos][:x] -= instr[1]
    when 'S'
      waypoint[:pos][:y] -= instr[1]
    when /[LR]/
      # Rotate waypoint around the ship to do stuff.
      # Co-ordinates are given relative to ship, so just directly 
      # multiply with imaginary units or -1 as required.
      sign = instr[0] == 'L' ? 1 : -1
      angle = (sign * instr[1]) % 360
    
      complex_dir = case angle
      when 90
        'i'.to_c
      when 180
        '-1'.to_c
      when 270
        '-i'.to_c
      end
    
      waypoint_c = Complex(waypoint[:pos][:x], waypoint[:pos][:y]) * complex_dir
      waypoint[:pos][:x] = waypoint_c.real
      waypoint[:pos][:y] = waypoint_c.imag
    when 'F'
      ship[:pos][:x] += instr[1] * waypoint[:pos][:x]
      ship[:pos][:y] += instr[1] * waypoint[:pos][:y]
    end
    # puts "instr: #{instr}, ship: #{ship}, waypoint: #{waypoint}"
  end
end

ship2 = { pos: { x: 0, y: 0 }, degrees: 0 }
waypoint = { pos: { x: 10, y: 1 } }

move_ship2(ship2, waypoint, INSTRUCTIONS)
puts "#{ ship2[:pos][:x].abs + ship2[:pos][:y].abs }"
