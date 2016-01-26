# Myfreemp3Seeker Model
class Myfreemp3Seeker
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor(:url)
  attr_accessor(:tracks)

  require 'open-uri'

  def self.search(artist, title)
    track_found = 0

    url = 'http://www.myfreemp3.biz/mp3/'
    url +=  ERB::Util.url_encode(artist.gsub('&', ''))
    url += '%20' + ERB::Util.url_encode(title)
    begin
      html_document = Nokogiri::HTML(open(url))
      html_document
        .css("div[id='track-list']").css("i[class='icon-download']")
        .each_with_index do |i|
        track_found = track_found + 1
      end
    rescue
      track_found = 0
    end
    track_found
  end
end
