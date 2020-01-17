# frozen_string_literal: true

# List of strategies to handle different types of logs files
module LogParser
  STRATEGIES = {
    webserver_log: LogParser::Strategies::WebserverLog
  }.freeze
end
