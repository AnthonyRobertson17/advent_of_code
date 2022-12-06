c = File.readlines("input.txt", chomp: true).first.chars

i = 13
loop do
  s = i - 13
  m = c[s..i]
  break if m.uniq.size == m.size

  i += 1
end

puts i + 1
