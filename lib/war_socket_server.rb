require 'socket'
require_relative 'war_game'
require_relative 'war_socket_game_runner'
require_relative 'war_client'

WELCOME_MESSAGE_1 = 'Welcome. Waiting for another player to join.'.freeze
WELCOME_MESSAGE_2 = 'Welcome. You are about to go to war.'.freeze

class WarSocketServer
  def initialize; end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = 'Random Player')
    client = @server.accept_nonblock
    player = WarClient.new(client, player_name)
    pending_clients.push(player)
    client.puts(pending_clients.count.odd? ? WELCOME_MESSAGE_1 : WELCOME_MESSAGE_2)
    # puts "#{player_name} joined."
    client
  rescue IO::WaitReadable, Errno::EINTR
    # puts 'No client to accept'
  end

  def create_game_if_possible
    return unless pending_clients.count > 1

    game = WarGame.new(pending_clients[0].name, pending_clients[1].name)
    games.push(game)
    games_to_humans[game] = pending_clients.shift(2)
    game.start
    inform_players_of_hand(game)
    game
  end

  def run_game(game)
    game_runner = WarSocketGameRunner.new(game, games_to_humans[game])
    game_runner.start
    Thread.start do
      until game_runner.finished?
        game_runner.capture_output
        game_runner.play_round_if_possible
      end
    end
  end

  def stop
    @server.close if @server
  end

  private

  def inform_players_of_hand(game)
    humans = games_to_humans[game]
    humans[0].send_message("You have #{game.player1.cards_count} cards left")
    humans[1].send_message("You have #{game.player2.cards_count} cards left")
  end

  def pending_clients
    @pending_clients ||= []
  end

  def games_to_humans
    @games_to_humans ||= {}
  end
end
