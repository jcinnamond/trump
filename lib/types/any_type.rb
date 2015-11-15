class AnyType
  attr_reader :idx

  def initialize(idx)
    @idx = idx
  end

  def accept?(_)
    true
  end

  def to_s
    (idx + 97).chr
  end
end
