BAG_LINES = File.readlines('day7_input.txt').map{ |line| line.chomp.gsub(/ bags?|[.]/, '') }
BAG_RULES = { }

BAG_LINES.each do |line|
  rule = line.split(" contain ")
  bag = rule.first.to_sym
  BAG_RULES[bag] = []
  
  rule[1].split(",").each do |b|
    m = b.match(/^ ?(\d+) (\w+ \w+)$/)
    BAG_RULES[bag] << [m[2].to_sym, m[1].to_i] unless m.nil?  
  end
end

# Part 1
def containing_bag_count(rules, target_counts, target_bag)
  bag_count_rec = lambda do |bag|
    return 1 if bag == target_bag
    return 0 if rules[bag].empty?
      
    count = 0
    rules[bag].each do |b|
      target_count = target_counts[b.first] < 0 ? b[1] * bag_count_rec.call(b.first) : target_counts[b.first]
    
      target_counts[b.first] = target_count
      count += target_count
    end
  
    count
  end
  
  rules.keys.select { |k| k != target_bag && bag_count_rec.call(k) > 0 }.length
end

shiny_gold_counts = {}
BAG_RULES.keys.each { |k| shiny_gold_counts[k] = -1 }
puts "#{ containing_bag_count(BAG_RULES, shiny_gold_counts, :"shiny gold") }"

# Part 2;
def total_bag_count(rules, root)
  bag_count_rec = -> (bag) { rules[bag].map { |b|  b[1] * (1 + bag_count_rec.call(b.first)) }.reduce(0, :+) }

  bag_count_rec.call(root)
end
puts "#{ total_bag_count(BAG_RULES, :"shiny gold") }"