require_relative 'playing_card'

class CardDeck
  def initialize
    suits = %w(Clubs Diamonds Hearts Spades)
    ranks = %w(2 3 4 5 6 7 8 9 10 J Q K A)

    @cards_left = ranks.map {|rank|
      suits.map {|suit|
        Card.new(rank, suit)
      }
    }.flatten
  end

  def cardsLeft
    @cards_left.size
  end

  def deal
    @cards_left.pop
  end

  def shuffle_deck
    @cards_left.shuffle!
  end
end
