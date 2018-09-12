require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  before(:each) do
    @player = Player.new('Player 1')
    card = Card.new('K', 'Diamond')
    @player.add_card(card)
  end

  it '#cards_count returns the correct number of card after adding one' do
    expect(@player.cards_count).to(eql(1))
  end

  it '#deal deals the card in hand' do
    dealt = @player.deal
    expect(dealt).to be_instance_of(Card)
    expect(dealt.suit).to(eql('Diamond'))
  end

  it '#deal making sure the last card is not the top card' do
    card = Card.new('A', 'Heart')
    @player.add_card(card)
    @player.deal
    dealt = @player.deal
    expect(dealt).to be_instance_of(Card)
    expect(dealt.suit).to(eql('Heart'))
  end
end
