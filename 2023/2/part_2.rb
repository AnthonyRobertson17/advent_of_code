require "debug"
require "../../helpers"

module Day2
  class Turn
    attr_accessor :red, :green, :blue

    def initialize(string)
      self.red = 0
      self.green = 0
      self.blue = 0
      string.split_strip(",").each do |set|
        count, colour = set.split
        send("#{colour}=", count.to_i)
      end
    end
  end

  class Game
    attr_reader :id, :turns

    def initialize(line)
      game, turns = line.split(":")
      @id = game.scan(/\d+/).last.to_i
      @turns = turns.split_strip(";").map_to(Turn)
    end

    def min(colour)
      turns.map { |t| t.send(colour) }.max
    end

    def power
      min(:red) * min(:green) * min(:blue)
    end
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
    end

    def solve
      @lines.map_to(Game).sum(&:power)
    end
  end
end

sample(DayX::Solver)
run(DayX::Solver)
# test(DayX::Solver)
