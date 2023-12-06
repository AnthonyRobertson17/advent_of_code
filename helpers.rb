require "awesome_print"
require "prettyprint"

def run(clazz, *args)
  puts("===================")
  puts("input.txt")
  puts(clazz.new("input.txt").solve(*args))
end

def sample(clazz, *args)
  puts("===================")
  puts("sample.txt")
  puts(clazz.new("sample.txt").solve(*args))
end

def sample2(clazz, *args)
  puts("===================")
  puts("sample2.txt")
  puts(clazz.new("sample2.txt").solve(*args))
end

def test(clazz, *args)
  puts("===================")
  puts("test.txt")
  puts(clazz.new("test.txt").solve(*args))
end

class String
  def split_strip(value)
    split(value).map(&:strip)
  end
end

class Array
  def map_to(clazz)
    map { |x| clazz.new(x) }
  end
end
