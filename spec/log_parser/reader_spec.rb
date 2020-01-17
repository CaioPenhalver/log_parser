# frozen_string_literal: true

RSpec.describe LogParser::Reader do
  after { delete_file }

  describe '.new' do
    subject { described_class.new(file) }

    context 'when the file does not exist' do
      let(:file) { 'notfound.log' }

      it 'should raise an error' do
        expect { subject }.to raise_error LogParser::Errors::FileNotFound unless File
      end
    end

    context 'when the file exists' do
      let(:file) { 'spec/fixtures/webserver.log' }

      it 'should return a reader' do
        create_log_file

        expect(subject).to be_a LogParser::Reader
      end
    end
  end

  describe '#read' do
    class MockStrategy
      attr_reader :lines
      LINE_MATCHER = { path: /^\S*/, ip: /\S*$/ }.freeze
      def initialize(lines)
        @lines = lines
      end
    end

    let(:file) { 'spec/fixtures/webserver.log' }
    subject { described_class.new(file).with(MockStrategy).read }

    it 'should return the strategy used' do
      create_log_file

      expect(subject).to be_a MockStrategy
    end

    context 'when it is the right pattern' do
      let(:logs) do
        [
          { path: '/help_page/1', ip: '100.300.005.008' },
          { path: '/about', ip: '128.300.005.008' }
        ]
      end

      it 'should parse the logs' do
        create_log_file(logs)

        expect(subject.lines).to eq logs
      end
    end

    context 'when the pattern does not match' do
      let(:logs) do
        [{ path: nil, ip: '100.300.005.008' }]
      end
      let(:expected_logs) do
        [{ path: '', ip: '100.300.005.008' }]
      end

      it 'should parse the logs' do
        create_log_file(logs)

        expect(subject.lines).to eq expected_logs
      end
    end
  end
end
