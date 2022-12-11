module Day11
  class Monkey
    attr_accessor :items, :test_divisor, :rules, :operation, :inspections

    Operation = Struct.new(:operand, :factor)

    def initialize
      self.rules = {
        true => nil,
        false => nil,
      }
      self.inspections = 0
    end

    def set_rule(result, destination)
      rules[result] = destination
    end

    def set_operation(operand, factor)
      factor = factor == "old" ? nil : factor.to_i
      self.operation = Operation.new(operand, factor)
    end

    def inspect_item(i)
      factor = operation.factor || items[i]
      case operation.operand
      when "*"
        items[i] = items[i] * factor
      when "+"
        items[i] = items[i] + factor
      end
      self.inspections += 1
    end

    def keep_it_reasonable(i, amount)
      items[i] = items[i] % amount
    end

    def test(i)
      (items[i] % test_divisor).zero?
    end
  end

  class Solver
    attr_reader :lines
    attr_accessor :monkeys

    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      self.monkeys = []
    end

    def solve(round_count)
      define_monkeys
      round_count.times { |i| execute_round(i) }
      print_inspection_counts(round_count)
      puts(monkey_business)
    end

    def execute_round(i)
      monkeys.each { |m| monkey_turn(m) }
    end

    def monkey_business
      a, b = monkeys.map(&:inspections).sort.reverse[...2]
      a * b
    end

    def reasonable_amount
      return @reasonable_amount if @reasonable_amount

      @reasonable_amount = 1
      monkeys.each { |m| @reasonable_amount *= m.test_divisor }
      @reasonable_amount
    end

    def monkey_turn(monkey)
      while monkey.items.any?
        monkey.inspect_item(0)
        monkey.keep_it_reasonable(0, reasonable_amount)
        result = monkey.test(0)
        destination = monkey.rules[result]
        monkeys[destination].items.append(monkey.items.delete_at(0))
      end
    end

    def define_monkeys
      lines.each_slice(7) { |l| monkeys.append(define_monkey(l.to_a)) }
    end

    def define_monkey(lines)
      monkey = Monkey.new
      lines.each_with_index do |l, i|
        _, data = l.split(":")
        case i
        when 1
          monkey.items = data.split(",").map(&:to_i)
        when 2
          operand, factor = data.split[3...]
          monkey.set_operation(operand, factor)
        when 3
          monkey.test_divisor = data.split.last.to_i
        when 4
          monkey.set_rule(true, data.split.last.to_i)
        when 5
          monkey.set_rule(false, data.split.last.to_i)
        end
      end
      monkey
    end

    def print_inspection_counts(round)
      puts "after round #{round}:"
      monkeys.each_with_index { |m, i| puts "monkey #{i}: #{m.inspections}" }
    end

    def print_worry_levels(round)
      puts "after round #{round}:"
      monkeys.each_with_index { |m, i| puts "monkey #{i}: #{m.items.join(", ")}" }
    end

    def print_monkeys
      monkeys.each_with_index do |m, i|
        puts "========================="
        puts i
        puts "items: #{m.items.join(", ")}"
        puts "operation: #{m.operation.operand} #{m.operation.factor}"
        puts "test_divisor: #{m.test_divisor}"
        puts "true: #{m.rules[true]}"
        puts "false: #{m.rules[false]}"
      end
    end
  end
end

# Day11::Solver.new("input.txt", true).solve(20)
Day11::Solver.new("input.txt").solve(10000)
