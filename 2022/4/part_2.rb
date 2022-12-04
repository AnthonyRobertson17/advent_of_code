total = 0
File.readlines("input.txt", chomp: true).each do |line|
  left, right = line.split(",")
  s, e = left.split("-")
  left = (s..e).to_a

  s, e = right.split("-")
  right = (s..e).to_a

  total += 1 unless right.intersection(left).empty?
end

puts total
