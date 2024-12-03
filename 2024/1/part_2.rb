require "debug"
require_relative "../helpers"

module Day1
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      @left = []
      @right = []
    end

    def solve
      build_lists
      calculate_similarity
    end

    private

    def build_lists
      @lines.each do |line|
        l, r = line.split
        @left.push(l.to_i)
        @right.push(r.to_i)
      end
    end

    def calculate_similarity
      @left.map { |l| l * @right.count(l) }.sum
    end
  end
end

sample(Day1::Solver)
run(Day1::Solver)
# test(Day1::Solver)
