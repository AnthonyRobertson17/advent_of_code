require "../../helpers"

module Day12
  Coordinate = Struct.new(:y, :x)
  Possibilites = Struct.new(:up, :down, :left, :right)
  GridElement = Struct.new(:character, :num, :coordinate)

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      @path = []
      @shortest_path = nil
      @shortest_path_length = 999_999_999
      setup
    end

    def setup
      create_grid
      create_move_grid
    end

    def create_grid
      @lines = @lines.map(&:chars)
      @grid = Array.new(@lines.size) { Array.new(@lines.first.size) }

      @lines.each_with_index do |row, y|
        row.each_with_index do |i, x|
          num = case i
                when "S"
                  "a".ord
                when "E"
                  "z".ord
                else
                  i.ord
                end
          @grid[y][x] = GridElement.new(i, num, Coordinate.new(y, x))
        end
      end

      @grid.each_with_index do |row, y|
        row.each_with_index do |n, x|
          if n.character == "S"
            @start = n.coordinate
          elsif n.character == "E"
            @end = n.coordinate
          end
        end
      end
    end

    def create_move_grid
      @move_grid = Array.new(@grid.size) { Array.new(@grid.first.size) }
      @grid.each_with_index do |row, y|
        row.each_index do |x|
          @move_grid[y][x] = Possibilites.new(
            up?(y, x),
            down?(y, x),
            left?(y, x),
            right?(y, x),
          )
        end
      end
    end

    def up?(y, x)
      return false if y.zero?

      i = @grid[y][x]
      j = @grid[y - 1][x]

      j.num <= i.num + 1
    end

    def down?(y, x)
      return false if y == (@grid.size - 1)

      i = @grid[y][x]
      j = @grid[y + 1][x]

      j.num <= i.num + 1
    end

    def left?(y, x)
      return false if x.zero?

      i = @grid[y][x]
      j = @grid[y][x - 1]

      j.num <= i.num + 1
    end

    def right?(y, x)
      return false if x == (@grid.first.size - 1)

      i = @grid[y][x]
      j = @grid[y][x + 1]

      j.num <= i.num + 1
    end

    def solve
      traverse(@start)
      puts @shortest_path_length
    end

    def traverse(coordinate)
      @path.push(coordinate)
      if at_the_finish?
        # puts "Found path length: #{@path.length}"
        @path.pop
        if @path.length < @shortest_path_length
          @shortest_path_length = @path.length
        end
      else
        traverse_up
        traverse_down
        traverse_left
        traverse_right
        @path.pop
      end
    end

    def at_the_finish?
      @path.last == @end
    end

    def traverse_up
      i = @path.last
      return unless @move_grid[i.y][i.x].up

      x = i.x
      y = i.y - 1
      coordinate = Coordinate.new(y, x)
      return if @path.include?(coordinate)

      traverse(coordinate)
    end

    def traverse_down
      i = @path.last
      return unless @move_grid[i.y][i.x].down

      x = i.x
      y = i.y + 1
      coordinate = Coordinate.new(y, x)
      return if @path.include?(coordinate)

      traverse(coordinate)
    end

    def traverse_left
      i = @path.last
      return unless @move_grid[i.y][i.x].left

      x = i.x - 1
      y = i.y
      coordinate = Coordinate.new(y, x)
      return if @path.include?(coordinate)

      traverse(coordinate)
    end

    def traverse_right
      i = @path.last
      return unless @move_grid[i.y][i.x].right

      x = i.x + 1
      y = i.y
      coordinate = Coordinate.new(y, x)
      return if @path.include?(coordinate)

      traverse(coordinate)
    end
  end
end

run(Day12::Solver)
