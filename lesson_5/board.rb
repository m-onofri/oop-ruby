require_relative 'modules'

class Board
  include Displayable

  attr_reader :squares, :user_marker, :comp_marker

  def initialize(markers)
    @user_marker = markers[:human]
    @comp_marker = markers[:computer]
    reset_squares
  end

  def human_square_selection(marker)
    player_choice = human_chose_move
    @squares[player_choice].marker = marker
  end

  def computer_square_selection(marker)
    player_choice = computer_chose_move
    @squares[player_choice].marker = marker
  end

  def available_squares
    squares.select { |_, square| square.unmarked? }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    !!winner_marker
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

  def reset_squares
    @squares = (1..9).each_with_object({}) do |num, hash|
      hash[num] = Square.new
    end
  end

  def winner_marker
    WINNING_ROWS.each do |row|
      squares = @squares.values_at(*row)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def computer_chose_move
    offensive_move = smart_choice(comp_marker)
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
                  [10, 14, 18, 22], [2, 8, 14, 20], [6, 12, 18, 24]].freeze

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def display
    puts ""
    puts " 1     |2      |3      |4      |5      ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "   #{squares[1]}   |   #{squares[2]}   |   #{squares[3]}   |" \
         "   #{squares[4]}   |   #{squares[5]}   ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "-------+-------+-------+-------+-------".center(60)
    puts " 6     |7      |8      |9      |10     ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "   #{squares[6]}   |   #{squares[7]}   |   #{squares[8]}   |" \
         "   #{squares[9]}   |   #{squares[10]}   ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "-------+-------+-------+-------+-------".center(60)
    puts " 11    |12     |13     |14     |15     ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "   #{squares[11]}   |   #{squares[12]}   |   #{squares[13]}   |" \
         "   #{squares[14]}   |   #{squares[15]}   ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "-------+-------+-------+-------+-------".center(60)
    puts " 16    |17     |18     |19     |20     ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "   #{squares[16]}   |   #{squares[17]}   |   #{squares[18]}   |" \
         "   #{squares[19]}   |   #{squares[20]}   ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "-------+-------+-------+-------+-------".center(60)
    puts " 21    |22     |23     |24     |25     ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts "   #{squares[21]}   |   #{squares[22]}   |   #{squares[23]}   |" \
         "   #{squares[24]}   |   #{squares[25]}   ".center(60)
    puts "       |       |       |       |       ".center(60)
    puts ""
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def reset_squares
    @squares = (1..25).each_with_object({}) do |num, hash|
      hash[num] = Square.new
    end
  end

  def winner_marker
    WINNING_ROWS.each do |row|
      squares = @squares.values_at(*row)
      next unless four_identical_markers?(squares)
      winner = squares.each_with_object(Hash.new(0)) do |square, hash|
        hash[square.marker] += 1
      end
      return winner.key(4)
    end
    nil
  end

  private

  def four_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker).join
    human_string_win = user_marker * 4
    computer_string_win = comp_marker * 4
    markers.include?(human_string_win) || markers.include?(computer_string_win)
  end

  def computer_chose_move
    offensive_move = smart_choice(comp_marker)
    return offensive_move unless offensive_move.nil?
    first_defensive_move = smart_choice(user_marker)
    return first_defensive_move unless first_defensive_move.nil?
    second_offensive_move = second_level_choice(comp_marker)
    return second_offensive_move unless second_offensive_move.nil?
    second_defensive_move = second_level_choice(user_marker)
    return second_defensive_move unless second_defensive_move.nil?
    basic_moves
  end

  def smart_choice(marker)
    WINNING_ROWS.each do |row|
      next unless three_markers_in_a_row?(marker, row)
      move = set_smart_choice_move(row, marker)
      return move unless move.nil?
      row.each do |square|
        return square if squares[square].unmarked?
      end
    end
    nil
  end

  def set_smart_choice_move(row, marker)
    row_string = row_array(row).join
    pattern1 = marker + " " + marker + marker
    pattern2 = marker + marker + " " + marker
    smart_choice_move(row_string, row, marker, pattern2, pattern1)
  end

  def smart_choice_move(row_string, row, marker, pattern2, pattern1)
    if row_string.include?(marker * 3)
      move = move_for_three_consecutive_marker(row_string, marker, row)
      return move unless move.nil?
    elsif pattern_included?(row_string, pattern1)
      square_index = find_index(row_string, pattern1)
      return row[square_index + 1]
    elsif pattern_included?(row_string, pattern2)
      square_index = find_index(row_string, pattern2)
      return row[square_index + 2]
    end
    nil
  end

  def pattern_included?(string, pattern)
    string.include?(pattern)
  end

  def move_for_three_consecutive_marker(row_string, marker, row)
    square_index = row_string.index(marker * 3)
    if previous_square_available?(square_index, row)
      return row[square_index - 1]
    elsif next_square_available?(square_index, row, 3)
      return row[square_index + 3]
    end
    nil
  end

  def three_markers_in_a_row?(marker, row)
    if row_array(row).count(marker) == 3
      row_string = row_array(row).join
      patterns_to_ignore_three_markers.each do |pattern|
        return false if row_string.include?(pattern)
      end
      true
    end
  end

  def patterns_to_ignore_three_markers
    patt1 = patterns_to_ignore_three_markers_1
    patterns = total_patterns_three_markers
    rev_patterns = patterns.map { |p| p.chars.reverse.join }
    patt1 + patterns + rev_patterns
  end

  def patterns_to_ignore_three_markers_1
    [" " + @comp_marker + @user_marker + @user_marker + @user_marker,
     " " + @user_marker + @comp_marker + @comp_marker + @comp_marker,
     @user_marker + @user_marker + @user_marker + @comp_marker + " ",
     @comp_marker + @comp_marker + @comp_marker + @user_marker + " "]
  end

  def total_patterns_three_markers
    patterns_to_ignore_three_markers_2 +
      patterns_to_ignore_three_markers_3 +
      patterns_to_ignore_three_markers_4 +
      patterns_to_ignore_three_markers_5
  end

  def patterns_to_ignore_three_markers_2
    [@comp_marker + @comp_marker + " " + @user_marker + @comp_marker,
     @user_marker + @user_marker + " " + @comp_marker + @user_marker,
     @user_marker + @user_marker + @comp_marker + " " + @user_marker,
     @comp_marker + @comp_marker + @user_marker + " " + @comp_marker]
  end

  def patterns_to_ignore_three_markers_3
    [@comp_marker + @comp_marker + " " + @user_marker + @comp_marker,
     @user_marker + @user_marker + " " + @comp_marker + @user_marker,
     @user_marker + @comp_marker + " " + @comp_marker + @comp_marker,
     @comp_marker + @user_marker + " " + @user_marker + @user_marker]
  end

  def patterns_to_ignore_three_markers_4
    [@user_marker + @comp_marker + @user_marker + " " + @user_marker,
     @comp_marker + @user_marker + @user_marker + " " + @user_marker,
     @comp_marker + @user_marker + @comp_marker + " " + @comp_marker,
     @user_marker + @comp_marker + @comp_marker + " " + @comp_marker]
  end

  def patterns_to_ignore_three_markers_5
    [@comp_marker + @comp_marker + @user_marker + @comp_marker,
     @user_marker + @user_marker + @comp_marker + @user_marker]
  end

  def second_level_choice(marker)
    WINNING_ROWS.each do |row|
      next unless two_markers_in_a_row?(marker, row)
      move = set_second_level_move(row, marker)
      return move unless move.nil?
      row.each do |square|
        return square if squares[square].unmarked?
      end
    end
    nil
  end

  def set_second_level_move(row, marker)
    row_string = row_array(row).join
    if row_string.include?(marker * 2)
      move = move_for_two_consecutive_marker(row_string, marker, row)
      return move unless move.nil?
    elsif row_string.include?(marker + " " + marker)
      index = row_string.index(marker + " " + marker)
      return row[index + 1]
    end
    nil
  end

  def move_for_two_consecutive_marker(row_string, marker, row)
    index = row_string.index(marker * 2)
    if previous_square_available?(index, row)
      return row[index - 1]
    elsif next_square_available?(index, row, 2)
      return row[index + 2]
    end
    nil
  end

  def two_markers_in_a_row?(marker, row)
    if row_array(row).count(marker) == 2
      row_string = row_array(row).join
      patterns_to_ignore_two_markers.each do |pattern|
        return false if row_string.include?(pattern)
      end
      true
    end
  end

  def patterns_to_ignore_two_markers
    patt1 = patterns_to_ignore_two_markers_1
    patt2 = patt1.map { |p| p.chars.reverse.join }
    patt3 = patterns_to_ignore_two_markers_2
    patt4 = patt3.map { |p| p.chars.reverse.join }
    asymmetric_pattern + patt1 + patt2 + patt3 + patt4
  end

  def asymmetric_pattern
    [@user_marker + @comp_marker + @user_marker,
     @comp_marker + @user_marker + @comp_marker]
  end

  def patterns_to_ignore_two_markers_1
    [@user_marker + @user_marker + @comp_marker,
     @comp_marker + @comp_marker + @user_marker]
  end

  def patterns_to_ignore_two_markers_2
    [@user_marker + " " + @user_marker + @comp_marker,
     @user_marker + " " + @comp_marker + @user_marker,
     @user_marker + " " + @comp_marker + @comp_marker,
     @comp_marker + " " + @user_marker + @user_marker,
     @comp_marker + " " + @user_marker + @comp_marker,
     @comp_marker + " " + @comp_marker + @user_marker]
  end

  def basic_moves
    alt_square = best_choice
    if squares[13].unmarked?
      13
    elsif squares[alt_square].unmarked?
      alt_square
    else
      available_squares.sample
    end
  end

  def best_choice
    [7, 8, 9, 12, 14, 17, 18, 19].sample
  end

  def previous_square_available?(index, row)
    index.nonzero? && squares[row[index - 1]].unmarked?
  end

  def next_square_available?(index, row, num)
    (index + num) < row.size && squares[row[index + num]].unmarked?
  end

  def find_index(string, pattern)
    string.index(pattern)
  end

  def row_array(row)
    squares.values_at(*row).map(&:marker)
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
