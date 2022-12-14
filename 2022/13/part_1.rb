require "../../helpers"

module Day13
  List = Struct.new(:parent, :items)

  class PacketBuilder
    def initialize(line)
      @input = line.chars.reverse
      @current_list = nil
      @integer = nil
    end

    def build
      process_character(@input.pop) while @input.any?
      @current_list
    end

    def process_character(char)
      case char
      when "["
        new_list
      when "]"
        end_list
      when ","
        end_item
      else
        new_digit(char)
      end
    end

    def new_list
      @current_list = List.new(@current_list, [])
    end

    def end_list
      end_item unless @item.nil?
      return if @current_list.parent.nil?

      completed_list = @current_list
      @current_list = @current_list.parent

      @current_list.items.push(completed_list)
    end

    def end_item
      return if @item.nil?

      @current_list.items.push(@item.to_i)

      @item = nil
    end

    def new_digit(char)
      @item = "" if @item.nil?
      @item += char
    end
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
    end

    def solve
      pairs = build_pairs
      pairs.map! do |pair|
        left, right = pair
        in_right_order?(left, right)
      end

      sum = 0
      pairs.each_with_index do |r, i|
        sum += i + 1 if r
      end
      puts(sum)
    end

    private

    def in_right_order?(left, right)
      return false if right.nil?
      return true  if left.nil?

      if left.is_a?(List) && right.is_a?(List)
        compare_lists(left, right)
      elsif left.is_a?(List)
        right = List.new(nil, [right])
        compare_lists(left, right)
      elsif right.is_a?(List)
        left = List.new(nil, [left])
        compare_lists(left, right)
      elsif left == right
        :undecided
      else
        left < right
      end
    end

    def compare_lists(left, right)
      left_items = left.items.reverse
      right_items = right.items.reverse
      loop do
        l = left_items.pop
        r = right_items.pop
        return :undecided if l.nil? && r.nil?

        result = in_right_order?(l, r)
        return result unless result == :undecided
      end
    end

    def build_pairs
      pairs = []
      pair = []
      @lines.each do |l|
        next if l.empty?

        pair.push(PacketBuilder.new(l).build)
        next unless pair.size == 2

        pairs.push(pair)
        pair = []
      end
      pairs
    end
  end
end

sample(Day13::Solver)
run(Day13::Solver)
