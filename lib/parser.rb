require 'parslet'

# This is the parser step of both the interpreter and the static type
# analyser for Trump. It is responsible for taking a string
# representation of a program, matching the Trump syntax and producing
# a tree-like structure representing the expressions in the program.
#
# I'm using Parslet to write the parser. There are other parser gems
# available for Ruby, such as the better know Treetop gem or the
# faster Citrus gem, but I find Parslet easier to work with and it's
# debugging output is by far the most helpful.
class TrumpParser < Parslet::Parser
  # Space is usually a distraction when writing a parser. We need to
  # accommodate it but we don't want to match it as it has no
  # particular meaning. (Except for writing Python where the
  # distraction of having to think about space is shared with the
  # programmer.)
  #
  # The following two rules are used to: match whitespace; and
  # optionally match whitespace but not care if it isn't present.
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  # The following terminals are used at some point during the parser
  # definition. A 'terminal' is a rule that does not contain any other
  # rules. We eat space any trailing space in these rules to remove
  # the complexity of handling space from more complicated rules
  # later.
  rule(:lparen) { str('(') >> space? }
  rule(:rparen) { str(')') >> space? }
  rule(:lbrace) { str('{') >> space? }
  rule(:rbrace) { str('}') >> space? }
  rule(:comma)  { str(',') >> space? }
  rule(:equals) { str('=') >> space? }

  # The following terminals represent keywords in the language. As you
  # can see, it's a pretty simple language. The keyword for maybe is
  # named with a leading _ to avoid clashing with Parslet's build in
  # `maybe` method.
  rule(:fn)     { str('fn') >> space?    }
  rule(:_maybe) { str('Maybe') >> space? }

  # We use the concept of an 'identifier' in a couple of different
  # places: for variable names and for function parameters. In both
  # cases an identifier is a sequence of lower case letters.
  rule(:identifier) { match('[a-z]').repeat(1) >> space? }

  # Every Parslet parser has a `root` definition. This tells the
  # parser what is valid as top level elements of the input. For
  # Trump, the valid top level elements are expressions.
  root(:expressions)

  # A Trump program is really a list of at least one expression,
  # possibly with some blank space at the beginning. The definition of
  # `expression` takes care of any space at the end.
  rule(:expressions) { space? >> expression.repeat(1) }

  # An expression is the top level structure in a Trump program.
  rule(:expression) do
    (
      function | call | maybe_eval |
      assign | number | variable
    ) >> space?
  end

  #======================================================================
  # Functions
  #======================================================================

  # A function definition looks something like:
  #
  #   fn(x, y) { x }
  #
  # It has a literal keyword `fn`, followed by a param list, followed
  # by a function body. The function body is a list of valid Trump
  # expressions.
  rule(:function) { (fn >> params >> body).as(:function) }

  # To match the list of params we match the surrounding parenteses
  # and then match one or more param inside, separated by commas. A
  # param is any valid identifier.
  rule(:params) do
    lparen >>
      (param >>
       (comma >> param).repeat(0)).as(:params) >>
      rparen
  end
  rule(:param) { identifier.as(:param) >> space? }

  # The body is surrounded by braces and effectively contains a
  # smaller Trump program.
  rule(:body) { lbrace >> expressions.as(:body) >> rbrace }

  # A function call consists of an identifier followed by a list of
  # arguments in parentheses.
  rule(:call) { (identifier.as(:target) >> args).as(:call) }

  # The arguments to a function are a comma separated list of valid
  # expressions.
  rule(:args) { lparen >> (arg >> (comma >> arg).repeat(0)).as(:args) >> rparen }
  rule(:arg) { expression.as(:arg) }

  #======================================================================
  # Maybe
  #======================================================================

  # `Maybe` is syntactically simple. It consists of the keyword
  # `Maybe` followed by any valid expression.
  rule(:maybe_eval) { (_maybe >> expression).as(:maybe) }

  #======================================================================
  # Assign, variable, number
  #======================================================================

  # An assignment consists of a target variable, followed by the
  # literal equals symbol, followed by any valid expression.
  rule(:assign) do
    (identifier.as(:target) >> equals >> expression.as(:value)).as(:assign)
  end

  # A variable is simply any identifier. This is given as the last
  # option in the list of expressions becuase we only want to match
  # identifiers that are not being used in another context - e.g., we
  # don't want to match the targets for assignments or the params for
  # functions.
  rule(:variable) { identifier.as(:variable) }

  # Finally, numbers. Perhaps more accurately, positive integers.
  # These are sequences of one or more digits.
  rule(:number) { match('\d').repeat(1).as(:number) >> space? }
end
