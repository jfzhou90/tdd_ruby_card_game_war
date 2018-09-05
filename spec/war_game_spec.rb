require_relative '../lib/war_game'
require_relative '../lib/playing_card'

describe 'WarGame' do
  describe '#Initialize' do
    before :each do
      @game = WarGame.new
    end

    it 'sets winner attribute to nil.' do
      expect(@game.winner).to(eql(nil))
    end

    it 'create 2 instances of players.' do
      expect(@game.player1).to be_instance_of(Player)
      expect(@game.player2).to be_instance_of(Player)
    end

    it 'create a deck of 52 cards' do
      expect(@game.deck.cardsLeft).to(eql(52))
    end
  end

  describe '#start' do
    it 'distribute the cards evenly to players' do
      game = WarGame.new
      game.start
      expect(game.player1.cards_count).to be(26)
      expect(game.player2.cards_count).to be(26)
    end
  end

  describe '#play_round' do
    it 'plays a round of war game, player should not have 26 cards left' do
      game = WarGame.new
      game.start
      expect(game.play_round).to be_a(String)
      expect(game.player1.cards_count).to be_a(Numeric)
      expect(game.player1.cards_count).not_to be(26)
    end
  end

  describe '#compare' do
    let(:card_1) { Card.new("A","Ace") }
    let(:card_2) { Card.new("K","Hearts") }
    before :each do
      @game = WarGame.new
    end

    it 'compares both cards and return a the winner Player 1' do
      expect(@game.compare(card_1, card_2)).to eq("Player 1")
    end

    it 'compares both cards and return a the winner Player 2' do
      expect(@game.compare(card_2, card_1)).to eq("Player 2")
    end

    it 'compares both cards and return a draw if the same rank' do
      expect(@game.compare(card_1, card_1)).to eq("Draw")
    end
  end

  describe '#messages_display' do
    let(:card_1) { Card.new("A","Ace") }
    let(:card_2) { Card.new("K","Hearts") }
    it 'sends the correct message for winner' do
      game = WarGame.new
      card_array = [card_1, card_2]
      message = game.winning_message(game.player1.name, card_1, card_array)
      expect(message).to eq("Player 1 took K of Hearts with A of Ace.")
    end

    it 'sends the correct message if multiple cards' do
      game = WarGame.new
      card_3 = Card.new("Q","Clover")
      card_array = [card_1, card_2, card_3]
      message = game.winning_message(game.player1.name, card_1, card_array)
      expect(message).to eq("Player 1 took K of Hearts, Q of Clover with A of Ace.")
    end

    it 'sends the correct message if multiple cards (same suits or ranks)' do
      game = WarGame.new
      card_3 = Card.new("Q","Clover")
      card_4 = Card.new("J","Ace")
      card_5 = Card.new("J","Hearts")
      card_array = [card_1, card_2, card_3, card_4, card_5]
      message = game.winning_message(game.player1.name, card_1, card_array)
      expect(message).to eq("Player 1 took K of Hearts, Q of Clover, J of Ace, J of Hearts with A of Ace.")
    end
  end

  describe 'game_over' do
    let(:card_1) { Card.new("A","Ace") }
    let(:card_2) { Card.new("K","Hearts") }
    it 'checks if there\'s a winner and it\'s correct' do
      game = WarGame.new
      game.player1.add_card(card_1)
      game.player2.add_card(card_2)
      expect(game.winner).to be(nil)
      until game.winner do
        game.play_round
      end
      expect(game.winner.name).to eq("Player 1")
    end
  end
end
