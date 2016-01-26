require 'rails_helper'

RSpec.describe DiscogsReferencesSeeker, type: :model do
  # context 'with bad http connexion' do
  #   before(:each) do
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/.+\z})
  #       .with(headers: { 'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(status: [500, 'Internal Server Error'])
  #   end
  #   it 'should not raise an error' do
  #     discogs_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
  #     expect { discogs_references_seeker.search }.not_to raise_error
  #   end
  #   it 'shoult return a nil value' do
  #     discogs_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
  #     expect(discogs_references_seeker.search).to be false
  #   end
  # end
  #
  # context 'with no result' do
  #   before(:each) do
  #     no_result_file = File.new(Rails.root +
  #     'spec/fixtures/discogs/no_result.html')
  #
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/.+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: no_result_file, status: 200)
  #   end
  #   it 'should return false if not track div is found' do
  #     beatport_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
  #     expect(beatport_references_seeker.search).to be false
  #   end
  # end
  #
  # context 'with result' do
  #   before(:each) do
  #     result_file = File.new(Rails.root + 'spec/fixtures/discogs/result.html')
  #
  #     release_result_file = File.new(Rails.root +
  #       'spec/fixtures/discogs/release.html')
  #
  #     release_cover_file = File.new(Rails.root +
  #       'spec/fixtures/discogs/cover.jpg')
  #
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/.+\/release\/[0-9]+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: release_result_file, status: 200)
  #
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/search\/.+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: result_file, status: 200)
  #
  #     stub_request(:any, %r{\Ahttp:\/\/cdn\.discogs\.com\/.+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: release_cover_file, status: 200)
  #     #
  #     # stub_request(:get, %r{\Ahttps://geo-media.beatport.com/image/(.*).jpg\z}).
  #     #    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
  #     #    to_return(:body =>release_cover_file, status: 200)
  #   end
  #
  #   it 'should not return nil if not track div is found' do
  #     discogs_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
  #     expect(discogs_references_seeker.search).not_to be nil
  #   end
  # end
  #
  # context 'with compilation' do
  #   before(:each) do
  #     result_file = File.new(Rails.root + 'spec/fixtures/discogs/result.html')
  #
  #     release_result_file = File.new(Rails.root +
  #       'spec/fixtures/discogs/compilation.html')
  #
  #     release_cover_file = File.new(Rails.root +
  #       'spec/fixtures/discogs/cover.jpg')
  #
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/.+\/release\/[0-9]+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: release_result_file, status: 200)
  #
  #     stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/search\/.+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: result_file, status: 200)
  #
  #     stub_request(:any, %r{\Ahttp:\/\/cdn\.discogs\.com\/.+\z})
  #       .with(headers: {
  #               'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
  #       .to_return(body: release_cover_file, status: 200)
  #     #
  #     # stub_request(:get, %r{\Ahttps://geo-media.beatport.com/image/(.*).jpg\z}).
  #     #    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
  #     #    to_return(:body =>release_cover_file, status: 200)
  #   end
  #
  #   it 'should not return nil if not track div is found' do
  #     discogs_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
  #     expect(discogs_references_seeker.search).not_to be nil
  #   end
  # end

  context 'with compilation and values' do
    before(:each) do
      result_file = File.new(Rails.root + 'spec/fixtures/discogs/mike_dunn-god_made_me_funky.html')
      # result_file = File.new(Rails.root + 'spec/fixtures/discogs/one_result.html')

      stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/search\/.+\z})
        .with(headers: {
                'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
        .to_return(body: result_file, status: 200)

      @release_result_file = File.new(Rails.root +
        'spec/fixtures/discogs/compilation.html')

      stub_request(:any, %r{\Ahttp:\/\/www\.discogs\.com\/.+\/release\/[0-9]+\z})
        .with(headers: {
                'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
        .to_return(body: @release_result_file, status: 200)

      release_cover_file = File.new(Rails.root +
        'spec/fixtures/discogs/cover.jpg')

      stub_request(:any, %r{\Ahttp:\/\/cdn\.discogs\.com\/.+\z})
        .with(headers: {
                'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding'=>'deflate, sdch', 'Accept-Language'=>'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36' })
        .to_return(body: release_cover_file, status: 200)
    end
    it 'should extract the date' do
      # Rails.logger.info '---- Nokogiri::HTML(@release_result_file)) : ' + Nokogiri::HTML(@release_result_file).inspect
      discogs_references_seeker = DiscogsReferencesSeeker.new('Jeff Mills', 'The Bells')
      label = discogs_references_seeker.send(:extract_label_from_track, Nokogiri::HTML(open(@release_result_file)))
      discogs_references_seeker.send(:extract_album_from_release, Nokogiri::HTML(open(@release_result_file)), 1, '', 'test', label)
    end
  end
end
