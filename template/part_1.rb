require "../../helpers"

module DayX
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
    end

    def solve
      # TODO
    end
  end
end

solve(DayX::Solver)
