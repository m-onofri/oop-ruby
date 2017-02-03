# class TTTGame
# class RoundManager

class TTTGame
  include Displayable

  attr_reader :game_rounds, :game_score, :setup

  def initialize
    game_presentation
    @setup = SetupGame.new
  end

  def play
    loop do
      confirm_setup
      initialize_game_rounds
      game_rounds.play
      display_final_result
      break unless play_again?
    end
    display_goodbye_message("Tic Tac Toe")
  end

  private

  def game_presentation
    clear_screen
    game_rules
    prompt_to_continue("Press enter to set up the game.")
  end

  def game_rules
    puts <<-EOF
     Welcome to the Tic Tac Toe game!
     Here you can play with the traditional version of Tic Tac Toe game,
     or with an alternative version of this game on a 5x5 grid.

     The traditional version is a 2-player board game played on a 3x3 grid.
     Players take turns marking a square. The first player to mark 3 squares
     in a row wins.

     The alternative version is a 2-player board game played on a 5x5 grid.
     Players take turns marking a square. In this case, the first player to
     mark 4 squares in a row wins.
    EOF
  end

  def confirm_setup
    loop do
      clear_screen
      prompt "These are your set_up data:"
      display_setup_resume
      prompt "Do you confirm them?(y/n)"
      answer = return_yes_no_answer
      case answer
      when "y" then break
      when "n" then change_setup_data
      end
    end
  end

  def display_setup_resume
    puts <<-EIF

     1 - Name: #{setup.human_name}
     2 – Board: #{setup.board_type}
     3 - Max score: #{setup.game_score.max_points}
     4 - Symbol: #{setup.user_marker}
     5 - Starting player: #{setup.starting_player}

    EIF
  end

  def change_setup_data
    clear_screen
    puts "What do you want to modify?"
    display_setup_resume
    puts "Enter a number from 1 to 5 to select an option."
    option = check_valid_option
    setup.select_option(option)
  end

  def check_valid_option
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (1..5).to_a.include?(answer)
      puts "Please choose a valid option from 1 to 5"
    end
    answer
  end

  def initialize_game_rounds
    @game_rounds = RoundManager.new(setup.setup_data)
    prompt_to_continue("Press enter to start the game")
  end

  def display_final_result
    clear_screen
    final_result
    puts
    game_rounds.display_score
  end

  def final_result
    puts ""
    case setup.game_score.player_at_max_point
    when :human
      puts "YOU WON!".center(50)
    when :computer
      puts "#{setup.comp_name.upcase} WON!".center(50)
    end
  end
end

class RoundManager
  include Displayable

  attr_reader :board, :human, :computer, :current_player,
              :game_score, :starting_player

  def initialize(params)
    @board = select_board(params[:game_variation], params[:markers])
    @human = Human.new(params[:human], board)
    @computer = computer_player(params[:game_variation], params[:computer])
    @starting_player = params[:starting_player]
    @current_player = starting_player
    @game_score = params[:game_score]
  end

  def play
    game_score.set_score
    loop do
      board.reset_squares
      loop do
        display_board
        current_player_move
        alternate_current_player
        break if board.full? || board.someone_won?
        sleep_game(2)
      end
      end_round
      prompt_to_continue("Press enter to continue the game")
      break if game_score.reached_max_points?
    end
  end

  def display_score
    puts "Game score (max points = #{game_score.max_points})".center(50)
    puts format_user_score.center(50)
    puts format_computer_score.center(50)
    puts ""
  end

  private

  def select_board(game_variation, markers)
    case game_variation
    when "3x3" then Board3.new(markers)
    when "5x5" then Board5.new(markers)
    end
  end

  def computer_player(game_variation, name)
    case game_variation
    when "3x3" then Computer3.new(name, board)
    when "5x5" then Computer5.new(name, board)
    end
  end

  def display_board
    clear_screen
    board.display
    display_score
  end

  def current_player_move
    if current_player == :human
      player_move(human, board.user_marker)
    elsif current_player == :computer
      player_move(computer, board.comp_marker)
    end
  end

  def player_move(player, player_marker)
    player_choice = player.chose_move
    board.squares[player_choice].marker = player_marker
    display_board
  end

  def alternate_current_player
    @current_player = current_player == :human ? :computer : :human
  end

  def end_round
    update_score
    display_result
    alternate_starting_player
  end

  def update_score
    game_score.update(detect_winner)
  end

  def detect_winner
    case board.winner_marker
    when board.user_marker then :human
    when board.comp_marker then :computer
    else :tie
    end
  end

  def display_result
    display_board
    case board.winner_marker
    when board.user_marker then puts "YOU WON!".center(50)
    when board.comp_marker then puts "#{@computer.name.upcase} WON!".center(50)
    else puts "It's a tie!"
    end
  end

  def alternate_starting_player
    @starting_player = starting_player == :human ? :computer : :human
    @current_player = starting_player
  end

  def format_user_score
    "#{human.name} (#{board.user_marker}):".ljust(15) +
      game_score.players[:human].to_s.rjust(15)
  end

  def format_computer_score
    "#{computer.name} (#{board.comp_marker}):".ljust(15) +
      game_score.players[:computer].to_s.rjust(15)
  end
end
