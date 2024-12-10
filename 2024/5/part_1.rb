require "debug"
require_relative "../helpers"

module Day5
  class Update
    attr_reader :pages

    def initialize(str)
      @pages = str.split(",").map(&:to_i)
    end

    def middle
      pages[pages.size / 2]
    end

    def valid?(rules)
      rules.all? { |r| r.valid?(pages) }
    end
  end

  class Rule
    attr_reader :x, :y

    def initialize(str)
      @x, @y = str.split("|").map(&:to_i)
    end

    def valid?(pages)
      return true unless pages.include?(x)
      return true unless pages.include?(y)

      pages.index(x) < pages.index(y)
    end
  end

  class Solver
    def initialize(file)
      lines = File.readlines(file, chomp: true)
      @rules = lines.shift(lines.index("")).map_to(Rule)
      lines.shift
      @updates = lines.map_to(Update)
    end

    def solve
      @updates.keep_if { |u| u.valid?(@rules) }
      @updates.sum(&:middle)
    end
  end
end
