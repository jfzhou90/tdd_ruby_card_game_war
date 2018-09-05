require_relative '../lib/card_deck'

describe 'CardDeck' do
  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cardsLeft).to eq 52
  end

  it 'should deal the top card' do
    deck = CardDeck.new
    card = deck.deal
    expect(card).to_not be_nil
    expect(deck.cardsLeft).to eq 51
  end

  it 'should shuffle the deck' do
    deck = CardDeck.new
    deck2 = CardDeck.new
    deck.shuffle_deck
    deck2.shuffle_deck
    card = deck.deal
    card2 = deck2.deal
    expect(card).to_not be_nil
    expect(card2).to_not be_nil
    expect(card.to_s).to_not eq (card2.to_s)
  end
end
