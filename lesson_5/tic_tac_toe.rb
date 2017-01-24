require_relative 'displayable'
require 'pry'

class Board
  include Displayable

  attr_reader :squares

  WINNING_ROWS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                  [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    reset_squares
  end

  def reset_squares
    @squares = (1..9).each_with_object({}) do |num, hash|
      hash[num] = Square.new
    end
  end

  # rubocop:disable Metrics/AbcSize
  def display
    puts ""
    puts " 1   |2    |3    ".center(50)
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  ".center(50)
    puts "     |     |     ".center(50)
    puts "-----+-----+-----".center(50)
    puts " 4   |5    |6    ".center(50)
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}  ".center(50)
    puts "     |     |     ".center(50)
    puts "-----+-----+-----".center(50)
    puts " 7   |8    |9    ".center(50)
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}  ".center(50)
    puts "     |     |     ".center(50)
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def available_squares
    squares.select { |_, square| !square.marked? }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_ROWS.each do |row|
      squares = @squares.values_at(*row)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def []=(square, marker)
    @squares[square].marker = marker
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  attr_accessor :marker

  EMPTY_SQUARE = " ".freeze
  USER_MARKER = "x".freeze
  COMPUTER_MARKER = "o".freeze

  def initialize
    @marker = EMPTY_SQUARE
  end

  def marked?
    marker != EMPTY_SQUARE
  end

  def to_s
    marker
  end
end

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
      prompt "Please enter a valid number of points:"
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

class Player
  include Displayable

  attr_reader :name

  def initialize
    @name = set_name
  end
end

class Human < Player
  def chose_move(available_squares, _squares)
    puts "Please mark a free square: #{joinor(available_squares)}"
    user_choice = ""
    loop do
      user_choice = gets.chomp.to_i
      break if available_squares.include?(user_choice)
      puts "Please select a valid square"
    end
    user_choice
  end

  def set_name
    user_name = ''
    prompt "Before starting the game, enter your name:"
    loop do
      user_name = gets.chomp
      break if user_name =~ /^[A-Za-z]+$/
      prompt "Please enter a valid name:"
    end
    user_name
  end
end

class Computer < Player
  def set_name
    %w(R2D2 Hal Chappie Sonnie Number5).sample
  end

  def smart_choice(squares, marker)
    Board::WINNING_ROWS.each do |row|
      next unless two_third_winning_rows(squares, marker)
      row.each do |square|
        return square if squares[square].marker == Square::EMPTY_SQUARE
      end
    end
    nil
  end

  def two_third_winning_rows(squares, marker)
    squares.values_at(*row).map {|i| i.marker }.count(marker) == 2
  end

  def chose_move(available_squares, squares)
    offensive_move = smart_choice(squares, Square::COMPUTER_MARKER)
    return offensive_move unless offensive_move.nil?
    defensive_move = smart_choice(squares, Square::USER_MARKER)
    return defensive_move unless defensive_move.nil?
    return 5 if squares[5].marker == Square::EMPTY_SQUARE
    available_squares.sample
  end
end

class TTTGame
  include Displayable
  include CoinToss

  attr_reader :game_rounds, :game_score

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
    @game_score = Score.new
    set_starting_player
    @game_rounds = RoundManager.new({ human: @human,
                                      computer: @computer,
                                      game_score: game_score,
                                      starting_player: @starting_player})
  end

  def play
    prompt_to_continue("Press enter to start the game")
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

  def display_welcome_message
    clear_screen
    prompt "Welcome to the Tic Tac Toe game!"
  end

  def display_goodbye_message
    prompt "Thanks for playing Tic Tac Toe. Goodbye!"
  end

  def set_starting_player
    @starting_player = coin_toss_manager
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end
end

class RoundManager
  include Displayable

  attr_reader :board, :human, :computer, :current_player,
              :game_score, :starting_player

  def initialize(params)
    @human = params[:human]
    @computer = params[:computer]
    @starting_player = params[:starting_player]
    @current_player = starting_player
    @game_score = params[:game_score]
    @board = Board.new
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
      break if someone_reached_max_points?
      prompt_to_continue("Press enter to continue the game")
    end
  end

  def display_board
    clear_screen
    board.display
    display_score
  end

  def current_player_move
    if current_player == :human
      square_selection(human, Square::USER_MARKER)
    elsif current_player == :computer
      square_selection(computer, Square::COMPUTER_MARKER)
    end
  end

  def square_selection(player, marker)
    player_choice = player.chose_move(board.available_squares, board.squares)
    board[player_choice] = marker
  end

  def alternate_current_player
    @current_player = current_player == :human ? :computer : :human
  end

  def display_result
    display_board
    case board.winning_marker
    when Square::USER_MARKER then puts "You won!"
    when Square::COMPUTER_MARKER then puts "Computer won!"
    else puts "It's a tie!"
    end
  end

  def rounds_score
    update_score
    display_score
  end

  def update_score
    game_score.update(detect_winner)
  end

  def display_score 
    puts "Game score (max points = #{game_score.max_points})".center(50)
    puts format_user_score.center(50)
    puts format_computer_score.center(50)
    puts ""
  end

  def format_user_score
    "#{human.name} (#{Square::USER_MARKER}):".ljust(15) +
    game_score.players[:human].to_s.rjust(15)
  end

  def format_computer_score
    "#{computer.name} (#{Square::COMPUTER_MARKER}):".ljust(15) +
    game_score.players[:computer].to_s.rjust(15)
  end

  def detect_winner
    case board.winning_marker
    when Square::USER_MARKER then :human
    when Square::COMPUTER_MARKER then :computer
    else :tie
    end
  end

  def someone_reached_max_points?
    game_score.reached_max_points?
  end
end

game = TTTGame.new
game.play
