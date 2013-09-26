require 'logging'

module ZmqBroker
  extend self # expose all instance methods as singleton methods

  class << self
    attr_accessor :logger
  end
end

require 'zmq_broker/logger'
require 'zmq_broker/broker'
require 'zmq_broker/supervision_group'

Logging.color_scheme( 'bright',
    :levels => {
      :info  => :green,
      :warn  => :yellow,
      :error => :red,
      :fatal => [:white, :on_red]
    },
    :date => :blue,
    :logger => :cyan,
    :message => :magenta
  )

  Logging.appenders.stdout(
    'stdout',
    :layout => Logging.layouts.pattern(
      :pattern => '[%d] %-5l: %m\n',
      :color_scheme => 'bright'
    )
  )

ZmqBroker.logger = Logging.logger['zmq_broker_logger']
ZmqBroker.logger.add_appenders 'stdout'
ZmqBroker.logger.level = :debug
