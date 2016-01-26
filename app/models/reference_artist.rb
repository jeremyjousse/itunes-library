class ReferenceArtist < ActiveRecord::Base
  
  has_many :reference_track_artists
  has_many :reference_tracks, through: :reference_track_artists


  after_save :update_name_metaphone

  def update_name_metaphone
      update_column(:name_metaphone, Text::Metaphone.metaphone(name))
  end
end