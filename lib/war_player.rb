class Player
  attr_reader :name
  def initialize(name)
    @name = name
    @cards_in_hand = []
  end

  def cards_count
    @cards_in_hand.size
  end

  def add_card(card)
    @cards_in_hand.unshift(card)
  end

  def deal
    @cards_in_hand.pop
  end
end
