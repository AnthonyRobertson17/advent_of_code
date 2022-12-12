require "awesome_print"
require "prettyprint"

def run(clazz, *args)
  puts("sample.txt")
  clazz.new("sample.txt").solve(*args)
  puts("")
  puts("input.txt")
  clazz.new("input.txt").solve(*args)
end
