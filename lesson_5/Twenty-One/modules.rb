# module Displayable

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

  def sleep_game(sec)
    prompt "Please wait for your next turn..."
    sleep(sec)
  end

  def display_goodbye_message(game)
    prompt "Thanks for playing #{game}. Goodbye!"
  end
end
