input = File.readlines("input.txt", chomp: true).first.chars

e = 3
loop do
  s = e - 3
  m = input[s..e]
  break if m.uniq.size == m.size

  e += 1
end

puts e + 1
