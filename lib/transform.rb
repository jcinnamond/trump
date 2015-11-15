require 'parslet'
require_relative 'nodes/number'
require_relative 'nodes/variable'
require_relative 'nodes/assign'
require_relative 'nodes/function'
require_relative 'nodes/call'
require_relative 'nodes/maybe'

# The transform step takes the tree-like output from the parser and
# converts it into a more useful form. In this case it is converted
# into Ruby objects that represent the expressions in our program.
class TrumpTransform < Parslet::Transform
  # Matching numbers and variables is easy. The output from the parser
  # is a simple key => value mapping, so the rule can match that by
  # saying that each key (:number and :variable) has a simple value.
  rule(number: simple(:digits))       { Number.new(digits)       }
  rule(variable: simple(:identifier)) { Variable.new(identifier) }

  # The parser output for assignment looks something like:
  #
  #   {
  #     :assign => {
  #       :target => "a ",
  #       :value => { :number=>"6" }
  #     }
  #   }
  #
  # As the assign key has a subtree (i.e., another hash) as a value,
  # we need to give the rules for matching that subtree as well.
  # Matching ':target' is simple - it just has a simple value.
  # Matching ':value' is surprisingly simple too. Although it looks
  # like it contains a subtree, in practice Parslet will try to
  # simplify subtrees first by matching them against other rules in
  # the transform. In this case, it knows how to match ':number' so it
  # converts this into a simple value first, meaning we can match a
  # simple value in this rule.
  rule(assign: { target: simple(:target), value: simple(:value) }) do
    Assign.new(target, value)
  end

  # The parser output for function declaration looks something like:
  #
  #   {
  #     :function => {
  #       :params => [{ :param => 'x' }, { :param => 'y' }],
  #       :body => [{ :variable => "x" }]
  #     }
  #   }
  #
  # The only new complexity here is the need to match the params
  # subtree. It is a sequence of subtrees, each one mapping the
  # keyword `param` to an identifer. As I'm using the generic
  # definition of identifier, it might contain trailing spaces. I have
  # a specific rule to match each param, turn this into a simple value
  # and clean it up. Once params become simple values, matching the
  # whole function declaration becomes straightforward.
  rule(param: simple(:identifier)) { identifier.to_s.strip }
  rule(function: { params: sequence(:params), body: sequence(:body) }) do
    Function.new(params, body)
  end

  # The parser output for calling a function looks something like:
  #
  #   {
  #     :call => {
  #       :target => 'a',
  #       :args => [
  #         { arg: { :variable => 'a' } },
  #         { arg: { :number => '2' } }
  #       ]
  #     }
  #   }
  #
  # We need to simplify each arg using a trick similar to function
  # declarations, then matching the whole call becomes
  # straightforward.
  rule(arg: simple(:arg)) { arg }
  rule(call: { target: simple(:target), args: sequence(:args) }) do
    Call.new(target, args)
  end

  # Matching `Maybe` is easy. The parser returns a simple mapping
  # between the key `:maybe` and some other expression. Because of the
  # preceding rules the expression should already be a simple value.
  rule(maybe: simple(:expr)) { Maybe.new(expr) }
end
