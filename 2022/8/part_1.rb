def up?(g, y, x)
  a = g[y][x]
  y -= 1
  while y >= 0
    return false if g[y][x] >= a

    y -= 1
  end
  true
end

def down?(g, y, x)
  a = g[y][x]
  y += 1
  while y <= g.size - 1
    return false if g[y][x] >= a

    y += 1
  end
  true
end

def left?(g, y, x)
  a = g[y][x]
  x -= 1
  while x >= 0
    return false if g[y][x] >= a

    x -= 1
  end
  true
end

def right?(g, y, x)
  a = g[y][x]
  x += 1
  while x <= g[0].size - 1
    return false if g[y][x] >= a

    x += 1
  end
  true
end

def visible?(g, y, x)
  up?(g, y, x) || down?(g, y, x) || left?(g, y, x) || right?(g, y, x)
end

grid = []
File.readlines("input.txt", chomp: true).each do |line|
  grid.append(line.chars.map(&:to_i))
end

visible = Array.new(grid.size) { Array.new(grid[0].size, 1) }

end_y = grid.size - 2
end_x = grid[0].size - 2

puts grid.size
puts grid[0].size
puts "====================="
(1..end_y).each do |y|
  (1..end_x).each do |x|
    next if visible?(grid, y, x)

    visible[y][x] = 0
  end
end

visible.each { |v| puts v.join }
puts "====================="
puts visible.map!(&:sum).sum
