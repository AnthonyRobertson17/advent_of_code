require "../../helpers"
require "debug"

module Day1
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
    end

    def solve
      total = 0
      @lines.each do |line|
        total += calibration_value(line:)
      end
      puts(total)
    end

    def calibration_value(line:)
      digits = line.scan(/\d/)
      (digits.first + digits.last).to_i
    end
  end
end

# sample(Day1::Solver)
run(Day1::Solver)
# test(Day1::Solver)
