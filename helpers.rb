require "awesome_print"
require "prettyprint"

def run(clazz, *args)
  puts("===================")
  puts("input.txt")
  clazz.new("input.txt").solve(*args)
end

def sample(clazz, *args)
  puts("===================")
  puts("sample.txt")
  clazz.new("sample.txt").solve(*args)
end

def test(clazz, *args)
  puts("===================")
  puts("test.txt")
  clazz.new("test.txt").solve(*args)
end
