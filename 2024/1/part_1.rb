require "debug"
require "../../helpers"

module Day1
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      @left = []
      @right = []
    end

    def solve
      build_lists
      sort_lists
      calculate_distance
    end

    private

    def build_lists
      @lines.each do |line|
        l, r = line.split
        @left.push(l.to_i)
        @right.push(r.to_i)
      end
    end

    def sort_lists
      @left = @left.sort
      @right = @right.sort.reverse
    end

    def calculate_distance
      @left.map { |l| [l, @right.pop] }.map { |l, r| (l - r).abs }.sum
    end
  end
end

# sample(Day1::Solver)
run(Day1::Solver)
# test(Day1::Solver)
