# Seek for references on external websites
class ReferencesSeeker
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def initialize(artists, title)
    @searched_artists_string = artists
    @searched_title_string = title

    split_artists

    sanitize_artists

    sanitize_title

    search
  end

  def self.reset_references
    ReferenceTrackArtist.destroy_all
    ReferenceTrack.destroy_all
    ReferenceArtist.destroy_all
    ReferenceAlbum.destroy_all
    ReferenceLabel.destroy_all
  end

  def search
    require 'open-uri'
  end

  def parse_search_result(result)
  end

  def parse_album(url)
  end

  def save_release(album)
  end

  private

  def split_artists
    regex = /(?:\s*(?:,|&|vs|feat[.]*|presents)\s*)+/
    @searched_artist_array = @searched_artists_string.downcase.split(regex)
  end

  def sanitize_artists
  end

  def sanitize_title
    regex = /(?:\s*(?:\(original[ mix]*\))\s*)+/
    @searched_title_string = @searched_title_string.downcase.gsub(regex , '')
  end
end
