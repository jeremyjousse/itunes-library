# Seek for track referecnces on Beatport
class BeatportReferencesSeeker < ReferencesSeeker
  def search
    @donwloade_headers_hash = {}
    @donwloade_headers_hash['User-Agent'] = 'iTunesLibrary/1.0'

    @search_url = 'https://pro.beatport.com/' \
      'search?_pjax=%23pjax-inner-wrapper&q='

    @searched_artist_array.each do |artist|
      html_document = load_result(artist, @searched_title_string)
      return false if html_document.nil?

      track_div = search_track_div(html_document)
      return false if track_div.nil?

      track_items = search_track_items(track_div)
      return false if track_items.nil?

      track_items.each_with_index do |track_item|
        artists = extract_artists_from_track(track_item)
        label = extract_label_from_track(track_item)
        album_result = load_album_result_from_track(track_item)
        album = extract_album_from_track(album_result, label)
        track = extract_track_from_track(track_item, album, artists)
        update_position_and_duration_from_release(album_result, track)
      end
    end
    true
  end

  private

  def load_result(artist, track)
    begin
      puts '---------' + @search_url + URI::encode(artist + ' ' + track)
      html_document = Nokogiri::HTML(open(@search_url + URI::encode(artist + ' ' + track)))
    rescue
      html_document = nil
    end
    html_document
  end

  def search_track_div(html_document)
    track_div = html_document.css(
      "div[class='bucket tracks standard-interior-tracks']")
    track_div.count == 0 ? nil : track_div
  end

  def search_track_items(track_div)
    track_items = track_div.css(
      "li[class='bucket-item track']")
    track_items.count == 0 ? nil : track_items
  end

  def extract_tracks_from_track_items(track_items)
    track_items.each do |track|
      extract_artist_from_track(track)
    end
    # buk-track-artwork-parent
  end

  def extract_artwork_from_track(track)
  end

  def extract_artists_from_track(track)
    artists = []
    div_artists = track.css(
      "p[class='buk-track-artists']").css('a')
    div_artists.each do |div_artist|
      artists << ReferenceArtist.find_or_create_by(name: div_artist.text)
    end
    artists
  end

  def extract_label_from_track(track)
    label = nil

    label_text = track.css(
      "p[class='buk-track-labels']").css('a').first.text

    label = ReferenceLabel.find_or_create_by(name: label_text) unless label_text.nil?
    label
  end

  def load_album_result_from_track(track)
    album_url = track.css(
      "div[class='buk-track-artwork-parent']")
                .css('a').first['href']

    album_result = load_album_result(
      'https://pro.beatport.com' + album_url) unless album_url.nil?

    album_result
  end

  def extract_album_from_track(album_result, label)
    album_release_date = album_result.css(
      "li[class='interior-release-chart-content-item']")[1].css("span[class='value']")
                         .first.text

    album_year = Date.strptime(album_release_date, '%Y-%m-%d').year

    if album_result.present?
      album_title = album_result.css(
        "div[class='interior-release-chart-content']").css('h1').first.text
    end

    album_url = album_result.css(
      "div[class='buk-track-artwork-parent']").css('a').first['href']

    album_id = File.basename(album_url).to_i

    # album_external_type = 'beatport'

    album_track_number = 0

    if album_result.present?
      album_track_number = album_result.css(
        "div[class='bucket tracks interior-release-tracks']").css('li').count
    end

    album = ReferenceAlbum.find_or_initialize_by(
      external_id: album_id, external_type: 3)

    return album unless album.new_record?

    album.track_number = album_track_number
    album.name = album_title
    album.reference_label_id = label.id
    album.year = album_year
    album.release_date = album_release_date
    album.save

    album_cover_url = album_result.css(
      "div[class='interior-release-chart-artwork-parent']")
      .css('img').first['src']

    picture = Tempfile.new(['picture', '.jpg'])
    picture.binmode
    picture.write(open(album_cover_url).read)
    # picture.write(open(album_cover_url, @donwloade_headers_hash).read)

    picture.flush

    album_covers = album.reference_album_covers.new(cover: picture)
    album_covers.save

    picture.close
    picture.unlink

    album
  end

  def load_album_result(url)
    begin
      html_document = Nokogiri::HTML(open(url))
    rescue
      html_document = nil
    end
    html_document
  end

  def extract_track_from_track(track_html, album, artists)
    name = track_html.css(
      "span[class='buk-track-primary-title']")
      .first.text
    remix =  track_html.css(
      "span[class='buk-track-remixed']")
      .first.text
    name += ' (' + remix + ')' unless remix.nil?

    track_url = track_html.css(
      "div[class='buk-track-meta-parent']")
      .css(
      "p[class='buk-track-title']").css('a').first['href']

    external_id = File.basename(track_url).to_i

    track = ReferenceTrack.find_or_initialize_by(
    external_id: external_id, external_type: 3)

    return track unless track.new_record?
    track.name = name
    track.reference_album_id = album.id
    track.save

    artists.each do |artist|
      track.reference_artists << artist
    end

    track
  end

  def update_position_and_duration_from_release(album_result, track)
    @track = track
    @position = 0
    @duration = nil

    album_result.css(
      "li[class='bucket-item track']")
      .each do |track_html|
      @position = @position + 1
      track_url = track_html.css(
        "p[class='buk-track-title']").css('a').first['href']
      track_id = File.basename(track_url).to_i
      # puts track_id.to_s + '-' + @track.external_id.to_s
      if track_id.to_s == @track.external_id.to_s
        @duration = track_html.css(
          "p[class='buk-track-length']").first.text
        break
      end
      # puts track_url.to_s
    end

    @track.track_position = @position

    @track.duration = minutes_secondes_to_secondes(@duration.to_s)
    @track.save

    true
  end

  def minutes_secondes_to_secondes(duration)
    return nil if duration.nil?
    tbl_duration = duration.split(':')
    if tbl_duration.count == 2
      seconds = (tbl_duration[0].to_i * 60) + tbl_duration[1].to_i
    else
      seconds = tbl_duration[0]
    end
    seconds
  end
end
