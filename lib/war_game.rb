require_relative 'card_deck'
require_relative 'war_player'

class WarGame
  attr_reader :winner, :loser, :deck, :player1, :player2

  def initialize(
    first_player = 'Player 1',
    second_player = 'Player 2',
    card_deck = CardDeck.new
  )
    @winner = @loser = nil
    @deck = card_deck
    @player1 = Player.new(first_player)
    @player2 = Player.new(second_player)
    @value = {}
    ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    ranks.each_with_index { |rank, index| @value[rank] = index }
  end

  def start
    deck.shuffle_deck
    until deck.cards_left <= 0
      player1.add_card(deck.deal)
      player2.add_card(deck.deal)
    end
  end

  def play_round(cards_on_table = [])
    return "#{@winner.name} won the game. #{@loser.name} has no cards left." if any_winner?

    player_1_card = player1.deal
    player_2_card = player2.deal
    cards_on_table.push(player_1_card, player_2_card)
    case compare(player_1_card, player_2_card)
    when 'Draw'
      return play_round(cards_on_table)
    when 'Player 1'
      message = winning_message(player1.name, player_1_card, cards_on_table)
      cards_on_table.size.times do
        player1.add_card(cards_on_table.pop)
      end
    when 'Player 2'
      message = winning_message(player2.name, player_2_card, cards_on_table)
      cards_on_table.size.times do
        player2.add_card(cards_on_table.pop)
      end
    end
    message
  end

  def compare(card1, card2)
    if @value[card1.rank] == @value[card2.rank]
      'Draw'
    else
      @value[card1.rank] > @value[card2.rank] ? 'Player 1' : 'Player 2'
    end
  end

  def winning_message(name, winning_card, cards)
    losing_cards = cards.reject { |card| winning_card == card }
    losing_cards.map! { |card| card }
    "#{name} took #{losing_cards.join(', ')} with #{winning_card}."
  end

  def any_winner?
    if player2.cards_count.zero?
      @winner = player1
      @loser = player2
      return true
    elsif player1.cards_count.zero?
      @winner = player2
      @loser = player1
      return true
    end
    false
  end
end
