tally = nil
File.readlines("input.txt", chomp: true).each do |line|
  tally = Array.new(line.length, 0) if tally.nil?
  line.chars.each_with_index do |bit, i|
    if bit == "0"
      tally[i] -= 1
    else
      tally[i] += 1
    end
  end
end

gamma = ""
epsilon = ""

tally.each do |count|
  if count.positive?
    gamma += "1"
    epsilon += "0"
  else
    gamma += "0"
    epsilon += "1"
  end
end

gamma = gamma.to_i(2)
epsilon = epsilon.to_i(2)

answer = gamma * epsilon

puts answer
