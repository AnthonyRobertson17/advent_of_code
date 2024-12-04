require "debug"
require_relative "../helpers"

CHARS = "XMAS".chars

module Day4
  class Check
    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(grid, x, y, dx, dy)
      @grid = grid
      @x = x
      @y = y
      @dx = dx
      @dy = dy
    end

    def call
      CHARS.each do |c|
        if @x >= 0 && @y >= 0 && @grid.dig(@y, @x) == c
          @x += @dx
          @y += @dy
        else
          return 0
        end
      end

      1
    end
  end

  class Solver
    def initialize(file)
      @grid = File.readlines(file, chomp: true).map(&:chars)
      @log = @grid.map { |row| row.dup.fill('.') }
    end

    PATHS = [
      [1, 0],
      [1, 1],
      [0, 1],
      [-1, 1],
      [-1, 0],
      [-1, -1],
      [0, -1],
      [1, -1],
    ]

    def solve
      count = 0
      @grid.each_index do |y|
        @grid[y].each_index do |x|
          count += count_at(x, y)
        end
      end

      dump(@log)

      count
    end

    def count_at(x, y)
      PATHS.map do |dx, dy|
        result = Check.call(@grid, x, y, dx, dy)
        log(x, y, dx, dy) if result == 1
        result
      end.sum
    end

    def log(x, y, dx, dy)
      4.times do
        @log[y][x] = @grid[y][x]
        x += dx
        y += dy
      end
    end

    def dump(grid)
      puts("=============================")
      grid.each do |row|
        puts(row.join(''))
      end
    end
  end
end
