require "../../helpers"
require "set"

module Day15
  Coordinate = Struct.new(:y, :x)

  class Sensor
    attr_reader :location, :beacon

    def initialize(sensor_x, sensor_y, beacon_x, beacon_y)
      @location = Coordinate.new(sensor_y, sensor_x)
      @beacon = Coordinate.new(beacon_y, beacon_x)
    end

    def coverage(row)
      width_offset = distance - (location.y - row).abs
      return [] if width_offset.negative?

      start_x = location.x - width_offset
      end_x = location.x + width_offset
      (start_x..end_x).to_a
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

    def solve(row)
      covered_columns = Set.new
      sensors.each { |s| covered_columns.merge(s.coverage(row)) }

      sensors.map(&:beacon).each do |b|
        covered_columns.delete(b.x) if b.y == row
      end

      puts(covered_columns.size)
    end

    private

    attr_reader :sensors
  end
end

sample(Day15::Solver, 10)
run(Day15::Solver, 2000000)
# test(DayX::Solver)
