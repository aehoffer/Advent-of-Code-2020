NOTES = File.readlines('day13_input.txt').map(&:chomp)

depart_time = NOTES[0].to_i
all_buses = NOTES[1].split(',').map { |b| b == 'x' ? 0 : b.to_i }
active_buses = all_buses.reject(&:zero?)

# Part 1
min_bus_arrival = active_buses.map { |b| [b, b * (depart_time / b.to_f).ceil] }
                              .select { |p| p[1] >= depart_time }
                              .min { |p1, p2| p1[1] <=> p2[1] }
puts min_bus_arrival[0] * (min_bus_arrival[1] - depart_time)

# Part 2
all_buses_with_depart_times = all_buses.each_with_index.map { |b, i| [b, b.zero? ? 0 : i % b] }
                                       .reject { |p| p.first.zero? }


puts "all buses with depart times: #{all_buses_with_depart_times}"
puts "all buses size: #{ all_buses.size }, active buses: #{ active_buses }"

bus_departs_lcm = all_buses_with_depart_times.map(&:first).reduce(1, :lcm)
puts "lcm: #{ bus_departs_lcm }"
