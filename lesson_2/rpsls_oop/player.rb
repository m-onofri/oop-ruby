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
      when "r", "rock" then return "ROCK"
      when "p", "paper" then return "PAPER"
      when "s", "scissors" then return "SCISSORS"
      when "l", "lizard" then return "LIZARD"
      when "k", "spock" then return "SPOCK"
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
    @freq = { "PAPER" => 0.2,
              "SCISSORS" => 0.2,
              "LIZARD" => 0.2,
              "SPOCK" => 0.2,
              "ROCK" => 0.2 }
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.sample)
  end

  private

  def weighted_sample
    freq.max_by { |_, weight| rand**(1.0 / weight) }.first
  end

  def remove_loss_move(loss_move)
    moves_array = Move::AVAILABLE_MOVES.reject do |move|
      move == loss_move
    end
    Move.new(moves_array.sample)
  end
end

class R2D2 < Computer
  def set_name
    @name = "R2D2"
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES[0..2].sample)
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
    self.move = if comp_moves >= 5 && loss_move[1] > 0.2
                  remove_loss_move(loss_move[0])
                else
                  Move.new(Move::AVAILABLE_MOVES.sample)
                end
  end
end

class Chappie < Computer
  def set_name
    @name = "Chappie"
  end

  def choose
    comp_moves = history.player_moves_number
    if (comp_moves % 5).zero? && comp_moves.odd? && comp_moves > 1
      efficiency = history.moves_efficiency
      most_efficient_move = efficiency.first[0]
      @freq.each do |move, _|
        @freq[move] = if move == most_efficient_move
                        0.60
                      else
                        0.10
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
    @freq = { "PAPER" => 0.05,
              "SCISSORS" => 0.05,
              "LIZARD" => 0.05,
              "SPOCK" => 0.05,
              "ROCK" => 0.8 }
    self.move = Move.new(weighted_sample)
  end
end

class Number5 < Computer
  def set_name
    @name = "Number 5"
  end
end
