horizontal = 0
depth = 0
aim = 0

File.readlines("input.txt", chomp: true).each do |line|
  direction, amount = line.split
  amount = amount.to_i

  case direction
  when "forward"
    horizontal += amount
    depth += aim * amount
  when "down"
    aim += amount
  when "up"
    aim -= amount
  end
end

answer = horizontal * depth

puts answer
