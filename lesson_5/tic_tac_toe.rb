require_relative 'modules'
require_relative 'board'
require_relative 'player'
require_relative 'score'
require 'pry'

class TTTGame
  include Displayable
  include CoinToss

  attr_reader :game_rounds, :game_score

  def initialize
    game_presentation
    setup_game
    @game_rounds = RoundManager.new(human: @human,
                                    computer: @computer,
                                    game_score: game_score,
                                    game_variation: @game_variation,
                                    starting_player: @starting_player,
                                    markers: { human: @user_marker,
                                               computer: @computer_marker })
  end

  def setup_game
    setup_title(1)
    @human = Human.new
    @computer = Computer.new
    prompt_to_continue("Press enter to proceed in the setup of the game.")
    setup_title(2)
    @game_score = Score.new
    prompt_to_continue("Press enter to proceed in the setup of the game.")
    setup_title(3)
    @starting_player = coin_toss_manager
    prompt_to_continue("Press enter to proceed in the setup of the game.")
    setup_title(4)
    set_players_markers
    prompt_to_continue("Press enter to proceed in the setup of the game.")
    setup_title(5)
    @game_variation = set_game_variation
    prompt_to_continue("Press enter to start the game.")
  end

  def set_game_variation
    puts <<-EOF
     Available game variations:

     - enter 1 to play with a 3x3 board

     - enter 2 to play with a 5x5 board
    EOF
    loop do
      case gets.chomp
      when "1" then return "3x3"
      when "2" then return "5x5"
      else prompt "Enter 1 or 2"
      end
    end
  end

  def set_players_markers
    set_user_marker
    set_computer_marker
  end

  def set_user_marker
    prompt "What symbol do you want? (only single character allowed):"
    symbol = nil
    loop do
      symbol = gets.chomp.strip
      break if symbol.size == 1
      prompt "Please enter a valid symbol"
    end
    @user_marker = symbol
  end

  def set_computer_marker
    symbol = nil
    loop do
      symbol = %w(* + o x).sample
      break unless symbol == @user_marker
    end
    @computer_marker = symbol
  end

  def play
    loop do
      game_score.set_score
      game_rounds.play
      display_final_result
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def display_final_result
    clear_screen
    final_result
    puts
    game_rounds.display_score
  end

  def final_result
    case game_score.player_at_max_point
    when :human
      puts "YOU WON!".center(50)
    when :computer
      puts "#{@computer.name.upcase} WON!".center(50)
    end
  end

  def game_presentation
    clear_screen
    game_rules
    prompt_to_continue("Press enter to set up the game.")
  end

  def game_rules
    puts <<-EOF
     Welcome to the Tic Tac Toe game!"
     Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players 
     take turns marking a square. The first player to mark 3 squares in
     a row wins.

     Before starting to play, you must enter the following data:
     - your name
     - the number of points one player have to reach to win the game
     - who will start the game
     - what symbol you want to use
    EOF
  end

  def display_goodbye_message
    prompt "Thanks for playing Tic Tac Toe. Goodbye!"
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end
end

class RoundManager
  include Displayable

  attr_reader :board, :human, :computer, :current_player,
              :game_score, :starting_player, :markers

  def initialize(params)
    @human = params[:human]
    @computer = params[:computer]
    @starting_player = params[:starting_player]
    @markers = params[:markers]
    @current_player = starting_player
    @game_score = params[:game_score]
    @board = set_board(params[:game_variation])
  end

  def play
    loop do
      board.reset_squares
      loop do
        display_board
        current_player_move
        alternate_current_player
        break if board.full? || board.someone_won?
      end
      update_score
      display_result
      alternate_starting_player
      break if someone_reached_max_points?
      prompt_to_continue("Press enter to continue the game")
    end
  end

  def set_board(game_variation)
    case game_variation
    when "3x3" then Board3.new(markers)
    when "5x5" then Board5.new(markers)
    end
  end

  def display_board
    clear_screen
    board.display
    display_score
  end

  def display_score
    puts "Game score (max points = #{game_score.max_points})".center(50)
    puts format_user_score.center(50)
    puts format_computer_score.center(50)
    puts ""
  end

  def format_user_score
    "#{human.name} (#{board.user_marker}):".ljust(15) +
      game_score.players[:human].to_s.rjust(15)
  end

  def format_computer_score
    "#{computer.name} (#{board.computer_marker}):".ljust(15) +
      game_score.players[:computer].to_s.rjust(15)
  end

  def current_player_move
    if current_player == :human
      board.human_square_selection(board.user_marker)
    elsif current_player == :computer
      board.computer_square_selection(board.computer_marker)
    end
  end

  def alternate_current_player
    @current_player = current_player == :human ? :computer : :human
  end

  def update_score
    game_score.update(detect_winner)
  end

  def detect_winner
    case board.winning_marker
    when board.user_marker then :human
    when board.computer_marker then :computer
    else :tie
    end
  end

  def display_result
    display_board
    case board.winning_marker
    when board.user_marker then puts "You won!"
    when board.computer_marker then puts "Computer won!"
    else puts "It's a tie!"
    end
  end

  def alternate_starting_player
    @starting_player = starting_player == :human ? :computer : :human
    @current_player = starting_player
  end

  def someone_reached_max_points?
    game_score.reached_max_points?
  end
end

game = TTTGame.new
game.play
