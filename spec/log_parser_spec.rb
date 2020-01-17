# frozen_string_literal: true

RSpec.describe LogParser do
  it 'has a version number' do
    expect(LogParser::VERSION).not_to be nil
  end

  describe '.metrics' do
    let(:file) { 'spec/fixtures/webserver.log' }
    let(:logs) do
      [{ path: '/help_page', ip: '100.300.005.008' }]
    end
    after { delete_file }

    it 'should call methods with right params' do
      create_log_file(logs)
      expect do
        described_class.metrics(file)
      end.to output(
        <<~STR
          List of webpages with most page views
          /help_page: 1
          -------------------------------------------
          List of webpages with most unique page views
          /help_page: 1
        STR
      ).to_stdout
    end
  end
end
