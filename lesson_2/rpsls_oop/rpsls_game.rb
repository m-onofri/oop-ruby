load 'format_info.rb'
load 'player.rb'

class RoundsManager
  include FormatInfo
  attr_accessor :human, :computer, :max_score, :cur_winner,
                :win_comb

  def initialize(max_score, human, computer)
    @max_score = max_score
    @human = human
    @computer = computer
  end

  def display_players_data(title, user, comp)
    puts
    puts title.center(30)
    puts "#{human.name}:".ljust(15) + " #{user}".rjust(15)
    puts "#{computer.name}:".ljust(15) + " #{comp}".rjust(15)
    puts
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
    prompt_to_continue("Press enter to continue the game!")
  end

  def display_moves
    display_players_data("Moves", human.move, computer.move)
  end

  def set_win_comb
    @win_comb = human.move.current_move + computer.move.current_move
  end

  def display_round_winner
    set_win_comb
    case cur_winner
    when :human
      puts Move::WIN_COMBINATION[win_comb] + "#{human.name} won!"
    when :tie then puts "It's a tie!"
    when :computer
      puts Move::WIN_COMBINATION[win_comb.reverse] + "#{computer.name} won!"
    end
  end

  def display_scores
    display_players_data("Score (max points = #{max_score})",
                         human.score, computer.score)
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
  attr_accessor :human, :computer, :max_score, :rounds

  def initialize
    game_presentation
    @human = Human.new
    @computer = Computer.new
    set_max_score
    @rounds = RoundsManager.new(@max_score, @human, @computer)
  end

  def game_presentation
    clear_screen
    puts <<-EOF
     This is a variation of the classic game "Rock-Paper-Scissors",
     with the addition of two other choices: "Spock" and "Lizard".
     Here the rules of the game:

     - Rock crush Lizard
     - Lizard poisons Spock
     - Spock smashes Scissors
     - Scissors cut Paper
     - Paper covers Rock
     - Rock crushes Scissors
     - Paper disproves Spock
     - Scissors decapitates Lizard
     - Spock vaporizes Rock
     - Lizard eats Paper

     Before starting to play, you must enter your name and the number
     of points player have to reach to win the game.
    EOF
    prompt_to_continue("Press enter to set up the game.")
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
    prompt "Hello #{human.name}! Welcome to Rock, Paper, Scissors, Lizard " \
           "and Spock game!"
    prompt_to_continue("When you are ready, press enter to start the game!")
  end

  def display_game_winner
    if human.score == max_score
      prompt "#{human.name} won the game!"
    elsif computer.score == max_score
      prompt "#{computer.name} won the game!"
    end
    rounds.display_scores
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def display_goodbye_message
    prompt "Goodbye #{human.name}! Thanks " \
         "for playing Rock, Paper, Scissors, Lizard and Spock game!"
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
