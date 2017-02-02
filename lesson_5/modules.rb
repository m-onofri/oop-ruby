# module Displayable
# module CoinToss
# module PatternBoard5x5

module Displayable
  def prompt(string)
    puts "==> #{string}"
  end

  def check_yes_no_answer
    loop do
      answer = gets.chomp.downcase
      case answer
      when "y", "yes" then return true
      when "n", "no" then return false
      else prompt "Invalid answer; please enter yes or no"
      end
    end
  end

  def setup_title(step_num, tot_step)
    puts "SETUP GAME - STEP #{step_num} of #{tot_step}".center(60)
    puts
  end

  def return_yes_no_answer
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if answer == "y" || answer == "n"
      prompt "Invalid answer; please enter y or n"
    end
    answer
  end

  def prompt_to_continue(request)
    puts
    prompt request
    gets.chomp
    clear_screen
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def separator(width = 50, symbol = "=")
    puts symbol * width
  end

  def join_items(array, sep = ", ", last_sep = " or ")
    last_item = array[-1].to_s
    final_str = array[0..-2].join(sep)
    if array.size == 1
      final_str << last_item
    elsif final_str << last_sep + last_item
    end
    final_str
  end

  def play_again?
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def display_goodbye_message
    prompt "Thanks for playing Tic Tac Toe. Goodbye!"
  end
end

module CoinToss
  include Displayable

  def coin_toss_manager
    coin_toss = coin_toss_result
    user_choice = valid_coin_toss_choice
    display_coin_toss_result(coin_toss, user_choice)
  end

  def coin_toss_result
    case ["h", "t"].sample
    when "h" then "heads"
    when "t" then "tails"
    end
  end

  def valid_coin_toss_choice
    puts <<-EOF
     To choose who will start the game, we toss a coin:

     - (h)eads or

     - (t)ails?
    EOF
    loop do
      case gets.chomp.downcase
      when "heads", "h" then return "heads"
      when "tails", "t" then return "tails"
      else prompt "Please enter (h)eads or (t)ails."
      end
    end
  end

  def display_coin_toss_result(coin_toss, user_choice)
    prompt "You choose #{user_choice.upcase}."
    puts
    if user_choice == coin_toss
      prompt "The coin toss result is #{coin_toss.upcase}."
      puts
      prompt "YOU will start the game."
      return :human
    else
      prompt "The coin toss result is #{coin_toss.upcase}."
      puts
      prompt "COMPUTER will start the game."
      return :computer
    end
  end
end

module PatternBoard5x5
  def patterns_to_ignore_three_markers(user_marker, comp_marker)
    patt1 = patterns_to_ignore_three_markers_1(user_marker, comp_marker)
    patterns = total_patterns_three_markers(user_marker, comp_marker)
    rev_patterns = patterns.map(&:reverse)
    patt1 + patterns + rev_patterns
  end

  def patterns_to_ignore_three_markers_1(user_marker, comp_marker)
    [" " + comp_marker + user_marker + user_marker + user_marker,
     " " + user_marker + comp_marker + comp_marker + comp_marker,
     user_marker + user_marker + user_marker + comp_marker + " ",
     comp_marker + comp_marker + comp_marker + user_marker + " "]
  end

  def total_patterns_three_markers(user_marker, comp_marker)
    patterns_to_ignore_three_markers_2(user_marker, comp_marker) +
      patterns_to_ignore_three_markers_3(user_marker, comp_marker) +
      patterns_to_ignore_three_markers_4(user_marker, comp_marker) +
      patterns_to_ignore_three_markers_5(user_marker, comp_marker)
  end

  def patterns_to_ignore_three_markers_2(user_marker, comp_marker)
    [comp_marker + comp_marker + " " + user_marker + comp_marker,
     user_marker + user_marker + " " + comp_marker + user_marker,
     user_marker + user_marker + comp_marker + " " + user_marker,
     comp_marker + comp_marker + user_marker + " " + comp_marker]
  end

  def patterns_to_ignore_three_markers_3(user_marker, comp_marker)
    [comp_marker + comp_marker + " " + user_marker + comp_marker,
     user_marker + user_marker + " " + comp_marker + user_marker,
     user_marker + comp_marker + " " + comp_marker + comp_marker,
     comp_marker + user_marker + " " + user_marker + user_marker]
  end

  def patterns_to_ignore_three_markers_4(user_marker, comp_marker)
    [user_marker + comp_marker + user_marker + " " + user_marker,
     comp_marker + user_marker + user_marker + " " + user_marker,
     comp_marker + user_marker + comp_marker + " " + comp_marker,
     user_marker + comp_marker + comp_marker + " " + comp_marker]
  end

  def patterns_to_ignore_three_markers_5(user_marker, comp_marker)
    [comp_marker + comp_marker + user_marker + comp_marker,
     user_marker + user_marker + comp_marker + user_marker]
  end

  def patterns_to_ignore_two_markers(user_marker, comp_marker)
    patt1 = patterns_to_ignore_two_markers_1(user_marker, comp_marker)
    patt2 = patt1.map(&:reverse)
    patt3 = patterns_to_ignore_two_markers_2(user_marker, comp_marker)
    patt4 = patt3.map(&:reverse)
    asymmetric_pattern(user_marker, comp_marker) + patt1 + patt2 + patt3 + patt4
  end

  def asymmetric_pattern(user_marker, comp_marker)
    [user_marker + comp_marker + user_marker,
     comp_marker + user_marker + comp_marker]
  end

  def patterns_to_ignore_two_markers_1(user_marker, comp_marker)
    [user_marker + user_marker + comp_marker,
     comp_marker + comp_marker + user_marker]
  end

  def patterns_to_ignore_two_markers_2(user_marker, comp_marker)
    [user_marker + " " + user_marker + comp_marker,
     user_marker + " " + comp_marker + user_marker,
     user_marker + " " + comp_marker + comp_marker,
     comp_marker + " " + user_marker + user_marker,
     comp_marker + " " + user_marker + comp_marker,
     comp_marker + " " + comp_marker + user_marker]
  end
end
