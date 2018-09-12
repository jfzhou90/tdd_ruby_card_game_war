require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  it 'is not listening on a port before it is started' do
    expect { MockWarSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients and starts a game if possible' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client('Player 1')
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1, client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...

  it 'welcomes the client, and inform them their cards count' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client('Player 1')
    expect(client1.capture_output).to match(/Waiting for another player to join/)
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client('Player 2')
    @clients.push(client1, client2)
    expect(client2.capture_output).to match(/You are about to go to war/)
    @server.create_game_if_possible
    expect(client1.capture_output && client2.capture_output).to match(/You have 26 cards left/)
  end
end
