require_relative 'modules'
require 'pry'

class Board
  include Displayable

  attr_reader :squares, :user_marker, :computer_marker

  def initialize(markers)
    @user_marker = markers[:human]
    @computer_marker = markers[:computer]
    reset_squares
  end

  def available_squares
    squares.select { |_, square| !square.marked? }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def human_square_selection(marker)
    player_choice = human_chose_move
    @squares[player_choice].marker = marker
  end

  def computer_square_selection(marker)
    player_choice = computer_chose_move
    @squares[player_choice].marker = marker
    puts player_choice
  end

  private

  def human_chose_move
    puts "Please mark a free square: #{join_items(available_squares)}"
    user_choice = ""
    loop do
      user_choice = gets.chomp.to_i
      break if available_squares.include?(user_choice)
      puts "Please select a valid square"
    end
    user_choice
  end
end

class Board3 < Board

  WINNING_ROWS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                  [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def reset_squares
    @squares = (1..9).each_with_object({}) do |num, hash|
      hash[num] = Square.new
    end
  end

  # rubocop:disable Metrics/AbcSize
  def display
    puts ""
    puts " 1   |2    |3    ".center(50)
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  ".center(50)
    puts "     |     |     ".center(50)
    puts "-----+-----+-----".center(50)
    puts " 4   |5    |6    ".center(50)
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}  ".center(50)
    puts "     |     |     ".center(50)
    puts "-----+-----+-----".center(50)
    puts " 7   |8    |9    ".center(50)
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}  ".center(50)
    puts "     |     |     ".center(50)
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def winning_marker
    WINNING_ROWS.each do |row|
      squares = @squares.values_at(*row)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def computer_chose_move
    offensive_move = smart_choice(computer_marker)
    return offensive_move unless offensive_move.nil?
    defensive_move = smart_choice(user_marker)
    return defensive_move unless defensive_move.nil?
    return 5 if squares[5].marker == Square::EMPTY_SQUARE
    available_squares.sample
  end

  def smart_choice(marker)
    WINNING_ROWS.each do |row|
      next unless two_third_winning_row(marker, row)
      row.each do |square|
        return square if squares[square].marker == Square::EMPTY_SQUARE
      end
    end
    nil
  end

  def two_third_winning_row(marker, row)
    squares.values_at(*row).map(&:marker).count(marker) == 2
  end
end

