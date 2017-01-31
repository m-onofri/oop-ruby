

class Board
  include Displayable

  attr_reader :squares, :user_marker, :comp_marker

  def initialize(markers)
    @user_marker = markers[:human]
    @comp_marker = markers[:computer]
    reset_squares
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
