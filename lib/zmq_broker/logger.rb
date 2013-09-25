
module ZmqBroker
  module Logger
    module_function

    # Send a debug message
    def debug(string)
      ZmqBroker.logger.debug(string) if ZmqBroker.logger
    end

    # Send a info message
    def info(string)
      ZmqBroker.logger.info(string) if ZmqBroker.logger
    end

    # Send a warning message
    def warn(string)
      ZmqBroker.logger.warn(string) if ZmqBroker.logger
    end

    # Send an error message
    def error(string)
      ZmqBroker.logger.error(string) if ZmqBroker.logger
    end
  end
end
