class AddMetaphoneToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :artist_metaphone, :string
    add_column :itunes_tracks, :name_metaphone, :string
  end
end
