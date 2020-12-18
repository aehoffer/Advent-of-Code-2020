EXPRESSIONS = File.readlines('day18_input.txt').map { |line| line.chomp.tr!(' ', '') }

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
      when '+'
        stack.push token

        op_scanned = true
      when '*'
        stack.push token
        
        if !same_precendence
          # Just implicitly put right parenthesis around the rest
          # of the expression and go from there.
          sub_expr, offset = eval_rec.call(expr, offset + 1, level + 1)

          stack.push sub_expr
          stack.push calc.call

          break
        else
          op_scanned = true
        end
      when '('
        sub_expr, offset = eval_rec.call(expr, offset + 1, level + 1)

        stack.push sub_expr
        stack.push calc.call if op_scanned

        op_scanned = false
      end

      offset += 1
    end

    [stack.pop, offset]
  end

  eval_rec.call(expression.chars, 0, 0).first
end

# Part 1
puts EXPRESSIONS.map { |expr_t| calc_eval(expr_t, true) }.sum

# Part 2
puts EXPRESSIONS.map { |expr_t| calc_eval(expr_t, false) }.sum
