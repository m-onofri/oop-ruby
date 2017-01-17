class History
  include Displayable

  attr_accessor :list, :matches

  def initialize
    @matches = [{ human: [],
                  computer: [],
                  winner: [] }]
    reset_list
  end

  def push_values(human_move, computer_move, winner)
    list[:human] << human_move
    list[:computer] << computer_move
    list[:winner] << winner
  end

  def archive_matches
    matches << { human: [],
                 computer: [],
                 winner: [] }
  end

  def reset_list
    @list = @matches.last
  end

  def display_full_game(human_name, computer_name)
    puts "MOVES LIST".center(55)
    display_column_titles(human_name, computer_name)
    separator(55)
    display_matches(human_name, computer_name)
  end

  def player_moves_number
    select_players_moves[:computer].size
  end

  # status can be "win" or "loss"
  def computer_moves_frequencies(status)
    computer_moves = select_players_moves[:computer]
    total_moves = player_moves_number
    moves_count = count_moves(computer_moves, status)
    calculate_frequencies(moves_count, total_moves)
  end

  def moves_efficiency
    computer_moves = select_players_moves[:computer]
    calculate_efficiency(computer_moves)
  end

  private

  def display_column_titles(human_name, computer_name)
    puts "ROUND".ljust(10) + human_name.ljust(15) +
         computer_name.ljust(15) + "ROUND WINNER".ljust(15)
  end

  def display_matches(human_name, computer_name)
    (0...matches.size).each do |n_match|
      puts "MATCH #{n_match + 1}".center(55)
      display_rounds(human_name, computer_name, matches[n_match])
      separator(55, "-")
    end
  end

  def display_rounds(human_name, computer_name, current_list)
    winners = change_winners_array(human_name, computer_name, current_list)
    (0...current_list[:human].size).each do |index|
      display_history_row(winners, index, current_list)
    end
  end

  def change_winners_array(human_name, computer_name, current_list)
    current_list[:winner].map do |winner|
      case winner
      when :human then human_name
      when :computer then computer_name
      when :tie then "tie"
      end
    end
  end

  def display_history_row(winners, index, current_list)
    puts "  #{index + 1}".ljust(10) +
         current_list[:human][index].ljust(15) +
         current_list[:computer][index].ljust(15) +
         winners[index].ljust(15)
  end

  def select_players_moves
    result = { computer: [], human: [] }
    matches.each do |match|
      match[:winner].each_with_index do |round_winner, index|
        if round_winner == :human
          update_moves_when_human_win(match, result, index)
        elsif round_winner == :computer
          update_moves_when_computer_win(match, result, index)
        end
      end
    end
    result
  end

  def count_moves(player_moves, status)
    result = { rock: 0, paper: 0, scissors: 0, lizard: 0, spock: 0 }
    player_moves.each_with_object(result) do |move, hash|
      if move[1] == status
        hash[Move::AVAILABLE_MOVES.key(move[0])] += 1
      end
    end
  end

  def calculate_frequencies(moves_count, total)
    moves_count.each do |key, value|
      unless total.zero?
        moves_count[key] = (value.to_f / total).round(2)
      end
    end
  end

  def calculate_efficiency(player_moves)
    result = { rock: 0, paper: 0, scissors: 0, lizard: 0, spock: 0 }
    player_moves.each do |move|
      case move[1]
      when "win"
        result[Move::AVAILABLE_MOVES.key(move[0])] += 1
      when "loss"
        result[Move::AVAILABLE_MOVES.key(move[0])] -= 1
      end
    end
    result.max_by(result.size) { |_, value| value }
  end

  def update_moves_when_human_win(match, hash, index)
    hash[:computer] << [match[:computer][index], "loss"]
    hash[:human] << [match[:human][index], "win"]
  end

  def update_moves_when_computer_win(match, hash, index)
    hash[:computer] << [match[:computer][index], "win"]
    hash[:human] << [match[:human][index], "loss"]
  end
end
