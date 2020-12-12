INSTRUCTIONS = File.readlines("day12_input.txt").map { |line| [line[0], line.chomp[1..].to_i] }

def move_ship(ship, instructions, mover)
  i = Complex::I

  instructions.each do |instr|
    case instr[0]
    when /[ENWS]/
      mover_add = case instr[0]
      when 'E'
        instr[1]
      when 'N'
        instr[1]*i
      when 'W'
        -instr[1]
      when 'S'
        -instr[1]*i
      end
    
      ship[mover] += mover_add
    when 'F'
      ship[:pos] += ship[:wp] * instr[1]
    when /[LR]/
      sign = instr[0] == 'L' ? 1 : -1
      degrees = (sign * instr[1]) % 360
      wp_dir = Complex::polar(1, Math::PI * degrees / 180)
    
      ship[:wp] *= wp_dir 
    end
  end
end

# Part 1
ship1 = { pos: Complex(0, 0), wp: Complex(1, 0) }
move_ship(ship1, INSTRUCTIONS, :pos)
puts "#{ ship1[:pos].real.abs + ship1[:pos].imag.abs }"

# Part 2
ship2 = { pos: Complex(0, 0), wp: Complex(10, 1) }
move_ship(ship2, INSTRUCTIONS, :wp)
puts "#{ ship2[:pos].real.abs + ship2[:pos].imag.abs }"
