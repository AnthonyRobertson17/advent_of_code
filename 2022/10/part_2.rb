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
      @crt = Array.new(240, "⬛️")
    end

    def cycle(count)
      count.times do
        start_cycle
        light_pixel if sprite_being_drawn?
        end_cycle
      end
    end

    def start_cycle
      load_instruction if @instruction.nil?
    end

    def end_cycle
      @instruction.execute(self)
      @instruction = nil if @instruction.complete?
      @cycle_count += 1
    end

    def load_instruction
      i, v = instruction_list.pop.split
      @instruction = if i == "noop"
                       Noop.new
                     else
                       Addx.new(v.to_i)
                     end
    end

    def sprite_being_drawn?
      s = @register - 1
      e = @register + 1
      (s..e).cover?(drawing_position)
    end

    def light_pixel
      @crt[@cycle_count] = "🟨"
    end

    def drawing_position
      @cycle_count % 40
    end

    def render_crt
      @crt.each_slice(40) { |s| puts(s.join) }
    end
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true)
      @cpu = Cpu.new
      @sum = 0
    end

    def solve
      @cpu.instruction_list = @lines.reverse
      @cpu.cycle(240)
      @cpu.render_crt
    end
  end
end

puts("===============================")
Day10::Solver.new("sample.txt").solve
puts("===============================")
Day10::Solver.new("input.txt").solve
puts("===============================")
