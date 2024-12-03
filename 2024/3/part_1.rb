require "debug"
require_relative "../helpers"

module Day3
  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true).join
    end

    def solve
      matches = find_matches
      matches.sum { |m| m[1].to_i * m[2].to_i }
    end

    def find_matches
      search = @lines
      matches = []
      offset = 0

      loop do
        match = search.match(/mul\((\d{1,3}),(\d{1,3})\)/, offset)
        break if match.nil?

        matches.push(match)
        search = match.post_match
      end

      matches
    end
  end
end
