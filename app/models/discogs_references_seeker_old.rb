class DiscogsReferencesSeekerOld < ReferencesSeeker

  def search

    @searched_artist_array.each do |artist|


      @search_url = 'http://api.discogs.com/database/search?type=release&&artist=' + URI::encode(artist) + '&track=' + URI::encode(@searched_title_string) + '&btn=Search+Releases&sort=year%2Casc'

      Rails.logger.info '---- Serach url ' + @search_url

      require 'open-uri'
      require 'json'

      json_response = JSON.parse(open(@search_url).read)


      discogs_donwloaded_headers_hash = {}


      #discogs_donwloaded_headers_hash['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
      #discogs_donwloaded_headers_hash['Accept-Encoding'] = 'gzip,deflate,sdch'
      #discogs_donwloaded_headers_hash['Accept-Language'] = 'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2'
      #discogs_donwloaded_headers_hash['Cache-Control'] = 'max-age=0'
      #discogs_donwloaded_headers_hash['Connection'] = 'keep-alive'
      #discogs_donwloaded_headers_hash['Host'] = 's.pixogs.com'
      #discogs_donwloaded_headers_hash['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.94 Safari/537.36'
      discogs_donwloaded_headers_hash['User-Agent'] = 'iTunesLibrary/1.0'



      unless json_response['results'].nil?
        json_response['results'].each do |release|



          result = {album: {}, track: {} }

          release_url = release['resource_url']
          release_id = release['id']



          if ReferenceAlbum.exists?({external_id: release['id'], external_type: ReferenceAlbum.external_types['discogs']})
            reference_album = ReferenceAlbum.find_by({external_id: release_id, external_type:  ReferenceAlbum.external_types['discogs'] })
            reference_album_id = reference_album.id
          else
            release_json = JSON.parse(open(release_url).read)

            Rails.logger.info '---- release_json ' + release_json.inspect

            nb_tracks_in_release = release_json['tracklist'].count
            result[:album][:track_number] = nb_tracks_in_release

            result[:album][:external_type] = 'discogs'
            result[:album][:external_id] = release_id

            result[:album][:name] = release_json['title']
            Rails.logger.info '-+-+ release ' + result[:album][:name]

            label = release_json['labels'][0]['name']
            Rails.logger.info '-+-+ label ' + label


            label_obj = ReferenceLabel.find_or_create_by(name: label)
            result[:album][:reference_label_id] = label_obj.id
            Rails.logger.info '-+-+ -+-+ -+-+ label_id ' + result[:album][:reference_label_id].to_s


            result[:album][:year] = release_json['year']
            Rails.logger.info '-+-+ year ' + result[:album][:year].to_s

            reference_album= ReferenceAlbum.create(result[:album])
            reference_album_id = reference_album.id

            unless release_json['images'].nil?
              release_json['images'].each do |api_picture|
                picture_url = api_picture['uri'].gsub('http://api.discogs.com/images/', 'http://s.pixogs.com/image/').gsub('R-90-', 'R-')
                Rails.logger.info '-+-+-+-+-+-+-+-+-+-+-+-+ picture_url -' + picture_url + '-'

                picture = Tempfile.new(['picture', '.jpg'])
                picture.binmode
                picture.write(open(picture_url, discogs_donwloaded_headers_hash).read)

                picture.flush

                reference_album_covers = reference_album.reference_album_covers.new(cover: picture)

                Rails.logger.info '-+-+-+-+-+-+-+-+-+-+-+-+ reference_album_covers.valid? - ' + reference_album_covers.valid?.to_s
                Rails.logger.info '-+-+-+-+-+-+-+-+-+-+-+-+ reference_album_covers.errors - ' + reference_album_covers.errors.full_messages.to_s

                reference_album_covers.save

                picture.close
                picture.unlink

                Kernel.sleep(1)

                # reference_album_covers = reference_album.reference_album_covers.new(remote_cover_url: picture_url)
                #
                # Rails.logger.info '-+-+-+-+-+-+-+-+-+-+-+-+ reference_album_covers.valid? - ' + reference_album_covers.valid?.to_s
                # Rails.logger.info '-+-+-+-+-+-+-+-+-+-+-+-+ reference_album_covers.errors - ' + reference_album_covers.errors.full_messages.to_s
                #
                # reference_album_covers.save
              end
            end

            track_position = 0

            release_json['tracklist'].each do |track|
              if track['type_'] == 'track'

                track_position = track_position + 1

                result[:track][:track_position] = track_position

                track_exists = ReferenceTrack.where('reference_album_id = ? AND track_position = ?', reference_album_id, result[:track][:track_position]).count

                if track_exists == 0

                  Rails.logger.info '-+-+ Ajout du track en base '


                  result[:track][:name] = track['title']
                  result[:track][:duration] = track['duration']


                  result[:track][:reference_album_id] = reference_album_id

                  reference_track = ReferenceTrack.create(result[:track])


                  artists = {}
                  if !track['artists'].nil?
                    artists = track['artists']
                  else
                    artists = release_json['artists']
                  end

                  artists.each do |artist|
                    artist_obj  = ReferenceArtist.find_or_create_by(name: artist['name'])
                    reference_track.reference_artists << artist_obj
                  end

                end



              end
            end

          end

          Rails.logger.info '------ result ' + result.inspect
        end
      end
    end


  end


end
