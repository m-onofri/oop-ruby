class SetupGame
  include Displayable
  include CoinToss

  attr_reader :human_name, :board_type, :game_score, :user_marker,
              :starting_player, :user_marker, :comp_marker, :comp_name

  def initialize
    setup_title(1, 5)
    players_names
    setup_title(2, 5)
    game_variation
    setup_title(3, 5)
    max_score
    setup_title(4, 5)
    players_markers
    setup_title(5, 5)
    game_starting_player
  end

  def players_names
    @human_name = set_name
    @comp_name = %w(R2D2 Hal Chappie Sonnie Number5).sample
    prompt_to_continue("Press enter to proceed in the setup of the game.")
  end

  def set_name
    user_name = ''
    prompt "Please, enter your name:"
    loop do
      user_name = gets.chomp
      break if user_name =~ /^[A-Za-z0-9]+$/
      prompt "Please enter a valid name:"
    end
    user_name
  end

  def game_variation
    @board_type = define_game_variation
    prompt_to_continue("Press enter to proceed in the setup of the game.")
  end

  def define_game_variation
    puts <<-EOF
     Available game variations:

     - enter 1 to play with a 3x3 board (mark 3 squares in a row to win)

     - enter 2 to play with a 5x5 board (mark 4 squares in a row to win)
    EOF
    loop do
      case gets.chomp
      when "1" then return "3x3"
      when "2" then return "5x5"
      else prompt "Enter 1 or 2"
      end
    end
  end

  def max_score
    @game_score = Score.new
    prompt_to_continue("Press enter to proceed in the setup of the game.")
  end

  def players_markers
    set_players_markers
    prompt_to_continue("Press enter to proceed in the setup of the game.")
  end

  def set_players_markers
    set_user_marker
    set_comp_marker
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

  def set_comp_marker
    symbol = nil
    loop do
      symbol = %w(* + o x).sample
      break unless symbol == @user_marker
    end
    @comp_marker = symbol
  end

  def game_starting_player
    @starting_player = coin_toss_manager
    prompt_to_continue("Press enter to proceed in the setup of the game.")
  end

  def setup_data
    { human: human_name,
      computer: comp_name,
      game_score: game_score,
      game_variation: board_type,
      starting_player: starting_player,
      markers: { human: user_marker,
                 computer: comp_marker } }
  end
end

