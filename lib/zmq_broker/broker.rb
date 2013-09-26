
require 'celluloid/zmq'
require 'json'

module ZmqBroker
  class Broker
    include Celluloid::ZMQ

    finalizer :close_sockets

    def initialize(pull_addr: 'tcp://0.0.0.0:5555', pub_addr: 'tcp://0.0.0.0:5556')
      ZmqBroker::Logger.info 'starting ZeroMQ Broker'

      @sub_socket = SubSocket.new
      @pub_socket = PubSocket.new

      begin
        @sub_socket.bind pull_addr
        @sub_socket.subscribe '' # subscribe to all messages
        Logger.info "bound zmq subscribe socket on #{pull_addr}"

        @pub_socket.bind pub_addr
        Logger.info "bound zmq publish socket on #{pub_addr}"

        async.run
      rescue IOError
        Logger.error "could not bind sockets"
        close_sockets
        raise
      end
    end

    def close_sockets
      @sub_socket.close
      @pub_socket.close
    end

    def run
      loop do
        async.handle_message @sub_socket.read
      end
    end

    def handle_message(message)
      Logger.info "received new message"
      params = ::JSON.parse message

      body = params['body']
      channel = params['channel']

      Logger.info "publishing message #{body} on channel \##{channel}"
      @pub_socket.write channel, ::JSON.generate(body)
    rescue ::JSON::ParserError
      Logger.error "couldn't parse message: #{message}"
    rescue ::JSON::GeneratorError
      Logger.error "couldn't encode message as json: #{body}"
    end
  end
end
