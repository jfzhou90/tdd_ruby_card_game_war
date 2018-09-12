require_relative '../lib/card_deck'

describe 'CardDeck' do
  let(:card) { deck.deal }
  let(:card2) { deck2.deal }
  let(:deck) { CardDeck.new }
  let(:deck2) { CardDeck.new }

  it 'Should have 52 cards when created' do
    expect(deck.cards_left).to eq 52
  end

  it 'should deal the top card' do
    expect(card).to_not be_nil
    expect(deck.cards_left).to eq 51
  end

  it 'should shuffle the deck' do
    [deck, deck2].all?(&:shuffle_deck)
    expect(card && card2).to_not be_nil
    expect(card.to_s).to_not eq card2.to_s
  end
end
