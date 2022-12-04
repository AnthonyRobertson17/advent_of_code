horizontal = 0
depth = 0

File.readlines("input.txt", chomp: true).each do |line|
  direction, amount = line.split
  amount = amount.to_i

  case direction
  when "forward"
    horizontal += amount
  when "down"
    depth += amount
  when "up"
    depth -= amount
  end
end

answer = horizontal * depth

puts answer
