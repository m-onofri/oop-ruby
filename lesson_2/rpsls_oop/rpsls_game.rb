class RoundsManager
  include FormatInfo
  attr_accessor :human, :computer, :max_score, :cur_winner,
                :win_comb, :history

  def initialize
    @history = History.new
    @human = Human.new
    @computer = select_computer_player
    set_max_score
  end

  def start
    loop do
      human.choose
      computer.choose
      define_round_winner
      set_round_score
      display_round_result
      archive_info
      break if human.score == max_score || computer.score == max_score
    end
  end

  def display_scores
    display_players_data("Score (max points = #{max_score})",
                         human.score, computer.score)
  end

  def define_game_winner
    if human.score == max_score
      human.name
    elsif computer.score == max_score
      computer.name
    end
  end

  private

  def set_max_score
    prompt "Please set the score that players have to reach to win the game:"
    prompt "(by default this value is set to 10)"
    answer = nil
    loop do
      user_input = gets.chomp
      answer = user_input == "" ? 10 : user_input.to_i
      break if answer > 1
      prompt "Invalid input; please enter a positive number greater than 1."
    end
    @max_score = answer
    clear_screen
  end

  def select_computer_player
    case (1..5).to_a.sample
    when 1 then R2D2.new(history)
    when 2 then Hal.new(history)
    when 3 then Chappie.new(history)
    when 4 then Sonnie.new(history)
    when 5 then Number5.new(history)
    end
  end

  def display_players_data(title, user, comp)
    puts
    puts title.center(40)
    separator(40)
    puts "#{human.name}:".ljust(20) + " #{user}".rjust(20)
    puts "#{computer.name}:".ljust(20) + " #{comp}".rjust(20)
    puts
  end

  def set_win_comb
    @win_comb = [human.move.value, computer.move.value]
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

  def display_round_winner
    set_win_comb
    case cur_winner
    when :human then human_win_sentence
    when :tie then puts "IT'S A TIE!".center(40)
    when :computer then computer_win_sentence
    end
  end

  def human_win_sentence
    sentence = Move::WIN_COMBINATION[win_comb[0]][win_comb[1]] +
               " #{human.name} won!"
    puts sentence.upcase.center(40)
  end

  def computer_win_sentence
    sentence = Move::WIN_COMBINATION[win_comb[1]][win_comb[0]] +
               " #{computer.name} won!"
    puts sentence.upcase.center(40)
  end

  def archive_info
    history.push_values(human.move.to_s, computer.move.to_s, cur_winner)
  end
end

class RPSGame
  include FormatInfo
  attr_accessor :game

  def initialize
    game_presentation
    @game = RoundsManager.new
  end

  def play
    display_opponent
    loop do
      reset_game
      @game.start
      display_game_winner
      break unless play_again?
    end
    display_history
    display_goodbye_message
  end

  private

  def reset_game
    clear_screen
    reset_scores
    reset_history
  end

  def reset_scores
    if game.human.score && game.computer.score
      game.human.score = 0
      game.computer.score = 0
    end
  end

  def reset_history
    unless game.history.list[:winner].empty?
      game.history.archive_matches
      game.history.reset_list
    end
  end

  def game_presentation
    clear_screen
    game_rules
    prompt_to_continue("Press enter to set up the game.")
  end

  def game_rules
    puts <<-EOF
     Welcome to Rock, Paper, Scissors, Lizard and Spock game!"
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
     of points one player have to reach to win the game.
    EOF
  end

  def display_opponent
    prompt "Hello #{game.human.name}!" \
           "Your opponent will be #{game.computer.name}."
    prompt_to_continue("When you are ready, press enter to start the game!")
  end

  def display_game_winner
    winner = game.define_game_winner
    prompt "#{winner} won the game!"
    game.display_scores
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def display_goodbye_message
    puts ""
    prompt "Goodbye #{game.human.name}! Thanks " \
         "for playing Rock, Paper, Scissors, Lizard and Spock game!"
  end

  def display_history
    game.history.display_full_game(game.human.name, game.computer.name)
  end
end