class Board5 < Board

  WINNING_ROWS = [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15],
                  [16, 17, 18, 19, 20], [21, 22, 23, 24, 25],
                  [1, 6, 11, 16, 21], [2, 7, 12, 17, 22], 
                  [3, 8, 13, 18, 23], [4, 9, 14, 19, 24],
                  [5, 10, 15, 20, 25], [1, 7, 13, 19, 25],
                  [5, 9, 13, 17, 21], [4, 8, 12, 16],
                  [10, 14, 18, 22], [2, 8, 14, 20],[6, 12, 18, 24]].freeze

  def reset_squares
    @squares = (1..25).each_with_object({}) do |num, hash|
      hash[num] = Square.new
    end
  end

  # rubocop:disable Metrics/AbcSize
  def display
    puts ""
    puts " 1   |2    |3    |4    |5    ".center(50)
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  |" \
         "  #{squares[4]}  |  #{squares[5]}  ".center(50)
    puts "     |     |     |     |     ".center(50)
    puts "-----+-----+-----+-----+-----".center(50)
    puts " 6   |7    |8    |9    |10   ".center(50)
    puts "  #{squares[6]}  |  #{squares[7]}  |  #{squares[8]}  |" \
         "  #{squares[9]}  |  #{squares[10]}  ".center(50)
    puts "     |     |     |     |     ".center(50)
    puts "-----+-----+-----+-----+-----".center(50)
    puts " 11  |12   |13   |14   |15   ".center(50)
    puts "  #{squares[11]}  |  #{squares[12]}  |  #{squares[13]}  |" \
         "  #{squares[14]}  |  #{squares[15]}  ".center(50)
    puts "     |     |     |     |     ".center(50)
    puts "-----+-----+-----+-----+-----".center(50)
    puts " 16  |17   |18   |19   |20   ".center(50)
    puts "  #{squares[16]}  |  #{squares[17]}  |  #{squares[18]}  |" \
         "  #{squares[19]}  |  #{squares[20]}  ".center(50)
    puts "     |     |     |     |     ".center(50)
    puts "-----+-----+-----+-----+-----".center(50)
    puts " 21  |22   |23   |24   |25   ".center(50)
    puts "  #{squares[21]}  |  #{squares[22]}  |  #{squares[23]}  |" \
         "  #{squares[24]}  |  #{squares[25]}  ".center(50)
    puts "     |     |     |     |     ".center(50)
    puts ""
  end
  # rubocop:enable Metrics/AbcSize

  def winning_marker
    WINNING_ROWS.each do |row|
      squares = @squares.values_at(*row)
      if four_identical_markers?(squares)
        marker_winner = squares.reduce(Hash.new(0)) do |hash, square|
          hash[square.marker] += 1; hash
        end
        return marker_winner.key(4)
      end
    end
    nil
  end

  private

  def four_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker).join
    human_string_win = user_marker * 4
    computer_string_win = computer_marker * 4
    markers.include?(human_string_win) || markers.include?(computer_string_win)
  end

  def computer_chose_move
    offensive_move = smart_choice(computer_marker)
    return offensive_move unless offensive_move.nil?
    first_defensive_move = smart_choice(user_marker)
    return first_defensive_move unless first_defensive_move.nil?
    second_defensive_move = second_defence(user_marker)
    return second_defensive_move unless second_defensive_move.nil?
    return 13 if empty_square?(13)
    best_alt = [7, 8, 9, 12, 14, 17, 18, 19].sample
    return best_alt if empty_square?(best_alt)
    available_squares.sample
  end

  def empty_square?(square)
    squares[square].marker == Square::EMPTY_SQUARE
  end

  def second_defence(marker)
    WINNING_ROWS.each do |row|
      next unless two_markers_in_a_row?(marker, row)
      row_string = squares.values_at(*row).map(&:marker).join
      if row_string.include?(marker * 2)
        index = row_string.index(marker * 2)
        if index != 0 || !squares[row[index - 1]].marked?
          return row[index - 1]
        elsif !squares[row[index + 2]].marked?
          return row[index + 2]
        end
      elsif row_string.include?(marker + " " + marker)
        index = row_string.index(marker + " " + marker)
        return row[index + 1]
      end
      row.each do |square|
        return square if squares[square].marker == Square::EMPTY_SQUARE
      end
    end
    nil
  end

  def smart_choice(marker)
    WINNING_ROWS.each do |row|
      next unless three_markers_in_a_row?(marker, row)
      row_string = squares.values_at(*row).map(&:marker).join
      if row_string.include?(marker * 3)
        square_index = row_string.index(marker * 3)
        if square_index != 0 && squares[row[square_index - 1]].unmarked?
          return row[square_index - 1]
        elsif (square_index + 3) <row.size && squares[row[square_index + 3]].unmarked?
          return row[square_index + 3]
        end
      elsif row_string.include?(marker + " " + marker + marker)
        square_index = row_string.index(marker + " " + marker + marker)
        return row[square_index + 1]
      elsif row_string.include?(marker + marker + " " + marker)
        square_index = row_string.index(marker + " " + marker + marker)
        return row[square_index + 2]
      end
      row.each do |square|
        return square if squares[square].marker == Square::EMPTY_SQUARE
      end
    end
    nil
  end

  def two_markers_in_a_row?(marker, row)
    if squares.values_at(*row).map(&:marker).count(marker) == 2
      row_string = squares.values_at(*row).map(&:marker).join
      bad_patterns = [user_marker + computer_marker + user_marker,
                      user_marker + user_marker + computer_marker,
                      computer_marker + user_marker + user_marker,
                      computer_marker + user_marker + computer_marker,
                      computer_marker + computer_marker + user_marker,
                      user_marker + computer_marker + computer_marker]
      bad_patterns.each do |pattern|
        return false if row_string.include?(pattern)
      end
      return true
    end
  end

  def three_markers_in_a_row?(marker, row)
    squares.values_at(*row).map(&:marker).count(marker) == 3
  end
end

class Square
  attr_accessor :marker

  EMPTY_SQUARE = " ".freeze

  def initialize
    @marker = EMPTY_SQUARE
  end

  def marked?
    marker != EMPTY_SQUARE
  end

  def unmarked?
    marker == EMPTY_SQUARE
  end

  def to_s
    marker
  end
end

