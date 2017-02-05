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

  private

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

  def initialize_game!
    initialize_variables
    2.times do
      deck.deal_card!(player.cards_list)
      deck.deal_card!(dealer.cards_list)
    end
    player.initialize_cards
    dealer.initialize_cards
  end

  def initialize_variables
    @deck = Deck.new
    @player = PlayerCards.new(deck)
    @dealer = DealerCards.new(deck)
  end

  def manage_moves(participant)
    loop do
      display_participants_cards
      display_score
      move = participant.select_move
      prompt "#{user_name.capitalize} will #{move}!"
      participant.hit! if move == "hit"
      prompt_to_continue("Press enter to continue the game")
      return move if participant.stay?(move) || participant.bust?
    end
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

  def compare_players_cards
    if round_winner == :player
      puts "USER WON!".center(34)
    elsif round_winner == :dealer
      puts "DEALER WON!".center(34)
    else
      puts "IT'S A TIE!".center(34)
    end
  end

  def update_score
    if round_winner == :player
      score.points[:player] += 1
    elsif round_winner == :dealer
      score.points[:dealer] += 1
    end
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

  def round_winner
    case 
    when player.bust? then :dealer
    when dealer.bust? then :player
    when dealer.beat?(player) then :dealer
    when player.beat?(dealer) then :player
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
