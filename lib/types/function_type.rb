require_relative '../environment'
require_relative 'any_type'
require_relative 'trump_type_error'

class FunctionType
  attr_reader :params, :body, :initial_context

  def initialize(fn, context)
    @params = fn.params
    @body = fn.body
    @initial_context = context
  end

  def return_type(arg_types, context)
    verify(arg_types)

    call_context = Environment.new(parent: context)

    params.each.with_index do |param, idx|
      call_context.set(param, arg_types[idx])
    end

    body.map { |node| node.type(call_context) }.last
  end

  def verify(types)
    generic_param_types.each.with_index do |param_type, idx|
      given_type = types[idx]
      unless param_type.accept?(given_type)
        fail TrumpTypeError, "#{given_type.inspect} is not a function: #{param_type}"
      end
    end
  end

  def generic_params
    return @generic_params if @generic_params

    @generic_params = Hash[
      params.map.with_index do |p, idx|
        [p, AnyType.new(idx)]
      end
    ]
  end

  def generic_context
    return @generic_context if @generic_context

    @generic_context = Environment.new(parent: initial_context)
    generic_params.each_pair do |param, type|
      @generic_context.set(param, type)
    end

    constraints = body
                  .map { |node| node.constraints(@generic_context) }
                  .compact
    constraints.each.with_index do |constraint, i|
      param, type = constraint
      type.idx = i + params.size
      @generic_context.set(param, type)
    end
    @generic_context
  end

  def generic_return
    return @generic_return if @generic_return
    @generic_return = body.map { |node| node.type(generic_context) }.last
  end

  def generic_param_types
    params.map { |p| generic_context.get(p) }
  end

  def inspect
    "(#{generic_param_types.join(',')}) -> #{generic_return}"
  end
end
