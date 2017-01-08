class Player
  include FormatInfo
  attr_accessor :move, :score, :name

  def initialize
    @score = 0
    set_name
  end
end

class Human < Player
  def set_name
    user_name = nil
    loop do
      prompt "Please enter your name (only alphanumerical characters are permitted):"
      user_name = gets.chomp
      break if user_name =~ /^[A-Za-z0-9]+$/
    end
    @name = user_name
    clear_screen
  end

  def choose
    self.move = Move.new(ask_user_choice)
    clear_screen
  end

  def ask_user_choice
    loop do
      choice_request
      case gets.chomp.downcase
      when "r", "rock" then return "r"
      when "p", "paper" then return "p"
      when "s", "scissors" then return "s"
      when "l", "lizard" then return "l"
      when "k", "spock" then return "k"
      else prompt "Sorry, invalid choice."
      end
    end
  end

  def choice_request
    puts <<-EOF
     Please choose one move:

     - (r)ock
     - (p)aper
     - (s)cissors
     - (l)izard
     - spoc(k)
    EOF
  end
end

class Computer < Player
  attr_accessor :history, :freq

  def initialize(history)
    @history = history
    set_name
    @freq = { "p"=>0.2, "s"=>0.2, "l"=>0.2, "k"=>0.2, "r"=>0.2 }
  end

  def set_name
    @name = "Computer"
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys.sample)
  end

  private

  def weighted_sample
    freq.max_by { |_, weight| rand ** (1.0 / weight) }.first
  end

  def remove_loss_move(loss_move)
      moves_array = Move::AVAILABLE_MOVES.keys.reject do |move| 
        move == Move::AVAILABLE_MOVES.key(loss_move)
      end
      Move.new(moves_array.sample)
  end
end

class R2D2 < Computer
  def set_name
    @name = "R2D2"
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys[0..2].sample)
  end
end

class Hal < Computer
  def set_name
    @name = "Hal"
  end

  def choose
    comp_moves = history.player_moves_number
    loss_moves_freq = history.computer_moves_frequencies("loss")
    loss_move = loss_moves_freq.max_by { |_, freq| freq }
    if comp_moves >= 5 && loss_move[1] > 0.2
      self.move = remove_loss_move(loss_move[0])
    else
      self.move = Move.new(Move::AVAILABLE_MOVES.keys.sample)
    end
  end
end

class Chappie < Computer
  def set_name
    @name = "Chappie"
  end

  def choose
    comp_moves = history.player_moves_number
    if comp_moves % 5 == 0 && comp_moves % 2 == 1 && comp_moves > 1
      efficiency = history.moves_efficiency
      most_efficient_move = Move::AVAILABLE_MOVES.key(efficiency.first[0])
      #less_efficient_move = Move::AVAILABLE_MOVES.key(efficiency.last[0])
      @freq.each do |move, _|
        if move == most_efficient_move
          @freq[move] = 0.60
        else
          @freq[move] = 0.10
        end
      end
    end
      self.move = Move.new(weighted_sample)
  end
end

class Sonnie < Computer
  def set_name
    @name = "Sonnie"
  end

  def choose
    @freq = {"p"=>0.05, "s"=>0.05, "l"=>0.05, "k"=>0.05, "r"=>0.8}
    self.move = Move.new(weighted_sample)
  end

end

class Number5 < Computer
  def set_name
    @name = "Number 5"
  end
end

#freq = {"p"=>0.1, "s"=>0.1, "l"=>0.1, "k"=>0.2, "r"=>0.5}

#def weighted_sample(freq)
#  freq.max_by { |_, weight| rand ** (1.0 / weight) }.first
#end

#freqs = 100_000.times.each_with_object(Hash.new(0)) { |_, hash| hash[weighted_sample(freq)] += 1 }

#p freqs.map { |move, count| [move, count / 100_000.0] }.to_h





