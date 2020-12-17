require 'set'

TICKETS_INFO = File.read('day16_input.txt').split("\n\n")

ticket_rules = {}
my_ticket = []
nearby_tickets = []

TICKETS_INFO[0].split("\n").each do |line|
  m = line.chomp.match(/(\w+ ?\w+): (\d+)-(\d+) or (\d+)-(\d+)/)

  ticket_rules[m[1].to_sym] = [(m[2].to_i..m[3].to_i).to_set, (m[4].to_i..m[5].to_i).to_set].to_set
end

my_ticket = TICKETS_INFO[1].split("\n")[1].split(',').map(&:to_i)

TICKETS_INFO[2].split("\n").drop(1).each do |line|
  nearby_tickets << line.chomp.split(',').map(&:to_i)
end

# Part 1
any_rule = ticket_rules.values.map { |s| s.reduce(:+) }.reduce(:+)

invalid_tickets = nearby_tickets.select do |t|
  t.select { |f| f unless any_rule.include?(f) }.size.positive?
end

error_rates = invalid_tickets.map do |t|
  t.select { |f| f unless any_rule.include?(f) }.sum
end

puts error_rates.sum

# Part 2
ticket_field_values = (nearby_tickets - invalid_tickets).transpose

candidate_ticket_fields = ticket_field_values.each_with_index.map do |fv, i|
  [ticket_rules.keys.select { |r| fv.to_set <= ticket_rules[r].reduce(:+) }, i]
end

candidate_ticket_fields.sort! { |c1, c2| c1[0].size <=> c2[0].size }

field_positions = {}
candidate_ticket_fields.each do |fields, index|
  possible_fields = fields.reject { |f| field_positions.keys.include?(f) }
  if possible_fields.size == 1
    field_positions[possible_fields.first] = index
  else
    # General case: Magic with comparing fields subsets, picking smallest one?
    # Not needed for my puzzle input though. Would otherwise need some kind of
    # constraint satisfaction search to make this work.
  end
end

departure_values = field_positions.select { |r, _| r.to_s['departure'] }
                                  .values
                                  .map { |i| my_ticket[i] }.reduce(:*)

puts departure_values
