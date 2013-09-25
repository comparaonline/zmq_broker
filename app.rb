$:<< './lib'

require 'celluloid/zmq'
require 'zmq_broker'

Celluloid::ZMQ.init

trap :INT do
  exit
end

ZmqBroker::Logger.info 'starting ZeroMQ Broker'
ZmqBroker::SupervisionGroup.run
