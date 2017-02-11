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

  def play_again?
    puts ""
    prompt "Would you like to play again?(y/n)"
    check_yes_no_answer
  end

  def sleep_game(sec)
    puts ""
    prompt "Please wait..."
    sleep(sec)
  end

  def display_goodbye_message(game)
    prompt "Thanks for playing #{game}. Goodbye!"
  end

  # rubocop:disable Metrics/MethodLength
  def game_description
    clear_screen
    puts <<-WELCOME
  Welcome to #{Cards::TARGET_SCORE}!
  Here the rules of the game:
  - in the game you will use a card deck of 52 card with 4 suits (hearts,
    diamonds, clubs, and spades), and 13 values (2, 3, 4, 5, 6, 7, 8, 9,
    10, jack, queen, king, ace)
  - the card with numbers from 2 to 10 are worth their face value
  - the jack, queen, and king cards are each worth 10 points
  - aces can be 1 or 11 points depending on the total value of the hand; if
    the total value is lower #{Cards::TARGET_SCORE}, ace is 11 points, otherwise is 1 point.
  - both the player will receive two cards
  - you can see both of your cards, but only one of the other player's
    (called dealer)
  - depending on cards, both players may choose to hit (receive another card)
    or stay
  - the dealer must stay with #{DealerCards::DEALER_STAY_SCORE} or more points
  - the player who goes over #{Cards::TARGET_SCORE} busts and lose the game
  - when both players stay, the player whose hand is closest to #{Cards::TARGET_SCORE} wins
WELCOME

    prompt_to_continue("Press enter to start the game")
  end
  # rubocop:enable Metrics/MethodLength

  def display_participants_cards
    clear_screen
    display_cards(player, user_name)
    display_cards(dealer, "dealer")
  end

  def display_cards(participant, name)
    puts "#{name.upcase}'S CARDS".center(34)
    participant.display_cards
    puts "Current points user: #{participant.cards_value}".center(34)
    separator(34)
  end

  def display_score
    puts "Score (max points = #{score.max_points})".center(34)
    puts "#{user_name} => #{score.points[:player]}   " \
         "Dealer => #{score.points[:dealer]}".center(34)
    separator(34)
  end
end
