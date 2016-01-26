# Seek for references on external websites
class JunoReferencesSeeker < ReferencesSeeker
  def search

    @searched_artist_array.each do |artist|

    @search_url = 'http://www.junodownload.com/search/?solrorder=relevancy&q%5Bartist%5D%5B%5D=' + URI::encode(artist) + '&q%5Btitle%5D%5B%5D=' + URI::encode(@searched_title_string) + '&list_view=tracks'

    @html_document = Nokogiri::HTML(open(@search_url))

    @html_document.css("div[class='productlist_widget_container']").each_with_index do |div,i|
      if !div.attributes['id'].nil?

        result = {album: {}, track: {} }

        release_url = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_from_release']").css("span[class='jq_highlight pwttext']").css("a")[0]["href"]
        release_id = release_url.split('/').last.split('-').first

        Rails.logger.info '-+-+ release_id ' + release_id

        if ReferenceAlbum.exists?({external_id: release_id, external_type: ReferenceAlbum.external_types['juno']})
          Rails.logger.info '-> -> -> -> -+-+ EXIST EN BASE '
          reference_album = ReferenceAlbum.where({external_id: release_id, external_type:  ReferenceAlbum.external_types['juno'] }).first
          reference_album_id = reference_album.id
        else
          nb_tracks_in_release = 0
          release_html = Nokogiri::HTML(open("http://www.junodownload.com/"+release_url))
          release_html.css("div[itemprop='tracks']").each do |track|
            nb_tracks_in_release = nb_tracks_in_release +1
          end

          result[:album][:track_number] = nb_tracks_in_release
          Rails.logger.info '-+-+ nb_tracks_in_release ' + nb_tracks_in_release.to_s

          result[:album][:external_type] = 'juno'
          result[:album][:external_id] = release_id

          result[:album][:name] = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_from_release']").css("span[class='jq_highlight pwttext']").css("a").text
          Rails.logger.info '-+-+ release ' + result[:album][:name]

          label = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_label']").css("span[class='jq_highlight pwttext']").css("a").text
          Rails.logger.info '-+-+ label ' + label

          label_obj = ReferenceLabel.find_or_create_by(name: label)
          result[:album][:reference_label_id] = label_obj.id
          Rails.logger.info '-+-+ -+-+ -+-+ label_id ' + result[:album][:reference_label_id].to_s


          result[:album][:year] = div.css("div[class='productlist_widget_product_preview_buy_tracks']").css("span").first.text.split(' ').last
          if result[:album][:year].nil?

          elsif result[:album][:year].length == 2
            if result[:album][:year].to_i > Time.now.strftime('%y').to_i
              result[:album][:year] = '19' + result[:album][:year]
            else
              result[:album][:year] = '20' + result[:album][:year]
            end
          end
          # TODO Récuperer que l'année
          Rails.logger.info '-+-+ year ' + result[:album][:year].to_s

          release_date = div.css("div[class='productlist_widget_product_preview_buy_tracks']").css("span").first.text.to_s
          if release_date != ''
            result[:album][:release_date] = Date.strptime(release_date, "%d %b %y").strftime("%Y-%m-%d")
          end
          Rails.logger.info '-+-+ release_date ' + result[:album][:release_date].to_s


          # TODO AJOUTER track_number
          reference_album= ReferenceAlbum.create(result[:album])
          reference_album_id = reference_album.id


          picture = div.css("div[class='productlist_widget_product_image productimage']").css("img")[0]["src"]
          picture = picture.gsub('/75/', '/full/').gsub('-TN.', '-BIG.')

          Rails.logger.info '-+-+ picture ' + picture

          if picture.length > 5
            params_picture = {remote_cover_url: picture}
            reference_album.reference_album_covers.create(params_picture)
          end
        end



        title_url = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_title']").css("span[class='jq_highlight pwttext']").css("a")[0]["href"]
        title_track_nb = title_url.split('?').last.split('=').last
        Rails.logger.info '-+-+ title_track_nb ' + title_track_nb


        track_exists = ReferenceTrack.where('reference_album_id = ? AND track_position = ?', reference_album_id, title_track_nb).count

          if track_exists == 0

          Rails.logger.info '-+-+ Ajout du track en base '



          title = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_title']").css("span[class='jq_highlight pwttext']").css("a").text
          Rails.logger.info '-+-+ title ' + title
          result[:track][:name] = title



          result[:track][:track_position] = title_track_nb

          result[:track][:reference_album_id] = reference_album_id

          reference_track = ReferenceTrack.create(result[:track])


          artists = div.css("div[class='productlist_widget_product_info_tracks']").css("div[class='productlist_widget_product_artists']").css("span[class='jq_highlight pwttext']").css("a").map {|element| element.text}
          Rails.logger.info '-+-+ artist ' + artists.to_s
          result[:track][:reference_artist_id] = Array.new()
          Array.new(artists).each do |artist|
              artist_obj  = ReferenceArtist.find_or_create_by(name: artist)

              reference_track.reference_artists << artist_obj
          end

          Rails.logger.info  '---- >- -> Artists array : ' + result[:track][:reference_artist_id].inspect


        end


        Rails.logger.info '-+-+  '


        if !artist.nil? && !title.nil?

          #tracks << {artist: artist, title: title}

          #puts artist + ' + ' + title + '-----------'
        end

      end
    end

#Rails.logger.info '---- Result page ' + @html_document

    end
    #
  end
end
