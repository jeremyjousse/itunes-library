class AddIndexToItunesTracks < ActiveRecord::Migration
  def change
  	add_index :itunes_tracks, :name
  	add_index :itunes_tracks, :album
  	add_index :itunes_tracks, :genre
  	add_index :itunes_tracks, :persistent_id
  end
end
