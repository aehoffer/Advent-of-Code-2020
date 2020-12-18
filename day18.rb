EXPRESSIONS = File.readlines('day18_input.txt').map(&:chomp)

def calc_eval(expression, same_precendence = true)
  stack = []

  eval_rec = lambda do |expr, offset, level|
    op_scanned = false

    calc = lambda do
      num2 = stack.pop
      op = stack.pop
      num1 = stack.pop

      case op
      when '+'
        num1 + num2
      when '*'
        num1 * num2
      end
    end

    while expr[offset] != ')' && offset < expr.size
      token = expr[offset]

      case token
      when /\d/
        stack.push token.to_i
        stack.push calc.call if op_scanned

        op_scanned = false
      when '+', '*'
        stack.push token

        op_scanned = true
      when '('
        sub_expr, new_offset = eval_rec.call(expr, offset + 1, level + 1)
        stack.push sub_expr
        stack.push calc.call if op_scanned

        offset = new_offset
        op_scanned = false
      end

      offset += 1
    end

    [stack.pop, offset]
  end

  eval_rec.call(expression, 0, 0)
end

# Part 1
expression_tokens = []
EXPRESSIONS.each do |expr|
  expr.gsub!('((', '( (')
  expr.gsub!('))', ') )')
  expr.gsub!(/\((\d)/, '( \1')
  expr.gsub!(/(\d)\)/, '\1 )')

  expression_tokens << expr.split(' ')
end
puts expression_tokens.map { |expr_t| calc_eval(expr_t).first }.sum

# Part 2: Just put brackets around any pluses instead and feed it into
#         the current evaluator.
