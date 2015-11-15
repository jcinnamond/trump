# This file contains the definitions of the interpreter and type
# analyzer.

require_relative 'parser'
require_relative 'transform'
require_relative 'environment'

# This utility method is used by both the interpreter and the type
# analyzer. It takes a string containing a Trump program and returns
# an array of nodes.
#
# Technically, this method creates a denotational semantics for the
# Trump source code. That is, it translates the original program into
# a new form that denotes (or expresses) the same meaning. In this
# case, the denotation is an array of Ruby objects (the nodes).
def nodes(src)
  TrumpTransform.new.apply(TrumpParser.new.parse(src))
end

# The interpret method just ties the rest of the code together. It
# creates a global environment for the program and then evaluates each
# expression. It returns an array of the output value for each
# expression. In a real program it would be more common to return only
# the value of hte last expression.
def interpret(src)
  env = Environment.new

  nodes(src).map do |node|
    node.eval(env)
  end
end

# The type_check method is almost identical to interpret, except that
# instead of evaluating each expression it asks for the type.
def type_check(src)
  context = Environment.new

  nodes(src).map do |node|
    node.type(context)
  end
end
