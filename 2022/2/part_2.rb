lines = File.readlines("input.txt", chomp: true)

shape_scores = {
  "X" => 1,
  "Y" => 2,
  "Z" => 3,
}

outcome_scores = {
  win: 6,
  draw: 3,
  loss: 0,
}

outcome_lookup = {
  "X" => :loss,
  "Y" => :draw,
  "Z" => :win,
}

shape_lookup = {
  "A" => {
    win: "Y",
    draw: "X",
    loss: "Z",
  },
  "B" => {
    win: "Z",
    draw: "Y",
    loss: "X",
  },
  "C" => {
    win: "X",
    draw: "Z",
    loss: "Y",
  },
}

total_score = 0

lines.each do |line|
  their, our = line.split

  outcome = outcome_lookup[our]
  shape = shape_lookup.dig(their, outcome)

  total_score += shape_scores[shape]
  total_score += outcome_scores[outcome]
end

puts total_score
