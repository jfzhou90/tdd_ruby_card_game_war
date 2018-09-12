require('socket')

##
class Client
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

client = Client.new(3336)

loop do
  puts client.capture_output
  print "Enter to see if there's any output or type 'play'."
  text = gets.chomp
  break if text == 'end'

  client.provide_input(text)
end

client.close
