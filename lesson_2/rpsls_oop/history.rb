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


end