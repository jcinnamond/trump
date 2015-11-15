require_relative '../types/function_constraint'

class Call
  attr_reader :target, :args

  def initialize(target, args)
    @target = target.to_s.strip
    @args = args
  end

  def eval(env)
    fn = env.get(target)
    values = args.map { |arg| arg.eval(env) }
    fn.call(values, env)
  end

  def type(context)
    ft = context.get(target)
    arg_types = args.map { |arg| arg.type(context) }
    ft.return_type(arg_types, context)
  end

  def constraints(context)
    types = args.map { |arg| arg.type(context) }
    [target, FunctionConstraint.new(types)]
  end
end
