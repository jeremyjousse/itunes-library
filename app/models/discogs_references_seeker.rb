# Search references on Discogs
class DiscogsReferencesSeeker < ReferencesSeeker
  def search
    @searched_artist_array.each do |artist|
      @search_url = 'http://www.discogs.com/search/?type=all' \
                    '&artist=' + URI.encode(artist) +
                    '&track=' + URI.encode(@searched_title_string) +
                    '&advanced=1&layout=med&type=release&sort=year%2Casc'

Rails.logger.info '----- DiscogsReferencesSeeker search url : ' + @search_url

      html_document = load_result
      return false if html_document.nil?

      track_div = search_track_div(html_document)
      return false if track_div.nil?

      track_items = search_track_items(track_div)
      return false if track_items.nil?

      track_items.each_with_index do |track_item|
        release = get_release_document(track_item)
        next if release.nil?

        artists = extract_artists_from_relase(release)
        label = extract_label_from_track(release)
        album_title = extract_album_title_from_listing(track_item)
        album_url = extract_album_url_from_listing(track_item)
        album_id = File.basename(album_url).to_i

        album = extract_album_from_release(release, album_id, album_url, album_title, label)

        tracks = extract_tracks_from_release(release, album, artists)
      end
    end
  end

  private

  def load_page(url)
    begin
      html_document = Nokogiri::HTML(open(url, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36', 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding' => 'deflate, sdch', 'Accept-Language' => 'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2'))
    rescue
      html_document = nil
    end
    html_document
  end

  def load_result
    load_page(@search_url)
  end

  def search_track_div(html_document)
    track_div = html_document.css(
      "div[id='search_results']")
    track_div.count == 0 ? nil : track_div
  end

  def search_track_items(tracks_div)
    track_items = tracks_div.css(
      "div[data-object-type='release']")
    track_items.count == 0 ? nil : track_items
  end

  def get_release_document(track_item)
    release_relative = extract_album_url_from_listing(track_item)
    return nil if release_relative.nil?
    Rails.logger.info '---- ---- ---- ---- ---- '
    Rails.logger.info '---- ' + 'http://www.discogs.com' + release_relative
    load_page('http://www.discogs.com' + release_relative)
  end

  def extract_album_url_from_listing(track_item)
    track_item.css("a[class='search_result_title ']").first['href']
  end

  def extract_album_title_from_listing(track_item)
    track_item.css("a[class='search_result_title ']").children.first.text
  end

  def extract_artists_from_relase(release)
    artists = []
    artists_extracted = []
    artists_extracted << release.css("span[itemprop='name']").first['title']
    return nil if artists_extracted.count == 0
    artists_extracted.each do |artist_extracted|
      artists << ReferenceArtist.find_or_create_by(name: artist_extracted)
    end
    artists
  end

  def extract_label_from_track(release)
    label = nil
    label_text = release.css("div[class='profile']")
                 .css("div[class='content']")
                 .css('a').first.text
    label = ReferenceLabel.find_or_create_by(name: label_text) unless label_text.nil?
    label
  end

  def extract_album_from_release(release, album_id, album_url, album_title, label)
    album_release_date_str = nil

    album_release_date_html = release.css("div[class='profile']").css("div")
    search_date_in_next = false

    album_release_date_html.each do |date_html|
      if search_date_in_next == true
        if date_html.css('a').first.present?
          album_release_date_str = date_html.css('a').first.text.strip!
        end
        break
      end
      if date_html.text.present? && ['Year:', 'Released:', 'Date:'].include?(date_html.text)
        search_date_in_next = true
      end
    end

    Rails.logger.info '------------------------ album_release_date_str- '
    Rails.logger.info '-album_release_date_str- ' + album_release_date_str.to_s

    if album_release_date_str.nil?
      album_year = nil
      album_release_date = nil
    elsif album_release_date_str.match(%r{\A[0-9]{4}\z})
      album_year = Date.strptime(album_release_date_str, '%Y').year
      album_release_date = Date.strptime(album_release_date_str, '%Y')
    else
      album_year = Date.parse(album_release_date_str).year
      album_release_date = Date.parse(album_release_date_str)
    end

    album_external_type = 'discogs'

    album_track_number = 0

    if release.present?
      album_track_number = release.css("tr[itemtype='http://schema.org/MusicRecording']").count
    end

    album = ReferenceAlbum.find_or_initialize_by(
      external_id: album_id, external_type: 2)

    return album unless album.new_record?

    album.track_number = album_track_number
    album.name = album_title
    album.reference_label_id = label.id
    album.year = album_year
    album.release_date = album_release_date
    album.save

    if release.css("div[class='image_gallery image_gallery_large']").present? &&
       release.css("div[class='image_gallery image_gallery_large']")[0]['data-images'].present?
      album_cover_url = JSON.parse(release.css("div[class='image_gallery image_gallery_large']")[0]['data-images'])[0]['full']
      picture = Tempfile.new(['picture', '.jpg'])
      picture.binmode
      picture.write(open(album_cover_url, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36', 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'Accept-Encoding' => 'deflate, sdch', 'Accept-Language' => 'fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de;q=0.2,it;q=0.2,pt;q=0.2').read)

      picture.flush

      album_covers = album.reference_album_covers.new(cover: picture)
      album_covers.save

      picture.close
      picture.unlink
    end

    album
  end

  def extract_tracks_from_release(release, album, artists)
    track_position = 0

    html_tracks = release.css("table[class='playlist']").
             css("tr[itemprop='track']")
    html_tracks.each do |html_track|
      track_position += 1

      if html_track.css("td[class='tracklist_track_artists']").present? && html_track.css("td[class='track tracklist_track_title mini_playlist_track_has_artist']").first.present?
        track = ReferenceTrack.new
        track.name = html_track.css("td[class='track tracklist_track_title mini_playlist_track_has_artist']").first.text[0..254]
        track.track_position = track_position
        track.reference_album_id = album.id
        track.save

        track_artists = html_track.css("td[class='tracklist_track_artists']").css('a')
        track_artists.each do |track_artist|
          track.reference_artists << ReferenceArtist.find_or_create_by(name: track_artist.text)
        end
      else
        track = ReferenceTrack.new
        track.name = html_track.css("span[class='tracklist_track_title']").first.text[0..254]
        track.track_position = track_position
        track.reference_album_id = album.id
        track.save

        artists.each do |artist|
          track.reference_artists << artist
        end
      end
    end
  end
end
