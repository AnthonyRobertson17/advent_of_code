lines = File.readlines("input.txt", chomp: true)

sum = 0
top = Array.new(3, 0)

lines.each do |line|
  if line.empty?
    if sum > top[2]
      top[2] = sum
    end
    if top[2] > top[1]
      top[1], top[2] = top[2], top[1]
    end
    if top[1] > top[0]
      top[0], top[1] = top[1], top[0]
    end
    sum = 0
  else
    sum += line.to_i
  end
end

puts("The total amount of calories held by the top three elves is: #{top.sum}")
