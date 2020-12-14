NOTES = File.readlines('day13_input.txt').map(&:chomp)

depart_time = NOTES[0].to_i
all_buses = NOTES[1].split(',').map { |b| b == 'x' ? 0 : b.to_i }
active_buses = all_buses.reject(&:zero?)

# Part 1
min_bus_arrival = active_buses.map { |b| [b, b * (depart_time / b.to_f).ceil] }
                              .select { |p| p[1] >= depart_time }
                              .min { |p1, p2| p1[1] <=> p2[1] }
puts min_bus_arrival[0] * (min_bus_arrival[1] - depart_time)

# Part 2, mainly taken from rosettacode.org for calculating timestep via
# Chinese Remainder Theorem. Mainly lazyness overtook me from coming up
# with trying to re-invent how to solve it from scratch, so credit to
# here: https://rosettacode.org/wiki/Chinese_remainder_theorem, just formatted
# a bit differently.
def extended_gcd(a, b)
  last_remainder = a.abs
  remainder = b.abs
  x = 0
  last_x = 1
  y = 1
  last_y = 0

  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient * x, x
    y, last_y = last_y - quotient * y, y
  end

  [last_remainder, last_x * (a.negative? ? -1 : 1)]
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  raise 'Multiplicative inverse modulo does not exist!' if g != 1

  x % et
end

def chinese_remainder(mods, remainders)
  lcm = mods.reduce(:*)
  series = remainders.zip(mods).map { |r, m| (r * lcm * invmod(lcm / m, m) / m) }
  series.reduce(:+) % lcm
end

all_buses_with_depart_times = all_buses.each_with_index.map { |b, i| [b, b.zero? ? 0 : -i % b] }
                                       .reject { |p| p.first.zero? }

bus_moduli = all_buses_with_depart_times.map(&:first)
bus_remainders = all_buses_with_depart_times.map { |p| p[1] }
timestep = chinese_remainder(bus_moduli, bus_remainders)

puts timestep
