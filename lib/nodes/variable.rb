# This represents a variable in Trump. A variable is a sequence of
# lowercase letters that should map to a key in the environment.
class Variable
  attr_reader :identifier

  # The initializer should be passed a Parslet::Slice containing a
  # sequence of lowercase letters. Due to the way I wrote the parser,
  # this might sometimes include a trailing space, so we need to call
  # strip to make sure we get rid of it.
  def initialize(identifier)
    @identifier = identifier.to_s.strip
  end

  # Evaluating a variable returns the corresponding value from the
  # environment.
  def eval(env)
    env.get(identifier)
  end

  # Just like eval, finding the type of a variable returns the
  # corresponding value from the context.
  def type(context)
    context.get(identifier)
  end

  # The constraints method is used to work out function param types by
  # investigating the function body. Variables do not place any
  # constraints on function params.
  def constraints(_)
    nil
  end
end
