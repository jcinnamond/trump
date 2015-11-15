class UnionType
  attr_reader :t1, :t2

  def initialize(t1, t2)
    @t1 = t1
    @t2 = t2
  end

  def return_type(*args)
    UnionType.new(t1.return_type(*args), t2.return_type(*args))
  end

  def inspect
    "(#{t1.inspect} OR #{t2.inspect})"
  end
end
