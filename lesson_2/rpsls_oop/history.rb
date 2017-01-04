class History
  attr_accessor :list, :matches
 
  def initialize
    @matches = []
    @list = { human: [],
              computer: [],
              winner: []}
  end

  def push_values(human_move, computer_move, winner)
    list[:human] << human_move
    list[:computer] << computer_move
    list[:winner] << winner
  end

  def archive_matches
    matches << list
  end

  def reset_list
    @list = { human: [],
              computer: [],
              winner: []}
  end

  def display_full_game(human_name, computer_name)
    puts "MOVES LIST".center(60)
    puts "ROUND".ljust(15) +"#{human_name}".ljust(15) + 
         "#{computer_name}".ljust(15) + "WINNER".ljust(15)
    (0...matches.size).each do |n_match|
      puts "MATCH #{n_match + 1}".center(60)
      display_rounds(human_name, computer_name, matches[n_match])
    end
  end

  # status can be "win" or "loss"
  def computer_loss_moves_frequencies(status)
    computer_moves = select_players_moves[:computer]
    moves_count = computer_moves.reduce(Hash.new(0)) do |hash, move|
      if move[1] == status
        hash[move[0]] += 1
      end
      hash
    end
    moves_count.each { |key, value| moves_count[key] = (value.to_f / computer_moves.size).round(2) }
  end

  private

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