require "../../helpers"

module Day12
  Coordinate = Struct.new(:y, :x)

  class Node
    attr_accessor :distance

    def initialize(distance:, end_node:)
      self.distance = distance
      @neighbors = []
      @end_node = end_node
    end

    def add_neighbor(node)
      @neighbors.push(node)
    end

    def consider_distance(new_distance)
      self.distance = new_distance if new_distance < distance
    end

    def visit
      @neighbors.each do |n|
        n.consider_distance(distance + 1)
      end
    end

    def end_node?
      @end_node
    end
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true).map(&:chars)
      @comparable_grid = build_comparable_grid
      @graph = build_graph
    end

    def solve
      node = nil
      loop do
        node = next_node
        break if node.end_node?

        node.visit
      end
      puts(node.distance)
    end

    private

    def next_node
      @graph.sort! { |a, b| b.distance <=> a.distance }.pop
    end

    def build_comparable_grid
      @lines.map do |row|
        row.map do |i|
          case i
          when "S"
            "a".ord
          when "E"
            "z".ord
          else
            i.ord
          end
        end
      end
    end

    def build_graph
      @node_grid = Array.new(@lines.size) { Array.new(@lines.first.size) }

      @lines.each_with_index do |row, y|
        row.each_with_index do |i, x|
          distance = ["S", "a"].include?(i) ? 0 : 999_999
          end_node = i == "E"
          @node_grid[y][x] = Node.new(distance:, end_node:)
        end
      end

      @comparable_grid.each_with_index do |row, y|
        row.each_with_index do |i, x|
          if y > 0
            j = @comparable_grid[y - 1][x]
            if j <= i + 1
              @node_grid[y][x].add_neighbor(@node_grid[y - 1][x])
            end
          end

          if y < @comparable_grid.size - 1
            j = @comparable_grid[y + 1][x]
            if j <= i + 1
              @node_grid[y][x].add_neighbor(@node_grid[y + 1][x])
            end
          end

          if x > 0
            j = @comparable_grid[y][x - 1]
            if j <= i + 1
              @node_grid[y][x].add_neighbor(@node_grid[y][x - 1])
            end
          end

          if x < @comparable_grid.first.size - 1
            j = @comparable_grid[y][x + 1]
            if j <= i + 1
              @node_grid[y][x].add_neighbor(@node_grid[y][x + 1])
            end
          end
        end
      end

      @node_grid.flatten
    end

    def print_node_grid
      puts ""
      @node_grid.each do |row|
        x = row.map do |i|
          i.distance == 999_999 ? "-" : i.distance
        end.join("|")
        puts(x)
      end
    end
  end
end

run(Day12::Solver)
