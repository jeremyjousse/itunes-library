# require 'rails_helper'
#
# RSpec.describe BeatportReferencesSeeker, type: :model do
#   context 'with bad http connexion' do
#     before(:each) do
#       stub_request(:get, 'https://pro.beatport.com/search?_pjax=%23pjax-inner-wrapper&q=Jeff%20Mills%20The%20Bells').
#          with(headers: { 'Accept': '*/*',
#            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
#            'User-Agent'=>'Ruby' }).
#          to_return(status: [500, "Internal Server Error"])
#     end
#     it 'should not raise an error' do
#       beatport_references_seeker = BeatportReferencesSeeker.new('Jeff Mills', 'The Bells')
#       expect { beatport_references_seeker.search }.not_to raise_error
#     end
#     it 'shoult return a nil value' do
#       beatport_references_seeker = BeatportReferencesSeeker.new('Jeff Mills', 'The Bells')
#       expect(beatport_references_seeker.search).to be false
#     end
#   end
#
#   context 'with no result' do
#     before(:each) do
#       no_result_file = File.new(Rails.root + "spec/fixtures/beatport/no_result.html")
#
#       stub_request(:get, 'https://pro.beatport.com/search?_pjax=%23pjax-inner-wrapper&q=Jeff%20Mills%20The%20Bells').
#          with(headers: { 'Accept': '*/*',
#            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
#            'User-Agent'=>'Ruby' }).
#          to_return(:body =>no_result_file, status: 200)
#     end
#     it 'should return false if not track div is found' do
#       beatport_references_seeker = BeatportReferencesSeeker.new('Jeff Mills', 'The Bells')
#       expect(beatport_references_seeker.search).to be false
#     end
#   end
#
#   context 'with result' do
#     before(:each) do
#       result_file = File.new(Rails.root + "spec/fixtures/beatport/result.html")
#       stub_request(:get, 'https://pro.beatport.com/search?_pjax=%23pjax-inner-wrapper&q=Jeff%20Mills%20The%20Bells').
#          with(headers: { 'Accept': '*/*',
#            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
#            'User-Agent'=>'Ruby' }).
#          to_return(:body =>result_file, status: 200)
#
#       release_result_file = File.new(Rails.root + "spec/fixtures/beatport/release.html")
#       stub_request(:get, %r{\Ahttps://pro.beatport.com/release/(.*)\z}).
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#          to_return(:body =>release_result_file, status: 200)
#
#       release_cover_file = File.new(Rails.root + "spec/fixtures/beatport/cover.jpg")
#       stub_request(:get, %r{\Ahttps://geo-media.beatport.com/image/(.*).jpg\z}).
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#          to_return(:body =>release_cover_file, status: 200)
#     end
#     it 'should not return nil if not track div is found' do
#       beatport_references_seeker = BeatportReferencesSeeker.new('Jeff Mills', 'The Bells')
#       expect(beatport_references_seeker.search).not_to be nil
#     end
#   end
#
#   context 'with result having multiple artists' do
#     before(:each) do
#       result_with_multiple_artists_file = File.new(Rails.root + "spec/fixtures/beatport/result_with_multiple_artists.html")
#
#       stub_request(:get, 'https://pro.beatport.com/search?_pjax=%23pjax-inner-wrapper&q=Nickodemus%20Mi%20Swing%20Es%20Tropical').
#          with(headers: { 'Accept': '*/*',
#            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
#            'User-Agent'=>'Ruby' }).
#          to_return(:body =>result_with_multiple_artists_file, status: 200)
#
#       release_result_file = File.new(Rails.root + "spec/fixtures/beatport/release.html")
#       stub_request(:get, %r{\Ahttps://pro.beatport.com/release/(.*)\z}).
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#          to_return(:body =>release_result_file, status: 200)
#
#       release_cover_file = File.new(Rails.root + "spec/fixtures/beatport/cover.jpg")
#       stub_request(:get, %r{\Ahttps://geo-media.beatport.com/image/(.*).jpg\z}).
#          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#          to_return(:body =>release_cover_file, status: 200)
#     end
#     it 'should not return nil if not track div is found' do
#       beatport_references_seeker = BeatportReferencesSeeker.new('Nickodemus', 'Mi Swing Es Tropical')
#       expect(beatport_references_seeker.search).not_to be nil
#     end
#   end
#
# end
