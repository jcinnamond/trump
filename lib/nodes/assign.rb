# This represents an assignment in Trump. An assignment consits of a
# target - an identifier that will be used as a key when updating the
# environment - and a value that is set to some other node (i.e., to
# some other Trump expression).
class Assign
  attr_reader :target, :value

  # The initializer should be passed a Parslet::Slice containing a
  # sequence of lowercase letters and another Node. As the target
  # comes from matching an identifier we need to make sure we convert
  # it to a string and get rid of any trailing space.
  def initialize(target, value)
    @target = target.to_s.strip
    @value = value
  end

  # Evaluating an assignment requires two steps. First, the 'value'
  # part of the assignment is evaluated. Second, the returned value is
  # added to the environment, using the target as the key.
  def eval(env)
    env.set(target, value.eval(env))
  end

  # Similar to eval, getting the type an assignment requires two
  # steps. First, the type of the value is retrieved. Second, the
  # returned type is added to the context, using the target as
  # the key.
  def type(context)
    context.set(target, value.type(context))
  end

  # The constraints method is used to work out function param types by
  # investigating the function body. Assignments do not place any
  # constraints on function params.
  def constraints(_)
    nil
  end
end
