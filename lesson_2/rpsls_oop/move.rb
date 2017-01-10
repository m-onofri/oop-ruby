class Move
  attr_reader :value

  AVAILABLE_MOVES = %w(ROCK PAPER SCISSORS SPOCK LIZARD).freeze
  WIN_COMBINATION = { "ROCK" => { "LIZARD" => "Rock crush Lizard!",
                                  "SCISSORS" => "Rock crushes Scissors!" },
                      "LIZARD" => { "SPOCK" => "Lizard poisons Spock!",
                                    "PAPER" => "Lizard eats Paper!" },
                      "SPOCK" => { "SCISSORS" => "Spock smashes Scissors!",
                                   "ROCK" => "Spock vaporizes Rock!" },
                      "SCISSORS" => { "PAPER" => "Scissors cut Paper!",
                                      "LIZARD" => "Scissors decapitates" \
                                                  "Lizard!" },
                      "PAPER" => { "ROCK" => "Paper covers Rock!",
                                   "SPOCK" => "Paper disproves" \
                                              "Spock!" } }.freeze

  def initialize(player_choice)
    @value = player_choice
  end

  def >(other_player)
    nil | WIN_COMBINATION[value][other_player.value]
  end

  def <(other_player)
    nil | WIN_COMBINATION[other_player.value][value]
  end

  def to_s
    @value
  end
end
