# frozen_string_literal: true

require "../../helpers"

module Day14
  Coordinate = Struct.new(:y, :x)

  AIR = "⬛"
  ROCK = "⬜"
  SAND = "🟫"
  OVERFLOW_SAND = "🟩"
  SAND_POUR_INDICATOR = "🪣"

  class Cave
    attr_reader :sand_units

    def initialize(width, height, x_offset)
      @pour_x = 500 - x_offset + width + 1
      @x_offset = x_offset - height - 1

      height += 1
      width += 2 * height

      @grid = Array.new(height) { Array.new(width, AIR) }.push(Array.new(width, ROCK))
      @sand_units = 0
      @complete = false
    end

    def add_rock_line(start_coordinate, end_coordinate)
      start_coordinate, end_coordinate = apply_offset(start_coordinate, end_coordinate)
      x_step = end_coordinate.x <=> start_coordinate.x
      y_step = end_coordinate.y <=> start_coordinate.y
      i = start_coordinate

      loop do
        grid[i.y][i.x] = ROCK
        break if i == end_coordinate

        i.x += x_step
        i.y += y_step
      end
    end

    def draw
      puts `clear`
      puts(("⬛" * pour_x) + SAND_POUR_INDICATOR)
      grid.each do |row|
        puts(row.join)
      end
      sleep(0.05)
    end

    def pour_sand
      x = apply_offset(Coordinate.new(0, 500)).first
      add_sand_unit while grid[x.y][x.x] == AIR
    end

    def add_sand_unit
      sand = apply_offset(Coordinate.new(0, 500)).first
      grid[sand.y][sand.x] = SAND
      loop do
        check_for_overflow(sand)
        if overflowing
          grid[sand.y][sand.x] = OVERFLOW_SAND
          return
        end

        next if drop_sand(sand, 0)
        next if drop_sand(sand, -1)
        next if drop_sand(sand, 1)

        @sand_units += 1
        break
      end
    end

    def drop_sand(sand, x_delta)
      return false if grid[sand.y + 1][sand.x + x_delta] != AIR

      grid[sand.y][sand.x] = AIR
      sand.y += 1
      sand.x += x_delta
      grid[sand.y][sand.x] = SAND
    end

    def check_for_overflow(sand)
      y = sand.y + 1
      x = sand.x
      if y == grid.size
        overflow
        return
      else
        return if grid[y][x] == AIR
      end

      x = sand.x - 1
      if x < 0
        overflow
        return
      else
        return if grid[y][x] == AIR
      end

      overflow if sand.x == grid.first.size - 1
    end

    def overflow
      @complete = true
    end

    private

    attr_reader :x_offset, :grid, :overflowing, :pour_x

    def apply_offset(*coordinates)
      coordinates.map(&:dup).map do |c|
        c.x -= x_offset
        c
      end
    end
  end

  class Solver
    def initialize(file)
      @scans = File.readlines(file, chomp: true).map do |l|
        l.split("->").map(&:strip).map { |i| Coordinate.new(*i.split(",").map(&:to_i).reverse) }
      end
      @cave = setup_cave
      insert_rocks
    end

    def solve
      cave.pour_sand
      puts(cave.sand_units)
    end

    private

    attr_reader :scans, :cave

    def insert_rocks
      scans.each do |scan|
        scan.each_with_index do |coordinate, i|
          next_coordinate = scan[i + 1]
          if next_coordinate.is_a?(Coordinate)
            cave.add_rock_line(coordinate, next_coordinate)
          end
        end
      end
    end

    def setup_cave
      all_coords = scans.flatten
      min_x, max_x = all_coords.minmax { |a, b| a.x <=> b.x }.map(&:x)
      height = all_coords.max { |a, b| a.y <=> b.y }.y + 1
      width = max_x - min_x + 1

      Cave.new(width, height, min_x)
    end
  end
end

sample(Day14::Solver)
run(Day14::Solver)
# test(Day14::Solver)
