module FormatInfo
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

  def prompt_to_continue(request)
    prompt request
    gets.chomp
    clear_screen
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def separator(symbol = "=", width = 50)
    puts symbol * width
  end
end
