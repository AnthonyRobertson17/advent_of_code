module Day10
  class Instruction
    def initialize(cycles)
      @cycles = cycles
      @complete = false
    end

    def execute(_)
      @cycles -= 1
      return unless @cycles.zero?

      yield
      @complete = true
    end

    def complete?
      @complete
    end
  end

  class Addx < Instruction
    def initialize(amount)
      @amount = amount
      super(2)
    end

    def execute(cpu)
      super do
        cpu.register += @amount
      end
    end
  end

  class Noop < Instruction
    def initialize
      super(1)
    end

    def execute(_)
      super { }
    end
  end

  class Cpu
    attr_accessor :instruction_list, :register

    def initialize
      @register = 1
      @instruction_list = []
      @instruction = nil
      @cycle_count = 0
    end

    def cycle(count)
      count.times do
        start_cycle
        yield(@cycle_count)
        end_cycle
      end
    end

    def start_cycle
      @cycle_count += 1
      load_instruction if @instruction.nil?
    end

    def end_cycle
      @instruction.execute(self)
      @instruction = nil if @instruction.complete?
    end

    def load_instruction
      i, v = instruction_list.pop.split
      @instruction = if i == "noop"
                       Noop.new
                     else
                       Addx.new(v.to_i)
                     end
    end

    def signal_strength
      @cycle_count * @register
    end
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      @cpu = Cpu.new
      @sum = 0
      @cycles_to_inspect = [20, 60, 100, 140, 180, 220]
    end

    def solve
      @cpu.instruction_list = @lines.reverse
      @cpu.cycle(220) do |i|
        if @cycles_to_inspect.include?(i)
          puts("During #{i}: #{@cpu.signal_strength}")
          @sum += @cpu.signal_strength
        end
      end

      @sum
    end
  end
end

puts("===============================")
sample = Day10::Solver.new("sample.txt").solve
puts("Sample: #{sample}")
puts("===============================")
real = Day10::Solver.new("input.txt").solve
puts("Real: #{real}")
puts("===============================")
