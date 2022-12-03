priority_array = ("a".."z").to_a + ("A".."Z").to_a

sum = 0
sacks = []
File.readlines("input.txt", chomp: true).each do |sack|
  sacks.append(sack.chars)
  next unless sacks.length == 3

  a = sacks[0].intersection(sacks[1])
  common = a.intersection(sacks[2]).first
  sum += priority_array.index(common) + 1
  sacks = []
end

puts sum
