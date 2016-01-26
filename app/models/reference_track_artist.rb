class ReferenceTrackArtist < ActiveRecord::Base

  belongs_to :reference_track
  belongs_to :reference_artist

end