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
  attr_accessor :history

  def initialize(history)
    @history = history
    set_name
  end

  def set_name
    @name = "Computer"
  end

  def choose
    self.move = Move.new(Move::AVAILABLE_MOVES.keys.sample)
  end

  protected

  def weighted_sample
    @freq.max_by { |_, weight| rand ** (1.0 / weight) }.first
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

  # def choose(history)
  #   if history.
  # end
end

class Chappie < Computer
  def set_name
    @name = "Chappie"
  end
end

class Sonnie < Computer
  def initialize(_history)
    set_name
    @freq = {"p"=>0.05, "s"=>0.05, "l"=>0.05, "k"=>0.05, "r"=>0.8}
  end

  def set_name
    @name = "Sonnie"
  end

  def choose
    self.move = Move.new(self.weighted_sample)
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





