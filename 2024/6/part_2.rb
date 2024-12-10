# frozen_string_literal: true

require "debug"
require_relative "../helpers"

module Day6
  WALL = "🧱"
  TEST_WALL = "🟨"
  EMPTY = "🟦"
  VISITED = "🟩"
  GUARD = "💂"

  class Position
    attr_reader :visited_directions
    attr_accessor :value

    def initialize(char)
      @value = to_emoji(char)
      @visited_directions = []
    end

    def loop_check(direction)
      visited_directions.include?(direction)
    end

    def visit(direction)
      @visited_directions.append(direction)
      @value = VISITED
    end

    def to_s
      @value
    end

    def copy
      Position.new(@value)
    end

    def to_emoji(char)
      {
        "#" => WALL,
        "." => EMPTY,
        "X" => VISITED,
      }[char] || char
    end
  end

  class Guard
    attr_reader :x, :y

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
        row.each_with_index do |position, j|
          next unless ["^", ">", "v", "<"].include?(position.value)

          @y = i
          @x = j
          @direction = DIRECTIONS[position.value]
          @direction_cycle.rotate! until @direction_cycle.last == @direction

          record_visit
          break
        end
      end
    end

    def patrol
      can_move? ? move : turn until will_move_off_map? || loop_detected?
    end

    def current_position
      @map[@y][@x]
    end

    def record_visit
      current_position.visit(@direction)
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
      return false if facing.nil?

      [VISITED, EMPTY].include?(facing.value)
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

    def loop_detected?
      can_move? && facing.loop_check(@direction)
    end
  end

  class Solver
    def initialize(file)
      @map = File.readlines(file, chomp: true).map(&:chars).map { |r| r.map_to(Position) }
      @clean_map = @map.map { |r| r.map(&:copy) }
      @guard = Guard.new(@map)
    end

    def solve
      fill_out_grid
      # @map.print_2d

      possible_obstructions
    end

    def fill_out_grid
      original_position = @map[@guard.y][@guard.x]

      @guard.patrol

      original_position.value = GUARD
    end

    def possible_obstructions
      sum = 0
      @map.each_with_index do |row, i|
        row.each_with_index do |position, j|
          next unless position.value == VISITED

          sum += 1 if possible_obstruction?(j, i)
          pp(sum)
        end
      end
      sum
    end

    def possible_obstruction?(x, y)
      m = test_map(x, y)
      # m.print_2d
      test_guard = Guard.new(m)
      test_guard.patrol
      # m.print_2d
      test_guard.loop_detected?
    end

    def test_map(x, y)
      test_map = @clean_map.map { |r| r.map(&:copy) }
      test_map[y][x].value = TEST_WALL
      test_map
    end
  end
end
