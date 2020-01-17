require "log_parser/version"
require "log_parser/errors/file_not_found"
require "log_parser/strategies/webserver_log"
require "log_parser/strategies"
require "log_parser/reader"

module LogParser
  def self.metrics(file, strategy = nil)
    strategy = strategy || :webserver_log
    LogParser::Reader.new(file)
      .with(LogParser::STRATEGIES[strategy])
      .read
      .print_metrics
  end
end
