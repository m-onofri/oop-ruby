class Move
  attr_accessor :current_move

  AVAILABLE_MOVES = ["rock", "paper", "scissors"].freeze
  WIN_COMBINATION = [["rock", "scissors"], ["scissors", "paper"],
                        ["paper", "rock"]].freeze
  LOSER_COMBINATION = [["scissors", "rock"], ["paper", "scissors"],
                       ["rock", "paper"]].freeze

  def initialize(player_choice)
    @current_move = player_choice
  end

  def >(other_player)
    WIN_COMBINATION.include?([current_move, other_player.current_move])
  end

  def <(other_player)
    LOSER_COMBINATION.include?([current_move, other_player.current_move])
  end

  def to_s
    @current_move
  end
end