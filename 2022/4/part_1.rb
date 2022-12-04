total = 0
File.readlines("input.txt", chomp: true).each do |line|
  left, right = line.split(",")
  s, e = left.split("-")
  left = (s..e).to_a

  s, e = right.split("-")
  right = (s..e).to_a

  i_size = right.intersection(left).size

  total += 1 if i_size == right.size || i_size == left.size
end

puts total
