require_relative 'modules'

class Score
  include Displayable

  attr_reader :max_points
  attr_accessor :points

  def initialize
    @max_points = set_max_points
    set_score
  end

  def set_max_points
    clear_screen
    max_points = nil
    prompt "Please enter how many points players have to reach to win the game:"
    loop do
      max_points = gets.chomp
      break if integer?(max_points) && max_points.to_i.positive?
      prompt "Please enter an integer number greater than zero:"
    end
    max_points.to_i
  end

  def set_score
    @points = { player: 0,
                dealer: 0 }
  end

  def update(winner)
    unless winner == :tie
      points[winner] += 1
    end
  end

  def integer?(string)
    /^\d+$/.match(string)
  end

  def reached_max_points?
    points.values.include?(max_points)
  end

  def player_at_max_point
    if reached_max_points?
      points.key(max_points)
    end
  end
end
