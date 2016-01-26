# All the Itunes Tracks
class ItunesTrack < ActiveRecord::Base
  enum tag_version: { unknown: 0, 'v2.4' => 1, v1: 2, v2: 3, bad: 4 }
  enum searched: { 'Not searched' => 0, 'Searched' => 1, 'Found' => 2, 'Not exaxt' => 3 }
  enum state: { 'New' => 0, 'Updated' => 1, 'Completed' => 2 }

  scope :no_tag_version, -> { where(tag_version: 0).order(:id).limit(1000) }
  scope :no_rating, -> { where(rating: nil).limit(10_000) }
  scope :no_metaphone, -> { where(artist_metaphone: nil, name_metaphone: nil).limit(10_000) }
  scope :not_searched, -> { where(searched: 'Not searched').order(created_at: :desc).limit(100_000) }

  mount_uploader :cover, CoverUploader

  before_save :update_state
  before_save :update_name_and_artist_metaphone

  scope :not_searched, -> { where(searched: 0) }
  scope :not_completed, -> { where.not(state: 2) }
  scope :easy_updatable, -> { where(state: 1, searched: 2) }

  def update_name_and_artist_metaphone
    self.artist_metaphone = Text::Metaphone.metaphone(artist)
    self.name_metaphone = Text::Metaphone.metaphone(name)
  end

  def translated_file_location_to_file_name
    URI.unescape(location.gsub('file://localhost', ''))
  end

  def self.translate_path_of_persistent_id_file_location(path_of_persistent_id)
    'file://localhost' + path_of_persistent_id.gsub(' ', '%20').strip
  end

  def get_rating_from_itunes
    @rating = ApplescriptWraper.get_rating_of_persistent_id(persistent_id)
    self.rating = @rating
    save

    @rating
  end

  def set_rating(rating)
    ApplescriptWraper.set_rating_of_persistent_id(persistent_id, rating)
    self.rating = rating
    save
  end

  def self.update_missing_rating
    itunes_tracks = ItunesTrack.where(rating: 0).order(id: :desc)
    itunes_tracks.each do |itunes_track|
      itunes_track.rating = ApplescriptWraper
        .get_rating_of_persistent_id(itunes_track.persistent_id)
      itunes_track.save
    end
  end

  def self.get_now_playing
    ApplescriptWraper.get_now_playing
  end

  def self.update_missing_informations
    missing_informations_itunes_tracks = ItunesTrack.no_tag_version
    missing_informations_itunes_tracks.each do |itunes_track|
      mp3 = Mp3File.new(itunes_track.translated_file_location_to_file_name)
      if !mp3.id3v2_tag_version.nil?
        if mp3.id3v2_tag_version != 4
          itunes_track.tag_version = 'v2'
        else
          itunes_track.tag_version = 'v2.4'
        end
      else
        itunes_track.tag_version = :bad
      end
      itunes_track.save
    end

    missing_informations_itunes_tracks = ItunesTrack.no_metaphone
    missing_informations_itunes_tracks.each do |itunes_track|
      itunes_track.save
    end

    missing_informations_itunes_tracks = ItunesTrack.no_rating
    missing_informations_itunes_tracks.each do |itunes_track|
      itunes_track.rating = ApplescriptWraper.get_rating_of_persistent_id(itunes_track.persistent_id)
      itunes_track.save
    end
  end

  def self.update_all_ratings
    ItunesTrack.find_each do |track|
      track.get_rating_from_itunes
    end

    nil
  end

  def self.fix_tag_version
    bad_tag_tracks = ItunesTrack.where('tag_version != 1').limit(1000)

    bad_tag_tracks.each do |bad_tag_track|
      mp3 = Mp3File.new(bad_tag_track.translated_file_location_to_file_name)

      Rails.logger.info '----- id3tags ' + mp3.id3tags.inspect

      mp3.set_tags(mp3.id3tags)

      if mp3.id3v2_tag_version == 4
        bad_tag_track.tag_version = 'v2.4'
        bad_tag_track.save
      end
    end
  end

  def update_tags_and_path
      mp3 = Mp3File.new(self.translated_file_location_to_file_name)

      if !self.track_number.nil?
        track_position = self.track_number.to_s
        if !self.track_count.nil?
          track_position = track_position + '/' + self.track_count.to_s
        end
      else
        track_position = ''
      end

      mp3.set_tags({artist: self.artist, title: self.name, album: self.album, year: self.year, genre: self.genre, track_position: track_position, publisher: self.publisher,
        release_date: self.release_date})

      #Rails.logger.info 'ETETE' + mp3.has_id3v1_tags?.to_s +  mp3.id3v2_tag_version.to_s

      if !mp3.id3v2_tag_version.nil?
        #puts mp3.id3v2_tag_version
        if mp3.id3v2_tag_version != 4
          self.tag_version = 'v2'
        else
          self.tag_version = 'v2.4'
        end
      end

      new_path = ApplescriptWraper.get_path_of_persistent_id(self.persistent_id)
      self.location = ItunesTrack::translate_path_of_persistent_id_file_location(new_path) unless new_path.nil?
      save
  end

  def update_cover_tag
      mp3 = Mp3File.new(self.translated_file_location_to_file_name)
      mp3.set_cover(self.cover.url)
  end

  def update_file_path
    new_path = ApplescriptWraper.get_path_of_persistent_id(self.persistent_id)
    if !new_path.nil? && self.location != ItunesTrack::translate_path_of_persistent_id_file_location(new_path)
      self.location = ItunesTrack::translate_path_of_persistent_id_file_location(new_path) unless new_path.nil?
      save
    end
  end

  def search_in_references
    tracks = ReferenceTrack
             .joins(:reference_artists)
             .joins(:reference_album)
             .includes(:reference_artists, :reference_album)
             .where('reference_tracks.name_metaphone LIKE ? AND reference_artists.name_metaphone LIKE ?', "%#{name_metaphone}%", "%#{artist_metaphone}%")
             .where('reference_albums.year IS NOT NULL')
             .order('reference_albums.year asc')

    if tracks.count > 0
      self.searched = 'Found'
    else
      self.searched = 'Searched'
    end

    save

    tracks
  end

  def self.search_in_references
    not_searched = ItunesTrack.not_searched
    not_searched.each do |itunes_track|
      JunoReferencesSeeker.new(itunes_track.artist, itunes_track.name)
      itunes_track.search_in_references
    end
  end

  def self.best_rated(column)
    allowed_columns = %w(artist publisher)
    column = 'artist' unless allowed_columns.include?(column)
    itunes_tracks = ItunesTrack.where('rating >= ?', 80)
      .group(column)
      .having('count(?) > ?', column , 3)
    itunes_tracks.each do |itunes_track|
      Rails.logger.info '---- ' +
        itunes_track.artist.to_s + ' - ' + itunes_track.publisher.to_s
    end
  end

  private

  def update_state
    if name.nil? ||
      artist.nil? ||
      album.nil? ||
      genre.nil? ||
      track_number.nil? ||
      track_count.nil? ||
      year.nil? ||
      publisher.nil? ||
      cover.nil? ||
      release_date.nil?
      self.state = 'Updated'
    else
      self.state = 'Completed'
    end
  end
end
