require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it '#initialize making sure card is correctly initialized' do
    card = Card.new('J', 'Heart')
    expect(card.rank).not_to be('A')
    expect(card.rank).to(eql('J'))
    expect(card.suit).not_to be('Ace')
    expect(card.suit).to(eql('Heart'))
  end

  it '#== making sure it\'s not the same card' do
    card = Card.new('J', 'Heart')
    card2 = Card.new('J', 'Heart')
    card3 = Card.new('K', 'Heart')
    card4 = Card.new('J', 'Clubs')
    expect(card == card2).to be(true)
    expect(card == card3).to be(false)
    expect(card == card4).to be(false)
    expect(card2 == card3).to be(false)
    expect(card3 == card4).to be(false)
  end
end
