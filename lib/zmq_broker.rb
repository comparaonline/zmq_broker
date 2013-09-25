require 'logger'

module ZmqBroker
  extend self # expose all instance methods as singleton methods

  class << self
    attr_accessor :logger
  end
end

require 'zmq_broker/logger'
require 'zmq_broker/broker'
require 'zmq_broker/supervision_group'

ZmqBroker.logger = Logger.new(STDERR)
