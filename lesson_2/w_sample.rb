freq = {"p"=>0.1, "s"=>0.1, "l"=>0.1, "k"=>0.2, "r"=>0.5}

def weighted_sample(freq)
  freq.max_by { |_, weight| rand ** (1.0 / weight) }.first
end

freqs = 100_000.times.each_with_object(Hash.new(0)) { |_, hash| hash[weighted_sample(freq)] += 1 }

p freqs.map { |move, count| [move, count / 100_000.0] }.to_h