class AddIndexToItunesTracksArtist < ActiveRecord::Migration
  def change
  	add_index :itunes_tracks, :artist
  end
end
