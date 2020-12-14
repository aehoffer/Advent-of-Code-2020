INSTRUCTIONS = File.readlines('day14_input.txt').map { |line| line.chomp.split(' = ') }

def run(instructions, version = 1)
  mask = { raw: '', frozen_bits: {} }
  mem = {}

  instructions.each do |instr|
    # Fetch, Decode, & Execute goodness again. :)
    case instr[0]
    when /mem/
      addr = instr[0][4..-2].to_i
      val = instr[1].to_i

      case version
      when 1
        mem[addr] = val
        mask[:frozen_bits].each do |pos, bit|
          if bit.zero?
            mem[addr] &= ~(1 << pos)
          else
            mem[addr] |=  (1 << pos)
          end
        end
      when 2
        # TODO: Part 2

        # Step 1: Apply raw mask to address. Get new address, record floating mask offsets.
        # Step 2: For all repeated permutations, flip the bits appropriately for each X
        #         as part of the masked address, and store each new address obtained.
        # Step 3: Write out the value to each address obtained.
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
