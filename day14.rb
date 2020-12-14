INSTRUCTIONS = File.readlines('day14_input.txt').map { |line| line.chomp.split(' = ') }

def run(instructions, version = 1)
  mask = { raw: '', frozen_bits: {} }
  mem = {}

  instructions.each do |instr|
    # Fetch, Decode, & Execute goodness again. :)
    case instr[0]
    when /mem/
      case version
      when 1
        addr = instr[0][4..-2].to_i
        value = instr[1].to_i

        mem[addr] = value
        mask[:frozen_bits].each do |pos, bit|
          if bit.zero?
            mem[addr] &= ~(1 << pos)
          else
            mem[addr] |=  (1 << pos)
          end
        end
      when 2
        # TODO: Part 2
      end

    when /mask/
      mask[:frozen_bits] = {}

      mask[:raw] = instr[1]
      mask[:raw].chars.reverse.each_with_index do |bit, idx|
        next if bit == 'X'

        mask[:frozen_bits][idx] = bit.to_i
      end
    end
  end

  mem.values.sum
end

# Part 1
puts run(INSTRUCTIONS)

# Part 2
# puts run(INSTRUCTIONS, version = 2)
