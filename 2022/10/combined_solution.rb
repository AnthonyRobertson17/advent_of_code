module Day10
  class Instruction
    def initialize(remaining_cycles)
      @remaining_cycles = remaining_cycles
      @complete = false
    end

    def execute
      @remaining_cycles -= 1
      return unless @remaining_cycles.zero?

      finish_execution
    end

    def complete?
      @complete
    end

    private

    def finish_execution
      @complete = true
    end
  end

  class Addx < Instruction
    def initialize(cpu, amount)
      @cpu = cpu
      @amount = amount
      super(2)
    end

    private

    def finish_execution
      @cpu.register += @amount
      super
    end
  end

  class Noop < Instruction
    def initialize
      super(1)
    end
  end

  class Cpu
    attr_accessor :instruction_list, :register
    attr_reader :total_signal_strength

    def initialize
      @register = 1
      @instruction_list = []
      @instruction = nil
      @current_cycle = 0
      @total_signal_strength = 0
      @inspection_cycles = [20, 60, 100, 140, 180, 220]
      @crt = Array.new(240, "⬛️")
    end

    def execute_cycle
      start_cycle
      analyze_signal_strength
      light_pixel
      end_cycle
    end

    def start_cycle
      @current_cycle += 1
      load_instruction if @instruction.nil? || @instruction.complete?
    end

    def end_cycle
      @instruction.execute
    end

    def load_instruction
      @instruction = instruction_list.pop
    end

    def signal_strength
      @current_cycle * @register
    end

    def analyze_signal_strength
      return unless @inspection_cycles.include?(@current_cycle)

      @total_signal_strength += signal_strength
    end

    def sprite_being_drawn?
      s = @register - 1
      e = @register + 1
      (s..e).cover?(drawing_position)
    end

    def light_pixel
      return unless sprite_being_drawn?

      @crt[cycle_index] = "🟨"
    end

    def drawing_position
      cycle_index % 40
    end

    def cycle_index
      @current_cycle - 1
    end

    def render_crt
      @crt.each_slice(40) { |s| puts(s.join) }
    end
  end

  class Solver
    def initialize(file)
      @cpu = Cpu.new
      @cpu.instruction_list = File.readlines(file, chomp: true).reverse.map { |l| build_instruction(l) }
    end

    def solve
      240.times { @cpu.execute_cycle }
      puts("Part 1: #{@cpu.total_signal_strength}")
      puts("Part 2:")
      @cpu.render_crt
    end

    def build_instruction(str)
      i, v = str.split
      return Noop.new if i == "noop"

      Addx.new(@cpu, v.to_i)
    end
  end
end

puts("sample.txt")
Day10::Solver.new("sample.txt").solve
puts("")
puts("input.txt")
Day10::Solver.new("input.txt").solve
