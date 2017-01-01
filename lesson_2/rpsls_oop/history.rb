class History
  attr_accessor :moves_list

  def initialize
    @moves_list = { human: [],
                    computer: [],
                    winner: []}
  end

  def push_values(human_move, computer_move, winner)
    moves_list[:human] << human_move
    moves_list[:computer] << computer_move
    moves_list[:winner] << winner
  end

  def display_moves(human_name, computer_name)
    rounds = moves_list[:winner].size
    puts "MOVES LIST".center(50)
    puts "ROUND   #{human_name}".ljust(25) + 
         "#{computer_name}      WINNER".rjust(25)
    (0...rounds).each do |index|
      puts "  #{index + 1}       #{moves_list[:human][index]}".ljust(25) +
           "#{moves_list[:computer][index]}        #{moves_list[:winner][index]}".rjust(25)        
    end
  end


end