# class Deck

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
