require "debug"
require "../../helpers"

module Day2
  class Report
    def initialize(str)
      @levels = str.split.map(&:to_i)
    end

    def clone
      @levels.map(&:clone)
    end

    def safe?
      run(clone) || drop?
    end

    def drop?
      @levels.each_index do |i|
        return true if run(clone, i:)
      end

      false
    end

    def run(levels, i: nil)
      levels.delete_at(i) if i

      a = levels.pop
      b = levels.pop
      @increasing = a < b

      loop do
        return false if bad(a, b)

        a = b
        b = levels.pop

        return true if b.nil?
      end
    end

    def bad(a, b)
      decreasing = a > b

      return true if @increasing == decreasing
      return true unless (1..3).cover?((a - b).abs)

      false
    end
  end

  class Solver
    def initialize(file)
      @reports = File.readlines(file, chomp: true).map_to(Report)
    end

    def solve
      @reports.count(&:safe?)
    end
  end
end

sample(Day2::Solver)
run(Day2::Solver)
# test(Day2::Solver)
