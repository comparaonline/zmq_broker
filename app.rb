#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

$:<< './lib'

require 'celluloid/zmq'
require 'zmq_broker'

Celluloid::ZMQ.init

trap :INT do
  exit
end

ZmqBroker::SupervisionGroup.run
