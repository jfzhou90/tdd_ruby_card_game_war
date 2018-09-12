class WarClient
  attr_reader :name

  def initialize(client, name)
    @client = client
    @ready = false
    @name = name
  end

  def ready?
    @ready
  end

  def set_ready(boolean)
    @ready = boolean
  end

  def send_message(text)
    @client.puts(text)
  end

  def capture_output
    sleep(0.1)
    @output = @client.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ''
  end
end
