answer = 0

buffer = []
File.readlines("input.txt", chomp: true).each do |line|
  buffer.prepend(line.to_i)
  next unless buffer.size == 4

  answer += 1 if buffer[0] > buffer[3]
  buffer.pop
end

puts answer
