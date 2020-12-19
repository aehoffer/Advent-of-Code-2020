RULES_AND_MESSAGES = File.read('day19_input.txt').split("\n\n")
RULES = RULES_AND_MESSAGES[0].split("\n")
MESSAGES = RULES_AND_MESSAGES[1].split("\n")

rule_tree = {}
RULES.each do |r|
  matches = r.match(/(\d+): (.+)/)

  parent = matches[1]
  rule_tree[parent] = []

  child_groups = matches[2].split('|').map { |g| g.strip.tr('"', '') }
  child_groups.each { |g| rule_tree[parent] << g.split(' ').map { |c| c } }
end

# Part 1
def derive_messages(tree, start)
  cache = {}

  derive_messages_rec = lambda do |rule|
    return cache[rule] unless cache[rule].nil?
    return cache[rule] = [tree[rule].first.first] if tree[rule].first.first =~ /[ab]\*?/

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
possible_messages = derive_messages(rule_tree, '0').sort!
puts MESSAGES.reject { |m| possible_messages.bsearch { |s| m <=> s }.nil? }.size

# Part 2
rule_tree['8'] = [['42', '8*']]
rule_tree['11'] = [['42', '11*', '31']]

# ??? What do?

