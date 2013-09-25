
require 'celluloid/zmq'
require 'json'

module ZmqBroker
  class Broker
    include Celluloid::ZMQ

    finalizer :close_sockets

    def initialize(name: 'broker', pull_addr: 'tcp://0.0.0.0:5555', pub_addr: 'tcp://0.0.0.0:5556')
      @name = name
      @pull_socket = PullSocket.new
      @pub_socket = PubSocket.new

      begin
        @pull_socket.bind pull_addr
        Logger.info "bound zmq pull socket on #{pull_addr}"

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
      @pull_socket.close
      @pub_socket.close
    end

    def run
      loop { async.handle_message @pull_socket.read }
    end

    def handle_message(message)
      Logger.info "#{@name}: pulled message #{message}"
      params = ::JSON.parse message

      body = params['body']
      channel = params['channel']

      Logger.info "#{@name}: publishing message #{body} on channel \##{channel}"
      @pub_socket.write channel, body
    rescue ::JSON::ParserError
      Logger.error "#{@name}: couldn't parse message: #{message}"
    end
  end
end
