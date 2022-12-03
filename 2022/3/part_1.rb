priority_array = ("a".."z").to_a + ("A".."Z").to_a
sum = 0

File.readlines("input.txt", chomp: true).each do |sack|
  half = sack.length / 2.0
  left = sack.slice(0..half - 1).chars
  right = sack.slice(half...).chars
  common = left.intersection(right).first
  sum += priority_array.index(common) + 1
end

puts sum
