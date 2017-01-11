class Move
  attr_reader :value

  AVAILABLE_MOVES = { rock: "ROCK",
                      paper: "PAPER",
                      scissors: "SCISSORS",
                      spock: "SPOCK",
                      lizard: "LIZARD" }.freeze

  WIN_COMBINATION = { rock: { lizard: "Rock crush Lizard!",
                              scissors: "Rock crushes Scissors!" },
                      lizard: { spock: "Lizard poisons Spock!",
                                paper: "Lizard eats Paper!" },
                      spock: { scissors: "Spock smashes Scissors!",
                               rock: "Spock vaporizes Rock!" },
                      scissors: { paper: "Scissors cut Paper!",
                                  lizard: "Scissors decapitates Lizard!" },
                      paper: { rock: "Paper covers Rock!",
                               spock: "Paper disproves Spock!" } }.freeze

  def initialize(player_choice)
    @value = player_choice
  end

  def >(other_player)
    false | WIN_COMBINATION[value][other_player.value]
  end

  def <(other_player)
    false | WIN_COMBINATION[other_player.value][value]
  end

  def to_s
    AVAILABLE_MOVES[@value]
  end
end
