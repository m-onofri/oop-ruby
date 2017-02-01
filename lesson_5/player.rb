class Player
  include Displayable

  attr_reader :name, :board

  def initialize(name, board)
    @name = name
    @board = board
  end
end

class Human < Player
  def chose_move
    puts "Please mark a free square: #{join_items(board.available_squares)}"
    user_choice = ""
    loop do
      user_choice = gets.chomp.to_i
      break if board.available_squares.include?(user_choice)
      puts "Please select a valid square"
    end
    user_choice
  end
end

class Computer3 < Player
  def chose_move
    offensive_move = smart_choice(board.comp_marker)
    return offensive_move unless offensive_move.nil?
    defensive_move = smart_choice(board.user_marker)
    return defensive_move unless defensive_move.nil?
    return 5 if board.squares[5].marker == Square::EMPTY_SQUARE
    board.available_squares.sample
  end

  private

  def smart_choice(marker)
    Board3::WINNING_ROWS.each do |row|
      next unless two_third_winning_row?(marker, row)
      row.each do |square|
        return square if board.squares[square].marker == Square::EMPTY_SQUARE
      end
    end
    nil
  end

  def two_third_winning_row?(marker, row)
    board.squares.values_at(*row).map(&:marker).count(marker) == 2
  end
end

class Computer5 < Player
  include PatternBoard5x5

  def chose_move
    offensive_move = smart_choice(board.comp_marker)
    return offensive_move unless offensive_move.nil?
    first_defensive_move = smart_choice(board.user_marker)
    return first_defensive_move unless first_defensive_move.nil?
    second_offensive_move = second_level_choice(board.comp_marker)
    return second_offensive_move unless second_offensive_move.nil?
    second_defensive_move = second_level_choice(board.user_marker)
    return second_defensive_move unless second_defensive_move.nil?
    basic_moves
  end

  def smart_choice(marker)
    Board5::WINNING_ROWS.each do |row|
      next unless three_markers_in_a_row?(marker, row)
      move = set_smart_choice_move(row, marker)
      return move unless move.nil?
      row.each do |square|
        return square if board.squares[square].unmarked?
      end
    end
    nil
  end

  def set_smart_choice_move(row, marker)
    pattern = marker + " " + marker + marker
    smart_choice_move(row, marker, pattern)
  end

  def smart_choice_move(row, marker, pattern)
    row_string = row_array(row).join
    if row_string.include?(marker * 3)
      move = move_for_three_consecutive_marker(row_string, marker, row)
      return move unless move.nil?
    elsif row_string.include?(pattern)
      square_index = row_string.index(pattern)
      return row[square_index + 1]
    elsif row_string.include?(pattern.reverse)
      square_index = row_string.index(pattern.reverse)
      return row[square_index + 2]
    end
    nil
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
    user_marker = board.user_marker
    comp_marker = board.comp_marker
    if row_array(row).count(marker) == 3
      row_string = row_array(row).join
      patterns_to_ignore_three_markers(user_marker, comp_marker).each do |p|
        return false if row_string.include?(p)
      end
      true
    end
  end

  def second_level_choice(marker)
    Board5::WINNING_ROWS.each do |row|
      next unless two_markers_in_a_row?(marker, row)
      move = set_second_level_move(row, marker)
      return move unless move.nil?
      row.each do |square|
        return square if board.squares[square].unmarked?
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
    user_marker = board.user_marker
    comp_marker = board.comp_marker
    if row_array(row).count(marker) == 2
      row_string = row_array(row).join
      patterns_to_ignore_two_markers(user_marker, comp_marker).each do |p|
        return false if row_string.include?(p)
      end
      true
    end
  end

  def basic_moves
    alt_square = [7, 8, 9, 12, 14, 17, 18, 19].sample
    if board.squares[13].unmarked?
      13
    elsif board.squares[alt_square].unmarked?
      alt_square
    else
      board.available_squares.sample
    end
  end

  def previous_square_available?(index, row)
    index.nonzero? && board.squares[row[index - 1]].unmarked?
  end

  def next_square_available?(index, row, num)
    (index + num) < row.size && board.squares[row[index + num]].unmarked?
  end

  def row_array(row)
    board.squares.values_at(*row).map(&:marker)
  end
end
