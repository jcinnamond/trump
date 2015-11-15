require_relative '../types/function_type'

class Function
  attr_reader :params, :body

  def initialize(params, body)
    @params = params
    @body = body
  end

  def eval(_)
    self
  end

  def call(arg_values, env)
    call_env = Environment.new(parent: env)

    params.each.with_index do |param, idx|
      call_env.set(param, arg_values[idx])
    end

    body.map { |node| node.eval(call_env) }.last
  end

  def type(context)
    FunctionType.new(self, context)
  end

  def constraints(_)
    nil
  end
end
