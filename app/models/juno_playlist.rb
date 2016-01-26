class JunoPlaylist

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

	attr_accessor(:url)
	attr_accessor(:tracks)

	require 'open-uri'

	def initialize


	end


	def parse_chart

		#@url = 'http://www.junodownload.com/charts/mixcloud/djdanmusic/stereo-damage-episode-53-mark-farina-guest-mix/108587193?timein=1449&utm_source=Mixcloud&utm_medium=html5&utm_campaign=mixcloud&ref=mixcloud&a_cid=44db7396'

		@html_document = Nokogiri::HTML(open(@url))

		tracks = []



		@html_document.css("div[class='productlist_widget_container']").each_with_index do |div,i|
			if !div.attributes['id'].nil?

					artist = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_artists']").css("span[class='jq_highlight pwttext']").css("a").text

					title = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_title']").css("span[class='jq_highlight pwttext']").css("a").text

				#

				if !artist.nil? && !title.nil?

					tracks << {artist: artist, title: title}

					#puts artist + ' + ' + title + '-----------'
				end
				#
				# 		span.jq_highlight pwttext
				# 			a

				# puts div.attributes.inspect

  			end
		end

		tracks

	end


end
