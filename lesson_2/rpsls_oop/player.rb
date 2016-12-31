load 'move.rb'

class Player
  include FormatInfo
  attr_accessor :move, :score, :name

  def initialize
    @score = 0
    set_name
  end
end

class Computer < Player
  def set_name
    @name = ["R2D2", "Hal", "Chappie", "Sonnie", "Number 5"].sample
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.sample)
  end
end

class Human < Player
  def set_name
    prompt "Please enter your name"
    user_name = gets.chomp
    @name = user_name == "" ? "User" : user_name
    clear_screen
  end

  def choose
    self.move = Move.new(ask_user_choice)
    clear_screen
  end

  def ask_user_choice
    loop do
      prompt "Please choose one move: (r)ock, (p)aper or (s)cissors"
      case gets.chomp.downcase
      when "r", "rock" then return "rock"
      when "p", "paper" then return "paper"
      when "s", "scissors" then return "scissors"
      else prompt "Sorry, invalid choice."
      end
    end
  end
end