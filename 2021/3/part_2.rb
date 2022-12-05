def most_common(lines, index)
  tally(lines, index).negative? ? "0" : "1"
end

def least_common(lines, index)
  tally(lines, index).negative? ? "1" : "0"
end

def tally(lines, index)
  t = 0
  lines.each do |l|
    if l[index] == "0"
      t -= 1
    else
      t += 1
    end
  end
  t
end

lines = File.readlines("input.txt", chomp: true)
lines.map(&:chars)

i = 0
olines = lines
while olines.size > 1
  c = most_common(olines, i)
  olines.keep_if { |l| l[i] == c }

  i += 1
end



gamma = gamma.to_i(2)
epsilon = epsilon.to_i(2)

answer = gamma * epsilon

puts answer
