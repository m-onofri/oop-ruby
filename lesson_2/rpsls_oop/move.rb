class Move
  attr_accessor :current_move

  AVAILABLE_MOVES = { "r" => "ROCK",
                      "p" => "PAPER",
                      "s" => "SCISSORS",
                      "k" => "SPOCK",
                      "l" => "LIZARD" }.freeze
  WIN_COMBINATION = { "rl" => "Rock crush Lizard!",
                      "lk" => "Lizard poisons Spock!",
                      "ks" => "Spock smashes Scissors!",
                      "sp" => "Scissors cut Paper!",
                      "pr" => "Paper covers Rock!",
                      "rs" => "Rock crushes Scissors!",
                      "pk" => "Paper disproves Spock!",
                      "sl" => "Scissors decapitates Lizard!",
                      "kr" => "Spock vaporizes Rock!",
                      "lp" => "Lizard eats Paper!" }.freeze

  def initialize(player_choice)
    @current_move = player_choice
  end

  def >(other_player)
    combination = current_move + other_player.current_move
    WIN_COMBINATION.keys.include?(combination)
  end

  def <(other_player)
    combination = other_player.current_move + current_move
    WIN_COMBINATION.keys.include?(combination)
  end

  def to_s
    AVAILABLE_MOVES[@current_move]
  end
end
