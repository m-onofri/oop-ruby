load 'move.rb'
  
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
    prompt "Please enter your name:"
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
      prompt "Please choose one move: (r)ock, (p)aper, (s)cissors, " \
             "(l)izard or spoc(k)"
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
end

class Computer < Player
  def set_name
    @name = ["R2D2", "Hal", "Chappie", "Sonnie", "Number 5"].sample
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys.sample)
  end
end

class R2D2 < Computer

end

class Hal < Computer

end

class Chappie < Computer

end

class Sonnie < Computer

end

class Number5 < Computer

end





