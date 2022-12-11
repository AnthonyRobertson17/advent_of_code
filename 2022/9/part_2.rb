module Day9
  class RopeSolver
    attr_reader :instructions

    def initialize(file)
      @instructions = File.readlines(file, chomp: true)
      @grid = Array.new(10_000) { Array.new(10_000, 0) }
      @positions = Array.new(10) { { x: 5000, y: 5000 } }
    end

    def solve
      instructions.each do |i|
        execute_instruction(i)
      end
      @grid.map(&:sum).sum
    end

    def execute_instruction(instruction)
      direction, quantity = instruction.split
      quantity.to_i.times do
        move_head(direction)
        (1..9).each do |i|
          move_tail(i, i - 1)
        end
        record_tail
      end
    end

    def move_head(direction)
      case direction
      when "U"
        @positions[0][:y] -= 1
      when "D"
        @positions[0][:y] += 1
      when "L"
        @positions[0][:x] -= 1
      when "R"
        @positions[0][:x] += 1
      end
    end

    def move_tail(i, j)
      hy = @positions[j][:y]
      hx = @positions[j][:x]
      ty = @positions[i][:y]
      tx = @positions[i][:x]

      if hy == (ty + 2) && hx == tx
        @positions[i][:y] += 1
      elsif hy == (ty - 2) && hx == tx
        @positions[i][:y] -= 1
      elsif hx == (tx + 2) && hy == ty
        @positions[i][:x] += 1
      elsif hx == (tx - 2) && hy == ty
        @positions[i][:x] -= 1
      elsif not_touching?(hy, hx, ty, tx)
        move_tail_diagonal(i, hy, hx, ty, tx)
      end
    end

    def not_touching?(hy, hx, ty, tx)
      (hy - ty).abs == 2 || (hx - tx).abs == 2
    end

    def move_tail_diagonal(i, hy, hx, ty, tx)
      if hy > ty
        @positions[i][:y] += 1
      else
        @positions[i][:y] -= 1
      end

      if hx > tx
        @positions[i][:x] += 1
      else
        @positions[i][:x] -= 1
      end
    end

    def record_tail
      x = @positions[9][:x]
      y = @positions[9][:y]
      @grid[y][x] = 1
    end
  end
end

puts Day9::RopeSolver.new("input.txt").solve
