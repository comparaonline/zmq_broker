require 'celluloid'

module ZmqBroker
  class SupervisionGroup < Celluloid::SupervisionGroup
    supervise ZmqBroker::Broker, as: :broker
  end
end
