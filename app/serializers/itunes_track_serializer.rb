# Itunes Track Serializer
class ItunesTrackSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :artist
end
