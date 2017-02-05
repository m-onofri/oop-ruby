require_relative 'score'
require_relative 'player'
require_relative 'modules'
require 'pry'

class TOGame
  include Displayable

  attr_reader :deck, :player, :dealer, :score, :user_name

  def initialize
    game_description
    @user_name = set_name
    @score = Score.new
  end

  def set_name
    user_name = ''
    prompt "Please, enter your name:"
    loop do
      user_name = gets.chomp
      break if user_name =~ /^[A-Za-z0-9]+$/
      prompt "Please enter a valid name:"
    end
    user_name
  end

  def play
    loop do
      initialize_game!
      player_move = manage_moves(player)
      player_move == "stay" ? dealer_turn : prompt_bust
      prompt_to_continue("Press enter to continue the game")
      break if score.reached_max_points?
    end
    display_goodbye_message("Twenty-One")
  end

  def dealer_turn
    dealer.initialize_turn!
    dealer_move = manage_moves(dealer)
    dealer_move == "stay" ? compare_cards : prompt_bust
  end

  def compare_cards
    compare_players_cards
    update_score
  end

  private

  def game_description
    puts <<-WELCOME
  Welcome to #{Player::TARGET_SCORE}!
  Here the rules of the game:
  - in the game you will use a card deck of 52 card with 4 suits (hearts,
    diamonds, clubs, and spades), and 13 values (2, 3, 4, 5, 6, 7, 8, 9,
    10, jack, queen, king, ace)
  - the card with numbers from 2 to 10 are worth their face value
  - the jack, queen, and king cards are each worth 10 points
  - aces can be 1 or 11 points depending on the total value of the hand; if
    the total value is lower 21, ace is 11 points, otherwise is 1 point.
  - both the player will receive two cards
  - you can see both of your cards, but only one of the other player's
    (called dealer)
  - depending on cards, both players may choose to hit (receive another card)
    or stay
  - the dealer must stay with 17 or more points
  - the player who goes over #{Player::TARGET_SCORE} busts and lose the game
  - when both players stay, the player whose hand is closest to #{Player::TARGET_SCORE} wins
WELCOME

    prompt_to_continue("Press enter to start the game")
  end

  def display_participants_cards
    clear_screen
    display_cards(player)
    display_cards(dealer)
  end

  def display_cards(participant)
    puts "#{participant.name.upcase}'S CARD".center(34)
    participant.display_cards
    puts "Current points user: #{participant.cards_value}"
    puts "=" * 34
  end

  def display_score
    puts "SCORE:  user => #{score.points[:player]}   " \
         "dealer => #{score.points[:dealer]}"
    puts "=" * 34
  end

  def initialize_game!
    initialize_variables
    2.times do
      deck.deal_card!(player.cards.list)
      deck.deal_card!(dealer.cards.list)
    end
    player.initialize_game
    dealer.initialize_game
  end

  def initialize_variables
    @deck = Deck.new
    @player = Player.new(deck, user_name)
    @dealer = Dealer.new(deck, "Dealer")
  end

  def manage_moves(participant)
    loop do
      display_participants_cards
      display_score
      move = participant.select_move
      prompt "#{participant.name.capitalize} will #{move}!"
      participant.hit! if move == "hit"
      prompt_to_continue("Press enter to continue the game")
      return move if participant.stay?(move) || participant.bust?
    end
  end

  def update_score
    if round_winner == :player
      score.points[:player] += 1
    elsif round_winner == :dealer
      score.points[:dealer] += 1
    end
  end

  def manage_hit(cards, participant)
    deck.deal_card!(cards)
    participant.hit!
  end

  def compare_players_cards
    if round_winner == :player
      puts "USER WON!".center(34)
    elsif round_winner == :dealer
      puts "DEALER WON!".center(34)
    else
      puts "IT'S A TIE!".center(34)
    end
  end

  def round_winner
    case 
    when player.bust? then :dealer
    when dealer.bust? then :player
    when dealer_won? then :dealer
    when player_won? then :player
    end
  end

  def dealer_won?
    player.cards_value < dealer.cards_value
  end

  def player_won?
    player.cards_value > dealer.cards_value
  end

  def prompt_bust
    winner = round_winner
    display_participants_cards
    display_score
    score.points[winner] += 1
    if winner == :player
      puts "DEALER BUST! YOU WON!".center(34)
    elsif winner == :dealer
      puts "PLAYER BUST! DEALER WON!".center(34)
    end
  end
end

class Deck
  attr_reader :cards

  SUITS_SYMBOLS = %W(\u2660 \u2661 \u2662 \u2663).freeze

  def initialize
    @cards = set_cards
  end

  def set_cards
    SUITS_SYMBOLS.each_with_object({}) do |suit, cards|
      cards[suit] = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    end
  end

  def deal_card!(player_cards)
    current_suit = SUITS_SYMBOLS.sample
    current_value = cards[current_suit].sample
    player_cards << [current_suit, current_value]
    cards[current_suit].delete(current_value)
  end
end

TOGame.new.play
