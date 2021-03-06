module FormatInfo
  def prompt(string)
    puts "==> #{string}"
  end

  def check_yes_no_answer
    loop do
      answer = gets.chomp.downcase
      case answer
      when "y", "yes" then return true
      when "n", "no" then return false
      else prompt "Invalid answer; please enter yes or no"
      end
    end
  end

  def prompt_to_continue(request)
    prompt request
    gets.chomp
    clear_screen
  end

  def clear_screen
  system('clear') || system('cls')
end
end

class Player
  include FormatInfo
  attr_accessor :move, :score, :name

  def initialize
    @score = 0
    set_name
  end
end

class Move
  attr_accessor :current_move

  AVAILABLE_MOVES = ["rock", "paper", "scissors"].freeze
  WIN_COMBINATION = [["rock", "scissors"], ["scissors", "paper"],
                        ["paper", "rock"]].freeze
  LOSER_COMBINATION = [["scissors", "rock"], ["paper", "scissors"],
                       ["rock", "paper"]].freeze

  def initialize(player_choice)
    @current_move = player_choice
  end

  def >(other_player)
    WIN_COMBINATION.include?([current_move, other_player.current_move])
  end

  def <(other_player)
    LOSER_COMBINATION.include?([current_move, other_player.current_move])
  end

  def to_s
    @current_move
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

class RoundsManager
  include FormatInfo
  attr_accessor :human, :computer, :max_score, :cur_winner

  WIN_COMBINATION = [["rock", "scissors"], ["scissors", "paper"],
                        ["paper", "rock"]].freeze

  def initialize(max_score, human, computer)
    @max_score = max_score
    @human = human
    @computer = computer
  end

  def define_round_winner
    @cur_winner = if human.move > computer.move
                    :human
                  elsif human.move < computer.move
                    :computer
                  else
                    :tie
                  end
  end

  def set_round_score
    case cur_winner
    when :human then human.score += 1
    when :computer then computer.score += 1
    end
  end

  def display_round_result
    display_moves
    display_round_winner
    display_scores
    prompt_to_continue("Press enter to play the next round!")
  end

  def display_moves
    prompt "#{human.name} chose #{human.move}"
    prompt "#{computer.name} chose #{computer.move}"
  end

  def display_round_winner
    case cur_winner
    when :human then prompt "#{human.name} won!"
    when :tie then prompt "It's a tie!"
    when :computer then prompt "#{computer.name} won!"
    end
  end

  def display_scores
    prompt "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end

  def start
    loop do
      human.choose
      computer.choose
      define_round_winner
      set_round_score
      display_round_result
      break if human.score == max_score || computer.score == max_score
    end
  end
end

class RPSGame
  include FormatInfo
  attr_accessor :human, :computer, :max_score

  def initialize
    @human = Human.new
    @computer = Computer.new
    set_max_score
    @rounds = RoundsManager.new(@max_score, @human, @computer)
  end

  def set_max_score
    prompt "Please set the score players have to reach to win the game:"
    prompt "(enter a positive number greater than 1)"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if answer > 1
      prompt "Invalid input; please enter a positive number greater than 1."
    end
    @max_score = answer
    clear_screen
  end

  def display_welcome_message
    prompt "Hello #{human.name}! Welcome to Rock, Paper and Scissors game!"
    prompt_to_continue("Press enter to start the game!")
  end

  def display_game_winner
    if human.score == max_score
      prompt "#{human.name} won the game!"
    elsif computer.score == max_score
      prompt "#{computer.name} won the game!"
    end
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def display_goodbye_message
    prompt "Goodbye #{human.name}! Thanks " \
         "for playing Rock, Paper and Scissors game!"
  end

  def play
    display_welcome_message
    loop do
      @rounds.start
      display_game_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
