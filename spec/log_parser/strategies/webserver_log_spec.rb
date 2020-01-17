RSpec.describe LogParser::Strategies::WebserverLog do
  describe '#most_page_views' do
    let(:about_page) do
      [{ path: '/about', ip: '128.300.005.008' },
       { path: '/about', ip: '128.300.005.008' },
       { path: '/about', ip: '128.300.005.008' }]
    end
    let(:help_page) do
      [{ path: '/help', ip: '128.300.005.008' },
       { path: '/help', ip: '128.300.005.008' } ]
    end
    let(:info_page) do
      [{ path: '/info', ip: '128.300.005.008' }]
    end
    let(:logs) { about_page + help_page + info_page }
    
    subject { described_class.new.most_page_views(logs) }

    it 'should return on the right order' do
      expect(subject.first[:number]).to eq about_page.count
      expect(subject.last[:number]).to eq info_page.count
    end
  end

  describe '#unique_most_page_views' do
    let(:about_page) do
       [{ path: '/about', ip: '128.311.111.111' },
      { path: '/about', ip: '128.300.005.008' },
       { path: '/about', ip: '128.300.005.008' }]
    end
    let(:help_page) do
      [{ path: '/help', ip: '128.300.005.008' },
       { path: '/help', ip: '192.897.562.108' } ]
    end
    let(:info_page) do
      [{ path: '/info', ip: '128.300.005.008' }]
    end
    let(:logs) { about_page + help_page + info_page }
    
    subject { described_class.new.unique_most_page_views(logs) }

    it 'should return on the right order' do
      expect(subject.first[:number]).to eq help_page.count
      expect(subject.last[:number]).to eq info_page.count
    end

  end
end
