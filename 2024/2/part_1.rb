require "debug"
require "../../helpers"

module Day2
  class Solver
    def initialize(file)
      @reports = File.readlines(file, chomp: true).map { |r| r.split.map(&:to_i) }
    end

    def solve
      @reports.count do |levels|
        deltas = []
        foo = levels.join(", ")
        levels = levels.reverse
        a = levels.pop
        b = levels.pop
        inc = a < b
        dec = a > b
        delta = a - b

        safe = true
        safe = false if inc == dec
        safe = false unless (1..3).cover?(delta.abs)

        until b.nil? || safe == false
          inc ||= a < b
          dec ||= a > b

          delta = a - b
          deltas.push(delta)

          safe = false if inc == dec
          safe = false unless (1..3).cover?(delta.abs)
          a = b
          b = levels.pop
        end

        if safe
          puts "----------------"
          puts foo
          puts deltas.join(", ")
          puts safe
        end

        safe
      end
    end
  end
end

# sample(Day2::Solver)
run(Day2::Solver)
# test(Day2::Solver)
