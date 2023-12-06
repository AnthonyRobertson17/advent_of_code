require "../../helpers"
require "debug"

module Day1
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
    end

    def solve
      @lines.sum { |line| calibration_value(line:) }
    end

    def calibration_value(line:)
      tokens = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten
      (convert_to_digit(token: tokens.first) + convert_to_digit(token: tokens.last)).to_i
    end

    def convert_to_digit(token:)
      {
        "one" => "1",
        "two" => "2",
        "three" => "3",
        "four" => "4",
        "five" => "5",
        "six" => "6",
        "seven" => "7",
        "eight" => "8",
        "nine" => "9",
      }[token] || token
    end
  end
end

# sample(Day1::Solver)
sample2(Day1::Solver)
run(Day1::Solver)
# test(Day1::Solver)
