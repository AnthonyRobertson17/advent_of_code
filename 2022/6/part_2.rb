input = File.readlines("input.txt", chomp: true).first.chars

e = 13
loop do
  s = e - 13
  m = c[s..e]
  break if m.uniq.size == m.size

  e += 1
end

puts e + 1
