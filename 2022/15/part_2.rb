require "../../helpers"
require "set"

class Range
  def overlap?(other)
    include?(other.min) || include?(other.max) || other.include?(min) || other.include?(max)
  end
end

def squash_ranges(ranges)
  # puts("================================")
  # puts("Squash ranges")
  # ap(ranges)

  mega_range = ranges.pop

  keep_squashing = true
  while keep_squashing
    keep_squashing = false
    ranges.size.times do
      r = ranges.pop
      if mega_range.overlap?(r)
        # puts("----------------------------------------")
        # puts("combine")
        # ap(mega_range)
        # ap(r)
        min = smaller_of(r.min, mega_range.min)
        max = larger_of(r.max, mega_range.max)
        mega_range = (min..max)
        # puts("result")
        # ap(mega_range)
        keep_squashing = true
      else
        # puts("----------------------------------------")
        # puts("skip")
        # ap(mega_range)
        # ap(r)
        ranges.prepend(r)
      end
    end
  end

  [mega_range, ranges]
end

def larger_of(a, b)
  a > b ? a : b
end

def smaller_of(a, b)
  a < b ? a : b
end

module Day15
  Coordinate = Struct.new(:y, :x)

  MIN = 0

  class Sensor
    attr_reader :location, :beacon

    def initialize(sensor_x, sensor_y, beacon_x, beacon_y)
      @location = Coordinate.new(sensor_y, sensor_x)
      @beacon = Coordinate.new(beacon_y, beacon_x)
    end

    def coverage(row, max_x)
      width_offset = distance - (location.y - row).abs
      return if width_offset.negative?

      start_x = location.x - width_offset
      end_x = location.x + width_offset

      start_x = 0 if start_x.negative?
      end_x = max_x if end_x > max_x

      (start_x..end_x)
    end

    def dump_info
      puts("==========================")
      puts("location")
      ap(location)
      puts("beacon")
      puts(beacon)
    end

    private

    def distance
      @distance ||= begin
        d = (location.x - beacon.x).abs
        d += (location.y - beacon.y).abs
        d
      end
    end
  end

  class Solver
    def initialize(file)
      @sensors = File.readlines(file, chomp: true).map { |l| Sensor.new(*l.scan(/-?\d+/).map(&:to_i)) }
    end

    def solve(max)
      first_range = nil
      remaining = nil
      y = nil
      (0..max).each do |row|
        if row % 100000 == 0
          puts("starting row ##{row}")
        end
        y = row
        covered_ranges = []
        sensors.each do |s|
          c = s.coverage(row, max)
          covered_ranges.append(c) unless c.nil?
        end
        first_range, remaining = squash_ranges(covered_ranges)
        # puts("================================")
        # ap(first_range)
        # ap(remaining)
        break unless remaining.empty?
      end

      second_range, should_be_empty = squash_ranges(remaining)

      unless should_be_empty.empty?
        puts "WAT NO"
        raise
      end

      ap(first_range)
      ap(second_range)

      if first_range.max < second_range.min
        x = first_range.max + 1
      else
        x = second_range.max + 1
      end

      # puts("================================")
      puts("y = #{y}")
      puts("x = #{x}")

      puts(tuning_frequency(x,y))
    end

    private

    def tuning_frequency(beacon_x, beacon_y)
      (beacon_x * 4_000_000) + beacon_y
    end

    attr_reader :sensors
  end
end

# sample(Day15::Solver, 20)
run(Day15::Solver, 4_000_000)
# test(DayX::Solver)
