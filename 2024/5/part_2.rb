require "debug"
require "../helpers"

module Day5
  class Update
    attr_reader :pages, :rules

    def initialize(str)
      @pages = str.split(",").map(&:to_i)
    end

    def set_rules(rules)
      @rules = rules
    end

    def middle
      pages[pages.size / 2]
    end

    def valid?
      rules.all? { |r| r.valid?(pages) }
    end

    def shuffle
      @pages = @pages.shuffle
    end

    def fix
      until valid?
        rules.each do |r|
          next if r.valid?(@pages)

          @pages.delete_at(@pages.index(r.y))
          @pages.append(r.y)
        end
      end
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
      @updates.each { |u| u.set_rules(@rules) }
    end

    def solve
      @updates.delete_if(&:valid?)
      @updates.each(&:fix)
      @updates.sum(&:middle)
    end
  end
end
