# Trump #
## A very simple programming language ##

Trump is a very simple programming language interpreter and static
type analyser that I used to illustrate my talk
[Softly, Softly Typing](http://rubyconf.org/program) at
[Rubyconf 2015](http://rubyconf.org/). The language consists of
numbers and functions which can both be assigned to variables, and of
a strange keywork `Maybe` that simulates runtime uncertainty.

The following example program demonstrates most of the capability of
the Trump language:

```
fst = fn(x, y) { x }
snd = fn(x, y) { y }

apply = fn(x, y, z) { x(y, z) }

a = 6
b = 7

apply(fst, a, b)
```

When run through the interpreter, this program produces an array of
output values - one element for each expression in the program. The
output produced is something like:

```
[
  #<Function...>,
  #<Function...>,
  #<Function...>,
  6,
  7,
  6
]
```

Then running it through the type checker produces something like:

```
[
  (a,b) -> a,
  (a,b) -> b,
  ((b,c) -> d, b, c) -> d
  <NumberType>,
  <NumberType>,
  <NumberType>
]
```
