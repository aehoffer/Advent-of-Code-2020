RULES_AND_MESSAGES = File.read('day19_input.txt').split("\n\n")
RULES = RULES_AND_MESSAGES[0].split("\n")
MESSAGES = RULES_AND_MESSAGES[1].split("\n")

# puts RULES.to_s
# puts MESSAGES.to_s

rule_tree = {}
RULES.each do |r|
  matches = r.match(/(\d+): (.+)/)
# puts "1: #{matches[1]}, 2: #{matches[2]}"

  parent = matches[1].to_i
  rule_tree[parent] = []

  child_groups = matches[2].split('|').map { |g| g.strip.tr('"', '') }
  child_groups.each { |g| rule_tree[parent] << g.split(' ').map { |c| c =~ /\d+/ ? c.to_i : c } }
end

puts rule_tree.to_s

def derive_messages(tree, start)
  cache = {}

  derive_messages_rec = lambda do |rule|
    puts "Starting Rule #{rule}"
    unless cache[rule].nil?
      puts "Rule: #{rule}, Cache: #{cache[rule]}"
      return cache[rule]
    end

    if tree[rule].first.first =~ /[ab]/
      puts "Rule: #{rule}, Base: #{[tree[rule].first.first]}"
      return cache[rule] = [tree[rule].first.first]
    end

    messages = []
    puts "Child rules: #{tree[rule]}"
    tree[rule].each do |g|
      messages << g.map { |n| derive_messages_rec.call(n) }.reduce(:product).map(&:join)
    end

    puts "Rule: #{rule}, Messages: #{messages}"
    cache[rule] = messages.reduce(:|)
  end

  derive_messages_rec.call(start)
end

possible_messages = derive_messages(rule_tree, 0)
puts possible_messages.to_s
puts MESSAGES.select { |m| possible_messages.include?(m) }.size
