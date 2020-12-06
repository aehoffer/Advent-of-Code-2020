FORMS = File.read('day6_input.txt').split("\n\n")

def counts(forms, set_op_sym)
  forms.map { |group| group.split("\n").map(&:chars).reduce(set_op_sym).length }.reduce(:+)
end

# Part 1
puts "#{ counts(FORMS, :|) }"

# Part 2
puts "#{ counts(FORMS, :&) }"
