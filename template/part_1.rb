require "debug"
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

sample(DayX::Solver)
# run(DayX::Solver)
# test(DayX::Solver)
