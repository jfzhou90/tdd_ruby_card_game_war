require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_game_runner'
require_relative '../lib/war_client'

describe WarSocketGameRunner do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
    @server.start
    @client1 = MockWarSocketClient.new(@server.port_number)
    server_side_1 = @server.accept_new_client('Player 1')
    @client2 = MockWarSocketClient.new(@server.port_number)
    server_side_2 = @server.accept_new_client('Player 2')
    @clients.push(@client1, @client2)
    @game = @server.create_game_if_possible
    war_client1 = WarClient.new(server_side_1, 'Player 1')
    war_client2 = WarClient.new(server_side_2, 'Player 2')
    @game_runner = WarSocketGameRunner.new(@game, [war_client1, war_client2])
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  it 'can receive a message from the clients' do
    @client2.provide_input 'Hi to socket game runner'
    expect(@game_runner.capture_output).to match(/Hi to socket game runner/)
  end

  it 'sends a message to the client' do
    @game_runner.inform_clients('Hi to Player')
    expect(@client1.capture_output).to match(/Hi to Player/)
    expect(@client2.capture_output).to match(/Hi to Player/)
  end

  it 'ask if the players are ready' do
    @game_runner.start
    expect(@client1.capture_output && @client2.capture_output).to match(/Are you ready?/)
  end

  it "shows both players' ready status, true if both players are ready, false if not" do
    @client1.provide_input 'play'
    @game_runner.capture_output
    expect(@game_runner.are_players_ready?).to be(false)
    @client2.provide_input 'play'
    @game_runner.capture_output
    expect(@game_runner.are_players_ready?).to be(true)
  end

  it 'resets ready status to false after a play_round, showing player someone won' do
    @clients.each { |client| client.provide_input('play') }
    @game_runner.capture_output
    expect(@game_runner.are_players_ready?).to eq(true)
    @game_runner.play_round_if_possible
    expect(@game_runner.are_players_ready?).to eq(false)
    expect(@client1.capture_output && @client2.capture_output).to match(/took/)
    expect(@client1.capture_output && @client2.capture_output).to eq('')
  end
end
