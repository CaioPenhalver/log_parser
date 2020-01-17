module LogParser
  class Reader
    def initialize(file)
      raise LogParser::Errors::FileNotFound unless File.exist?(file)

      @file = file
    end

    def with(strategy)
      @strategy = strategy
      self
    end

    def read
      lines = []
      File.foreach(file) do |line|
        lines << parse(line)
      end
      strategy.new lines
    end

    private
    attr_reader :strategy, :file

    def parse(line)
      strategy::LINE_MATCHER
        .each_with_object({}) do |(attr, pattern), hash|
         hash[attr] = line[pattern]
      end
    end
  end
end
