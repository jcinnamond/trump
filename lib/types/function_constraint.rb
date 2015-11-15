require_relative 'function_type'
require_relative 'union_type'

class FunctionConstraint
  attr_reader :types, :idx

  def initialize(types)
    @types = types
  end

  def idx=(idx)
    @idx = idx
  end

  def return_type(*_args)
    (@idx + 97).chr
  end

  def accept?(other)
    case other
    when FunctionType
      other.params.size == types.size
    when UnionType
      if accept?(other.t1) || accept?(other.t2)
        puts "WARN: #{other.inspect} might not satisfy #{self.inspect}"
        true
      else
        false
      end
    else
      false
    end
  end
end
