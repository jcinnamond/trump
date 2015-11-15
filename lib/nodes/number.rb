require_relative '../types/number_type'

# This represents a numerical value in Trump. It is really just a
# wrapper around Ruby's build-in Fixnum class.
class Number
  attr_reader :value

  # The initializer should be passed a Parslet::Slice containing a
  # sequence of digits. We call to_i to turn them into a fixnum, but
  # we also need to call to_s first to convert the Slice into a normal
  # Ruby string. (Parslet::Slice doesn't respond to #to_i.)
  def initialize(digits)
    @value = digits.to_s.to_i
  end

  # Evaluating a number simply returns the numerical value.
  def eval(_)
    value
  end

  # The type of a number is always NumberType
  def type(_)
    NumberType.new
  end

  # The constraints method is used to work out function param types by
  # investigating the function body. Numbers do not place any
  # constraints on function params.
  def constraints(_)
    nil
  end
end
