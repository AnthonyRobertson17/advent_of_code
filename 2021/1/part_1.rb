answer = 0
previous = nil

File.readlines("input.txt", chomp: true).each do |line|
  current = line.to_i
  answer += 1 unless previous.nil? || previous >= current
  previous = current
end

puts answer
