require "awesome_print"
require "prettyprint"

class String
  def split_strip(value)
    split(value).map(&:strip)
  end
end

class Array
  def map_to(clazz)
    map { |x| clazz.new(x) }
  end

  def print_2d(s = "")
    puts "============================"
    each { |e| puts(e.join(s)) }
    puts "============================"
  end
end
