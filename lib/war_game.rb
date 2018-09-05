require_relative 'card_deck'
require_relative 'war_player'

class WarGame
  attr_reader :winner, :deck, :player1, :player2

  def initialize
    @winner = nil
    @deck = CardDeck.new
    @player1 = Player.new("Player 1")
    @player2 = Player.new("Player 2")
    @value = {}
    ranks = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    ranks.each_with_index do |rank, index|
      @value[rank] = index
    end

  end

  def start
    deck.shuffle_deck
    until deck.cardsLeft <= 0 do
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def play_round(cards_on_table = [])
    if any_cards_left_on_player
      return any_cards_left_on_player
    end
    message = nil
    player_1_card = player1.deal
    player_2_card = player2.deal
    cards_on_table.push(player_1_card)
    cards_on_table.push(player_2_card)
    case compare(player_1_card,player_2_card)
    when "Draw"
      return play_round(cards_on_table)
    when "Player 1"
      message = winning_message(player1.name, player_1_card, cards_on_table)
      cards_on_table.size.times do
        player1.add_card(cards_on_table.pop())
      end
    when "Player 2"
      message = winning_message(player2.name, player_2_card, cards_on_table)
      cards_on_table.size.times do
        player2.add_card(cards_on_table.pop())
      end
    end

    message
  end

  def compare(card1,card2)
    if @value[card1.rank] == @value[card2.rank]
      "Draw"
    elsif @value[card1.rank] > @value[card2.rank]
      "Player 1"
    else
      "Player 2"
    end
  end

  def winning_message(name, winning_card, cards)
    losing_cards = cards.reject do |card|
      winning_card == card
    end

    losing_cards.map! do |card|
      card.to_s
    end
    "#{name} took #{losing_cards.join(', ')} with #{winning_card.to_s}."
  end

  def any_cards_left_on_player
    if player2.cards_count == 0
      @winner = player1
      return "#{player2.name} has no card left."
    elsif player1.cards_count == 0
      @winner = player2
      return "#{player1.name} has no card left."
    end
    return false
  end

end
