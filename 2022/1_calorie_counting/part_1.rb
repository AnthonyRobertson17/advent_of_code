lines = File.readlines("input.txt", chomp: true)

sum = 0
highest = 0

lines.each do |line|
  if line.empty?
    highest = sum if sum > highest
    sum = 0
  else
    sum += line.to_i
  end
end

puts("The highest amount of calories held by any elf is: #{highest}")
