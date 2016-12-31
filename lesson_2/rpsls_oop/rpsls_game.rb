load 'format_info.rb'
load 'player.rb'

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
