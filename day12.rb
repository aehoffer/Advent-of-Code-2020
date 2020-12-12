INSTRUCTIONS = File.readlines("day12_input.txt").map { |line| [line.chomp[0], line.chomp[1..].to_i] }

def move_ship(ship, instructions)
  instructions.each do |instr|
    case instr[0]
    when /[ENWS]/
    pos_add = case instr[0]
      when 'E'
        Complex(instr[1], 0)
      when 'N'
        Complex(0, instr[1])
      when 'W'
        Complex(-instr[1], 0)
      when 'S'
        Complex(0, -instr[1])
      end
    
    ship[:pos] += pos_add
    when 'F'
      ship[:pos] += ship[:wp] * instr[1]
    when 'L', 'R'
      sign = instr[0] == 'L' ? 1 : -1
      degrees = (sign * instr[1]) % 360
      wp_dir = Complex::polar(1, Math::PI * degrees / 180)
    
      ship[:wp] *= wp_dir 
  end
end

# Part 1
ship1 = { pos: Complex(0, 0), wp: Complex(1, 0) }
move_ship(ship1, INSTRUCTIONS)
puts "#{ ship1[:pos].real.abs + ship1[:pos].imag.abs }"

# Part 2
ship2 = { pos: Complex(0, 0), wp: Complex(10, 1) }
move_ship(ship2, INSTRUCTIONS)
puts "#{ ship2[:pos].real.abs + ship2[:pos].imag.abs }"
