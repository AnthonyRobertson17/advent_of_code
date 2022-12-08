def up(g, y, x)
  a = g[y][x]

  score = 0
  y -= 1
  while y >= 0
    score += 1
    return score if g[y][x] >= a

    y -= 1
  end
  score
end

def down(g, y, x)
  a = g[y][x]

  score = 0
  y += 1
  while y <= g.size - 1
    score += 1
    return score if g[y][x] >= a

    y += 1
  end
  score
end

def left(g, y, x)
  a = g[y][x]

  score = 0
  x -= 1
  while x >= 0
    score += 1
    return score if g[y][x] >= a

    x -= 1
  end
  score
end

def right(g, y, x)
  a = g[y][x]

  score = 0
  x += 1
  while x <= g[0].size - 1
    score += 1
    return score if g[y][x] >= a

    x += 1
  end
  score
end

def score(g, y, x)
  up(g, y, x) * down(g, y, x) * left(g, y, x) * right(g, y, x)
end

grid = []
File.readlines("input.txt", chomp: true).each do |line|
  grid.append(line.chars.map(&:to_i))
end

scores = Array.new(grid.size) { Array.new(grid[0].size, 0) }

end_y = grid.size - 2
end_x = grid[0].size - 2

puts grid.size
puts grid[0].size
puts "====================="
grid.each_index do |y|
  grid[y].each_index do |x|
    scores[y][x] = score(grid, y, x)
  end
end

scores.each { |v| puts v.join }
puts "====================="
puts scores.map!(&:max).max
