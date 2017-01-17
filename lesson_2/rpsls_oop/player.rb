# Player class
# Human class
# Computer class
# R2D2 class
# Hal class
# Chappie class
# Sonnie class
# Number5 class

class Player
  include Displayable

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
      prompt "Please enter your name (only alphanumerical characters " \
             "are allowed):"
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

  private

  def ask_user_choice
    loop do
      choice_request
      case gets.chomp.downcase
      when "r", "rock" then return :rock
      when "p", "paper" then return :paper
      when "s", "scissors" then return :scissors
      when "l", "lizard" then return :lizard
      when "k", "spock" then return :spock
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
  attr_accessor :history, :freq, :score

  def initialize(history)
    @score = 0
    @history = history
    set_name
    @freq = { paper: 0.2,
              scissors: 0.2,
              lizard: 0.2,
              spock: 0.2,
              rock: 0.2 }
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys.sample)
  end

  private

  def weighted_sample
    freq.max_by { |_, weight| rand**(1.0 / weight) }.first
  end

  def remove_loss_move(loss_move)
    moves_array = Move::AVAILABLE_MOVES.keys.reject do |move|
      move == loss_move
    end
    Move.new(moves_array.sample)
  end
end

# It chooses only between Rock, Paper and Scissors
class R2D2 < Computer
  def set_name
    @name = "R2D2"
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys[0..2].sample)
  end
end

# After 5 moves it checks if the loss frequency of a move is higher
# than 20%; in that case it removes the move from the available ones
# and chooses only between the remaining four.
class Hal < Computer
  def set_name
    @name = "Hal"
  end

  def choose
    comp_moves = history.player_moves_number
    loss_moves_freq = history.computer_moves_frequencies("loss")
    loss_move = loss_moves_freq.max_by { |_, freq| freq }
    self.move = if comp_moves >= 5 && loss_move[1] > 0.2
                  remove_loss_move(loss_move[0])
                else
                  Move.new(Move::AVAILABLE_MOVES.keys.sample)
                end
  end
end

# Every 5 moves it checks the efficiency of each move; than it increases
# the weight for the most efficient move.
class Chappie < Computer
  def set_name
    @name = "Chappie"
  end

  def choose
    comp_moves = history.player_moves_number
    if (comp_moves % 5).zero? && comp_moves > 1
      efficiency = history.moves_efficiency
      most_efficient_move = efficiency.first[0]
      freq.each do |move, _|
        freq[move] = if move == most_efficient_move
                        0.60
                      else
                        0.10
                      end
      end
    end
    self.move = Move.new(weighted_sample)
  end
end

# It has a very high tendency to choose Rock
class Sonnie < Computer
  def set_name
    @name = "Sonnie"
  end

  def choose
    @freq = { paper: 0.05,
              scissors: 0.05,
              lizard: 0.05,
              spock: 0.05,
              rock: 0.8 }
    self.move = Move.new(weighted_sample)
  end
end

class Number5 < Computer
  def set_name
    @name = "Number 5"
  end
end
