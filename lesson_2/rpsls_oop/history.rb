class History
  attr_accessor :list

  def initialize
    @list = { human: [],
                    computer: [],
                    winner: []}
  end

  def push_values(human_move, computer_move, winner)
    list[:human] << human_move
    list[:computer] << computer_move
    list[:winner] << winner
  end

  def change_winners_array(human_name, computer_name)
    winners = list[:winner].map do |winner|
                case winner
                when :human then human_name
                when :computer then computer_name
                when :tie then "tie"
                end 
              end
  end

  def display_moves(human_name, computer_name)
    winners = change_winners_array(human_name, computer_name)
    puts "MOVES LIST".center(60)
    puts "ROUND".ljust(15) +"#{human_name}".ljust(15) + 
         "#{computer_name}".ljust(15) + "WINNER".ljust(15)
    puts ""
    (0...list[:human].size).each do |index|
      puts "  #{index + 1}".ljust(15) +
           "#{list[:human][index]}".ljust(15) +
           "#{list[:computer][index]}".ljust(15) + 
           "#{winners[index]}".ljust(15)        
    end
  end


end