class ResidentAdvisorPlaylist

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

	attr_accessor(:url)
	attr_accessor(:tracks)

	require 'open-uri'

	def initialize


	end


	def parse_top50

		@html_document = Nokogiri::HTML(open(@url))

		tracks = []

		@html_document.css("table[id='tracks'] tr").each_with_index do |tr,i|
      artist = track = nil
      tr.css("td").each_with_index do |td,i|


        if i == 2
          artist = ActionView::Base.full_sanitizer.sanitize(td.css("a").first.to_s.gsub('<br>', ' ').gsub('&amp;', '&'))
        elsif i == 3
          title = ActionView::Base.full_sanitizer.sanitize(td.css("a").first.to_s.gsub('<br>', ' ').gsub('&amp;', '&'))
        end

        if !artist.nil? && !title.nil?
            tracks << {artist: artist, title: title}
            Rails.logger.info '------- artist - track : ' + artist + ' - ' + title
        end

        Rails.logger.info '-------zzzz' + i.to_s + '--' + td.to_s
      end
		end

		tracks

	end

	def parse_dj_chart

		@html_document = Nokogiri::HTML(open(@url))

		tracks = []

		@html_document.css("ul[id='tracks'] li").each_with_index do |li,i|
      artist = track = nil
#       li.css("div").each_with_index do |td,i|
# Rails.logger.info '-------------- ' + li.to_s

        # if i == 2
          artist = ActionView::Base.full_sanitizer.sanitize(li.css("div[class='artist']").first.to_s.gsub('<br>', ' ').gsub('&amp;', '&')).strip
        # elsif i == 3
          title = ActionView::Base.full_sanitizer.sanitize(li.css("div[class='track']").first.to_s.gsub('<br>', ' ').gsub('&amp;', '&')).strip
        # end

        if !artist.nil? && !title.nil?
            tracks << {artist: artist, title: title}
            Rails.logger.info '------- artist - track : ' + artist + ' - ' + title
        end

        Rails.logger.info '-------zzzz' + i.to_s + '--' + li.to_s
      # end
		end

		tracks

	end

end
