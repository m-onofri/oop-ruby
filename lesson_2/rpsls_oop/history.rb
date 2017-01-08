class History
  include FormatInfo

  attr_accessor :list, :matches
 
  def initialize
    @matches = [{ human: [],
                  computer: [],
                  winner: []}]
    @list = @matches.last
  end

  def push_values(human_move, computer_move, winner)
    list[:human] << human_move
    list[:computer] << computer_move
    list[:winner] << winner
  end

  def archive_matches
    matches << { human: [],
                 computer: [],
                 winner: []}
  end

  def reset_list
    @list = @matches.last
  end

  def display_full_game(human_name, computer_name)
    puts "MOVES LIST".center(60)
    puts "ROUND".ljust(15) +"#{human_name}".ljust(15) + 
         "#{computer_name}".ljust(15) + "ROUND WINNER".ljust(15)
    separator(60)
    (0...matches.size).each do |n_match|
      puts "MATCH #{n_match + 1}".center(60)
      display_rounds(human_name, computer_name, matches[n_match])
      separator(60, "-")
    end
  end

  # status can be "win" or "loss"
  def computer_moves_frequencies(status)
    computer_moves = select_players_moves[:computer]
    total_moves = self.player_moves_number
    moves_count = count_moves(computer_moves, status)
    calculate_frequencies(moves_count, total_moves)
  end

  def player_moves_number
    select_players_moves[:computer].size
  end

  def moves_efficiency
    computer_moves = select_players_moves[:computer]
    calculate_efficiency(computer_moves)
  end

  private

  def count_moves(player_moves, status)
    result = { "ROCK"=>0, "PAPER"=>0, "SCISSORS"=>0, "LIZARD"=>0, "SPOCK"=>0 }
    player_moves.reduce(result) do |hash, move|
      hash[move[0]] += 1 if move[1] == status
      hash
    end
  end

  def calculate_frequencies(moves_count, total)
    moves_count.each do |key, value|
      unless total == 0
        moves_count[key] = (value.to_f / total).round(2)
      end
    end
  end

  def calculate_efficiency(player_moves)
    result = { "ROCK"=>0, "PAPER"=>0, "SCISSORS"=>0, "LIZARD"=>0, "SPOCK"=>0 }
    player_moves.each do |move, status|
      case status
      when "win" then result[move] += 1
      when "loss" then result[move] -= 1
      end
    end
    result.max_by(result.size) {|_, value| value }
  end

  def change_winners_array(human_name, computer_name, current_list)
    winners = current_list[:winner].map do |winner|
                case winner
                when :human then human_name
                when :computer then computer_name
                when :tie then "tie"
                end 
              end
  end

  def display_rounds(human_name, computer_name, current_list)
    winners = change_winners_array(human_name, computer_name, current_list)
    (0...current_list[:human].size).each do |index|
      puts "  #{index + 1}".ljust(15) +
           "#{current_list[:human][index]}".ljust(15) +
           "#{current_list[:computer][index]}".ljust(15) + 
           "#{winners[index]}".ljust(15)        
    end
  end

  def select_players_moves
    result = { computer: [], human: [] }
    matches.each do |match|
      match[:winner].each_with_index do |round_winner, index|
        if round_winner == :human
          result[:computer] << [match[:computer][index], "loss"]
          result[:human] << [match[:human][index], "win"]
        elsif round_winner == :computer
          result[:computer] << [match[:computer][index], "win"]
          result[:human] << [match[:human][index], "loss"]
        end
      end
    end
    result
  end

end