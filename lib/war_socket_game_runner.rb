class WarSocketGameRunner
  def initialize(game, clients)
    @game = game
    @clients = clients
  end

  def start
    inform_clients('Are you ready?')
  end

  def capture_output
    message = ''
    @clients.each do |client|
      message = listen_to(client)
      player_command(client, message)
    end
    message
  end

  def inform_clients(text)
    @clients.each { |client| client.send_message(text) }
  end

  def are_players_ready?
    @clients.all?(&:ready?)
  end

  def prepare_players_to_play
    @clients.each { |client| client.set_ready(false) }
  end

  def play_round_if_possible
    return unless are_players_ready? && !@game.winner

    result = @game.play_round
    inform_clients(result)
    prepare_players_to_play
  end

  def finished?
    @game.winner
  end

  private

  def listen_to(client)
    client.capture_output.chomp
  rescue IO::WaitReadable
    ''
  end

  def player_command(client, text)
    client.set_ready(true) if text == 'play'
  end
end
