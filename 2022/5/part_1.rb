def parse_input(lines)
  stack_count = 0
  stack_defs = []
  instructions = []
  lines.each do |line|
    if line.include?("[")
      stack_defs.append(line)
    elsif line.split[0] == "1"
      stack_count = line.split.last.to_i
    elsif !line.empty?
      instructions.append(line)
    end
  end

  stacks = Array.new(stack_count) { [] }
  stack_defs.reverse!
  stack_defs.each do |d|
    d.chars.each_with_index do |c, i|
      unless "[] ".include?(c)
        stacks[(i - 1) / 4].push(c)
      end
    end
  end

  [stacks, instructions]
end

lines = File.readlines("input.txt", chomp: true)

stacks, instructions = parse_input(lines)

instructions.each do |i|
  _, count, _, from, _, to = i.split

  count.to_i.times do
    x = stacks[from.to_i - 1].pop
    stacks[to.to_i - 1].push(x)
  end
end

puts stacks.map(&:last).join
