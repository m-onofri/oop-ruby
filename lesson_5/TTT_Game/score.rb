# class Score
# class CoinToss

class Score
  include Displayable

  attr_reader :max_points
  attr_accessor :players

  def initialize
    @max_points = set_max_points
  end

  def set_max_points
    max_points = nil
    prompt "Please enter how many points players have to reach to win the game:"
    loop do
      max_points = gets.chomp
      break if integer?(max_points) && max_points.to_i.positive?
      prompt "Please enter an integer number greater than zero:"
    end
    max_points.to_i
  end

  def set_score
    @players = { human: 0,
                 computer: 0 }
  end

  def update(winner)
    unless winner == :tie
      players[winner] += 1
    end
  end

  def integer?(string)
    /^\d+$/.match(string)
  end

  def reached_max_points?
    players.values.include?(max_points)
  end

  def player_at_max_point
    if reached_max_points?
      players.key(max_points)
    end
  end
end

class CoinToss
  include Displayable

  attr_reader :coin_toss, :user_choice, :winner

  def initialize
    @coin_toss = coin_toss_result
    @user_choice = valid_choice
    @winner = determine_winner
  end

  def display_winner
    prompt "You choose #{user_choice.upcase}."
    puts
    if winner == :human
      prompt "The coin toss result is #{coin_toss.upcase}."
      puts
      prompt "YOU will start the game."
    elsif winner == :computer
      prompt "The coin toss result is #{coin_toss.upcase}."
      puts
      prompt "COMPUTER will start the game."
    end
  end

  private

  def coin_toss_result
    case ["h", "t"].sample
    when "h" then "heads"
    when "t" then "tails"
    end
  end

  def valid_choice
    puts <<-EOF
     To choose who will start the game, we toss a coin:

     - (h)eads or

     - (t)ails?
    EOF
    loop do
      case gets.chomp.downcase
      when "heads", "h" then return "heads"
      when "tails", "t" then return "tails"
      else prompt "Please enter (h)eads or (t)ails."
      end
    end
  end

  def determine_winner
    user_choice == coin_toss ? :human : :computer
  end
end
