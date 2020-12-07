PASSPORTS = File.read('day4_input.txt').split("\n\n").map { |p| p.gsub("\n", ' ') }
FIELD_VALIDATOR = {
  byr: -> (y) { y.match?(/^\d{4}$/) && y.to_i.between?(1920, 2002) },
  iyr: -> (y) { y.match?(/^\d{4}$/) && y.to_i.between?(2010, 2020) },
  eyr: -> (y) { y.match?(/^\d{4}$/) && y.to_i.between?(2020, 2030) },
  hgt: lambda do |h|
    m = h.match(/^(\d+)(cm|in)$/)
    return false if m.nil?
    return m[1].to_i.between?(150, 193) if m[2] == "cm"
    return m[1].to_i.between?(59, 76) if m[2] == "in"
    false
  end,
  hcl: -> (h) { h.match?(/^#[0-9a-f]{6}$/) },
  ecl: -> (e) { %w[amb blu brn gry grn hzl oth].include?(e) },
  pid: -> (p) { p.match?(/^\d{9}$/) }
}

# Part 1
valid_passports1 = lambda do |p|
  present_fields = p.split(' ').select { |f| !FIELD_VALIDATOR[f.split(':').first.to_sym].nil? }
  
  present_fields.length == FIELD_VALIDATOR.length
end
puts "#{ PASSPORTS.select(&valid_passports1).length }"

# Part 2
valid_passports2 = lambda do |p| 
  present_valid_fields = p.split(' ').select do |f|
    kv = f.split(':')
    key = kv[0].to_sym
    val = kv[1]
	
    FIELD_VALIDATOR[key]&.call(val)
  end
  
  present_valid_fields.length == FIELD_VALIDATOR.length
end
puts "#{ PASSPORTS.select(&valid_passports2).length }"
