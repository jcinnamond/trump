require_relative '../types/null_type'
require_relative '../types/union_type'

require_relative 'null'

class Maybe
  attr_reader :expr

  def initialize(expr)
    @expr = expr
  end

  def eval(env)
    if rand > 0.5
      expr.eval(env)
    else
      Null.new
    end
  end

  def type(context)
    UnionType.new(expr.type(context), NullType.new)
  end
end
