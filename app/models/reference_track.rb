class ReferenceTrack < ActiveRecord::Base


  has_many :reference_track_artists
  has_many :reference_artists, through: :reference_track_artists
  belongs_to :reference_album

  after_save :update_name_metaphone

  enum external_type: { unknown: 0, 'juno': 1, 'discogs': 2, 'beatport': 3 }

  def update_name_metaphone
      update_column(:name_metaphone, Text::Metaphone.metaphone(name))
  end

end
