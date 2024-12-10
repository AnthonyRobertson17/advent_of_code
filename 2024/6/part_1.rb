require "debug"
require_relative "../helpers"

module Day6
  class Guard
    def initialize(map)
      @map = map
      @direction_cycle = [:up, :right, :down, :left]
      set_position
    end

    DIRECTIONS = {
      "^" => :up,
      ">" => :right,
      "v" => :down,
      "<" => :left,
    }

    def set_position
      @map.each_with_index do |row, i|
        row.each_with_index do |val, j|
          next unless ["^", ">", "v", "<"].include?(val)

          @y = i
          @x = j
          @direction = DIRECTIONS[val]
          @direction_cycle.rotate! until @direction_cycle.last == @direction

          record_visit
          break
        end
      end
    end

    def patrol
      can_move? ? move : turn until will_move_off_map?
    end

    def record_visit
      @map[@y][@x] = "X"
    end

    def facing
      case @direction
      when :up
        return nil if @y.zero?

        @map.dig(@y - 1, @x)
      when :down
        @map.dig(@y + 1, @x)
      when :left
        return nil if @x.zero?

        @map.dig(@y, @x - 1)
      when :right
        @map.dig(@y, @x + 1)
      end
    end

    def can_move?
      ['X', '.'].include?(facing)
    end

    def will_move_off_map?
      facing.nil?
    end

    def move
      case @direction
      when :up
        @y -= 1
      when :down
        @y += 1
      when :left
        @x -= 1
      when :right
        @x += 1
      end

      record_visit
    end

    def turn
      @direction = @direction_cycle.first
      @direction_cycle.rotate!
    end

    def total_moves
      @map.sum { |row| row.count("X") }
    end
  end

  class Solver
    def initialize(file)
      @map = File.readlines(file, chomp: true).map(&:chars)
      @guard = Guard.new(@map)
    end

    def solve
      @guard.patrol
      @guard.total_moves
    end
  end
end
