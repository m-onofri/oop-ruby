class Move
  attr_accessor :value
 
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
    @value = player_choice
  end

  def >(other_player)
    combination = value + other_player.value
    WIN_COMBINATION.keys.include?(combination)
  end

  def <(other_player)
    combination = other_player.value + value
    WIN_COMBINATION.keys.include?(combination)
  end

  def to_s
    AVAILABLE_MOVES[@value]
  end
end
