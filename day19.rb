RULES_AND_MESSAGES = File.read('day19_input.txt').split("\n\n")
RULES = RULES_AND_MESSAGES[0].split("\n")
MESSAGES = RULES_AND_MESSAGES[1].split("\n")

rule_tree = {}
RULES.each do |r|
  matches = r.match(/(\d+): (.+)/)

  parent = matches[1].to_i
  rule_tree[parent] = []

  child_groups = matches[2].split('|').map { |g| g.strip.tr('"', '') }
  child_groups.each { |g| rule_tree[parent] << g.split(' ').map { |c| c =~ /\d+/ ? c.to_i : c } }
end

# Part 1
def derive_messages(tree, start)
  cache = {}

  derive_messages_rec = lambda do |rule|
    return cache[rule] unless cache[rule].nil?
    return cache[rule] = [tree[rule].first.first] unless tree[rule].first.first.is_a?(Integer)

    messages = []
    # puts "Child rules: #{tree[rule]}"
    tree[rule].each do |g|
      messages << g.map { |n| derive_messages_rec.call(n) }
                   .reduce(:product)
                   .map { |m| m.is_a?(Array) ? m.join : m }
    end

    # puts "Rule: #{rule}, Messages: #{messages}"
    cache[rule] = messages.reduce(:|)
  end

  derive_messages_rec.call(start)
end
possible_messages = derive_messages(rule_tree, 0).sort!
puts MESSAGES.reject { |m| possible_messages.bsearch { |s| m <=> s }.nil? }.size

# giant_regex = possible_messages.map { |m| /"#{m}"/ }.join('|')
# puts MESSAGES.select { |m| giant_regex.match?(m) }.size

# Part 2
rule_42 = derive_messages(rule_tree, 42).map { |m| /"#{m}"/ }.join('|')
rule_31 = derive_messages(rule_tree, 31).map { |m| /"#{m}"/ }.join('|')
