class ReferenceAlbum < ActiveRecord::Base
  belongs_to :reference_label
  has_many :reference_tracks, dependent: :delete_all
  has_many :reference_album_covers, dependent: :delete_all
  accepts_nested_attributes_for :reference_album_covers
  enum external_type: { unknown: 0, 'juno': 1, 'discogs': 2, 'beatport': 3 }
end
