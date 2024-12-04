require "debug"
require_relative "../helpers"

module Day4
  class Check
    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(grid, x, y)
      @grid = grid
      @x = x
      @y = y
    end

    def call
      return 0 if @x > max_starting_x
      return 0 if @x < 1
      return 0 if @y > max_starting_y
      return 0 if @y < 1
      return 0 if @grid.dig(@y, @x) != "A"
      return 0 if [top_left, bottom_right].sort.join != "MS"
      return 0 if [top_right, bottom_left].sort.join != "MS"

      1
    end

    def top_left
      @grid.dig(@y - 1, @x - 1)
    end

    def top_right
      @grid.dig(@y - 1, @x + 1)
    end

    def bottom_left
      @grid.dig(@y + 1, @x - 1)
    end

    def bottom_right
      @grid.dig(@y + 1, @x + 1)
    end

    def max_starting_x
      @max_starting_x ||= @grid.first.size - 2
    end

    def max_starting_y
      @max_starting_y ||= @grid.size - 2
    end
  end

  class Solver
    def initialize(file)
      @grid = File.readlines(file, chomp: true).map(&:chars)
      @log = @grid.map { |row| row.dup.fill('.') }
    end

    def solve
      count = 0

      @grid.each_index do |y|
        @grid[y].each_index do |x|
          count += Check.call(@grid, x, y)
        end
      end

      count
    end
  end
end
