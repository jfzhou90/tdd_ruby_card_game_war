require 'socket'
require 'pry'
require './lib/war_player'

class WarSocketServer
  attr_reader :players, :games
  def initialize
    @players = []
    @games = []
  end

  def port_number
    3336
  end

  # def games
  #   []
  # end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    # associate player and client
    players.push(Player.new(player_name, client))
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if players.size == 2
      games.push("maybe an instance of a game here??")
    end
  end

  def stop
    @server.close if @server
  end
end
