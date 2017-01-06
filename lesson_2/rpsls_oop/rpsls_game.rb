load 'format_info.rb'
load 'player.rb'
load 'history.rb'
 
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

  private
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

  def select_computer_player
    case (1..5).to_a.sample
      when 1 then return R2D2.new(history)
      when 2 then return Hal.new(history)
      when 3 then return Chappie.new(history)
      when 4 then return Sonnie.new(history)
      when 5 then return Number5.new(history)
      end
  end

  def display_players_data(title, user, comp)
    puts
    puts title.center(30)
    puts "#{human.name}:".ljust(15) + " #{user}".rjust(15)
    puts "#{computer.name}:".ljust(15) + " #{comp}".rjust(15)
    puts
  end

  def set_win_comb
    @win_comb = human.move.value + computer.move.value
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
    when :human
      puts Move::WIN_COMBINATION[win_comb] + "#{human.name} won!"
    when :tie then puts "It's a tie!"
    when :computer
      puts Move::WIN_COMBINATION[win_comb.reverse] + "#{computer.name} won!"
    end
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
    display_welcome_message
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
    unless game.human.score == 0 && game.computer.score == 0
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

  def display_welcome_message
    prompt "Hello #{game.human.name}! Welcome to Rock, Paper, Scissors, Lizard " \
           "and Spock game!"
    prompt "Your opponent will be #{game.computer.name}"
    prompt_to_continue("When you are ready, press enter to start the game!")
  end

  def display_game_winner
    if game.human.score == game.max_score
      prompt "#{game.human.name} won the game!"
    elsif game.computer.score == game.max_score
      prompt "#{game.computer.name} won the game!"
    end
    game.display_scores
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def display_goodbye_message
    prompt "Goodbye #{game.human.name}! Thanks " \
         "for playing Rock, Paper, Scissors, Lizard and Spock game!"
  end

  def display_history
    game.history.display_full_game(game.human.name, game.computer.name)
  end

end

RPSGame.new.play
