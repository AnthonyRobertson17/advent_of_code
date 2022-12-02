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
  "A" => {
    "X" => :draw,
    "Y" => :win,
    "Z" => :loss,
  },
  "B" => {
    "X" => :loss,
    "Y" => :draw,
    "Z" => :win,
  },
  "C" => {
    "X" => :win,
    "Y" => :loss,
    "Z" => :draw,
  },
}

total_score = 0

lines.each do |line|
  their, our = line.split
  total_score += shape_scores[our]
  total_score += outcome_scores[outcome_lookup.dig(their, our)]
end

puts total_score
