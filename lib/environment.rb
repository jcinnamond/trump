# When we try to fetch something from the environment that doesn't
# exist we raise an error.
class MissingValue < StandardError
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def message
    "No value set for #{key}"
  end
end

# When our environment has no real parent, trying to fetch any key
# raises an error.
class EmptyEnvironment
  def get(key)
    fail MissingValue.new(key)
  end
end

# The environment holds the running state of a program at a given
# point in time. This is mostly just a glorified hash, with methods to
# get and set values. However it is also possible to set a parent
# environment and any keys not found in this environment are fetched
# from the parent.
#
# Setting a parent allows us to simulate a kind of call stack. For
# example, an environment is created when calling a function, with the
# parent set to the environment at the point that the call is
# evaluated. This serves two purposes. First, it allows expressions in
# the function body to access variables from the outer scope (i.e.,
# variables that are free with respect to the function). Second, it
# ensures that any new assignments within the function - including
# assignment of the function params - only exist for the duration of
# the function call.
class Environment
  attr_reader :state, :parent

  def initialize(parent: EmptyEnvironment.new)
    # Internally, the environment uses a hash to keep track of
    # assignments.
    @state = {}
    @parent = parent
  end

  def set(key, value)
    state[key] = value
  end

  def get(key)
    state.fetch(key, nil) || parent.get(key)
  end
end
