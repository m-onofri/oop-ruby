require 'pry'
require_relative 'modules'

class Participant
  include Displayable

  attr_reader :deck

  TARGET_SCORE = 21

  def initialize(deck, _name)
    @deck = deck
  end

  def bust?
    cards.total_value > TARGET_SCORE
  end

  def stay?(move)
    move == "stay"
  end

  def hit!
    deck.deal_card!(cards.list)
    cards.new_formatted_card!
    cards.calculate_total_value!
  end

  def reset_game
    cards.total_value = 0
    cards.list = []
  end

  def display_cards
    cards.display
  end

  def cards_value
    cards.total_value
  end

  def cards_list
    cards.list
  end
end

class Player < Participant
  attr_reader :name
  attr_accessor :cards

  def initialize(_deck, name)
    super
    @cards = Cards.new
    @name = name
  end

  def select_move
    prompt "Would you like to (h)it or (s)tay?"
    loop do
      case gets.chomp.downcase
      when "h", "hit" then return "hit"
      when "s", "stay" then return "stay"
      else puts "Enter a valid action: (h)it or (s)tay"
      end
    end
  end

  def initialize_game
    cards.calculate_total_value!
    cards.format_two_cards
  end
end

class Dealer < Participant
  attr_reader :cards, :name

  DEALER_STAY_SCORE = 17

  def initialize(_deck, _name)
    super
    @cards = Cards.new
    @name = "Dealer"
  end

  def select_move
    cards.total_value < DEALER_STAY_SCORE ? "hit" : "stay"
  end

  def initialize_game
    cards.format_one_card
    cards.total_value = cards.single_card_value(cards.list[0])
  end

  def initialize_turn!
    cards.format_two_cards
    cards.total_value += cards.single_card_value(cards.list[1])
  end
end

class Cards
  TARGET_SCORE = 21

  attr_accessor :list, :formatted, :total_value

  def initialize
    @list = []
    @formatted = []
    @total_value = 0
  end

  # card_details = [suit, value]
  def format_card_details!(card_details)
    card_details.each do |val|
      case val
      when "2".."9" then card_details[1] = " #{val} "
      when "10" then card_details[1] = "#{val} "
      when "A", "J", "K", "Q" then card_details[1] = " #{val} "
      end
    end
  end

  def formatting_single_card(suit, value)
    ["   --------- ", "  |         |", "  |    #{suit}    |"] +
      ["  |   #{value}   |", "  |    #{suit}    |", "  |         |"] +
      ["   --------- "]
  end

  def add_formatted_card!(new_card)
    formatted.each_with_index do |_, index|
      self.formatted[index] += "    " + new_card[index]
    end
  end

  def format_two_cards
    card_1_details = format_card_details!(list[0])
    card_2_details = format_card_details!(list[1])
    self.formatted = formatting_single_card(card_1_details[0], card_1_details[1])
    new_card = formatting_single_card(card_2_details[0], card_2_details[1])

    add_formatted_card!(new_card)
  end

  def format_one_card
    card_1_details = format_card_details!(list[0])

    self.formatted = formatting_single_card(card_1_details[0], card_1_details[1])
    hidden_card = ["   --------- ", "  |         |"] +
                  ["  | HIDDEN  |", "  |         |"] +
                  ["  |  CARD   |", "  |         |", "   --------- "]

    add_formatted_card!(hidden_card)
  end

  def new_formatted_card!
    new_card = list.last
    new_card_details = format_card_details!(new_card)

    last_card = formatting_single_card(new_card_details[0], new_card_details[1])
    add_formatted_card!(last_card)
  end

  def calculate_total_value!
    self.total_value = 0
    list.each do |card|
      self.total_value += single_card_value(card)
    end
    list.select { |val| val[1].strip == "A" }.count.times do
      self.total_value -= 10 if total_value > TARGET_SCORE
    end
    #binding.pry
  end

  def single_card_value(card)
    case card[1].strip
    when "2".."10" then card[1].to_i
    when "J", "Q", "K" then 10
    when "A" then 11
    end
  end

  def display
    formatted.each { |line| puts line }
  end
end




