module Day9
  class RopeSolver
    attr_reader :instructions

    def initialize(file)
      @instructions = File.readlines(file, chomp: true)
      @grid = Array.new(10000) { Array.new(10000, 0) }
      @hy = 5000
      @hx = 5000
      @ty = 5000
      @tx = 5000
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
        move_tail
        record_tail
      end
    end

    def move_head(direction)
      case direction
      when "U"
        @hy -= 1
      when "D"
        @hy += 1
      when "L"
        @hx -= 1
      when "R"
        @hx += 1
      end
    end

    def move_tail
      if @hy == (@ty + 2) && @hx == @tx
        @ty += 1
      elsif @hy == (@ty - 2) && @hx == @tx
        @ty -= 1
      elsif @hx == (@tx + 2) && @hy == @ty
        @tx += 1
      elsif @hx == (@tx - 2) && @hy == @ty
        @tx -= 1
      elsif not_touching?
        move_tail_diagonal
      end
    end

    def not_touching?
      (@hy - @ty).abs == 2 || (@hx - @tx).abs == 2
    end

    def move_tail_diagonal
      if @hy > @ty
        @ty += 1
      else
        @ty -= 1
      end

      if @hx > @tx
        @tx += 1
      else
        @tx -= 1
      end
    end

    def record_tail
      @grid[@ty][@tx] = 1
    end

    def print_grid
      puts("==============================")
      @grid.each { |row| puts(row.join) }
      puts("==============================")
    end

    def print_positions
      puts("==============================")
      @grid.each_with_index do |row, y|
        to_print = ""
        row.each_index do |x|
          if @hy == y && @hx == x
            to_print += "H"
          elsif @ty == y && @tx == x
            to_print += "T"
          else
            to_print += "."
          end
        end
        puts(to_print)
      end
      puts("==============================")
    end
  end
end

puts Day9::RopeSolver.new("input.txt").solve
