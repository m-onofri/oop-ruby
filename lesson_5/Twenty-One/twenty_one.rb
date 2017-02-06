# class TOGame

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
      score.set_score
      round_game
      declare_winner
      break unless play_again?
    end
    display_goodbye_message("Twenty-One")
  end

  private

  def round_game
    loop do
      initialize_game!
      player_move = moves(player, user_name)
      player_move == "stay" ? dealer_turn : bust
      if score.reached_max_points?
        sleep_game(4)
        break
      end
      prompt_to_continue("Press enter to play the next round!")
    end
  end

  def declare_winner
    clear_screen
    puts ""
    if score.player_at_max_point == :player
      puts "#{user_name.upcase} WON THE GAME!".center(34)
    else
      puts "DEALER WON THE GAME!".center(34)
    end
    puts ""
    puts "=" * 34
    display_score
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

  def moves(participant, name)
    loop do
      display_game_info
      move = participant.select_move
      prompt "#{name.capitalize} will #{move}!"
      participant.hit! if move == "hit"
      sleep_game(2)
      return move if participant.stay?(move) || participant.bust?
    end
  end

  def dealer_turn
    dealer.initialize_turn!
    dealer_move = moves(dealer, "Dealer")
    dealer_move == "stay" ? compare_cards : bust
  end

  def compare_cards
    winner = round_winner
    display_round_result(winner)
    score.update(winner)
  end

  def display_round_result(winner)
    puts " "
    if winner == :player
      puts "#{user_name.upcase} WON!".center(34)
    elsif winner == :dealer
      puts "DEALER WON!".center(34)
    else
      puts "IT'S A TIE!".center(34)
    end
  end

  def bust
    winner = round_winner
    display_game_info
    score.update(winner)
    display_bust(winner)
  end

  def display_bust(winner)
    puts " "
    if winner == :player
      puts "DEALER BUST! YOU WON!".center(34)
    elsif winner == :dealer
      puts "#{user_name.upcase} BUST! DEALER WON!".center(34)
    end
  end

  def display_game_info
    display_participants_cards
    display_score
  end

  def round_winner
    return :dealer if player.bust?
    return :player if dealer.bust?
    return :dealer if dealer.beat?(player)
    return :player if player.beat?(dealer)
    :tie
  end
end
