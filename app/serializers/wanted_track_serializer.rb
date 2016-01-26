# Wanted Track Serializer
class WantedTrackSerializer < ActiveModel::Serializer
  attributes :id, :artist, :title, :status, :searched, :created_at,
             :found_in_myfreemp3
end
