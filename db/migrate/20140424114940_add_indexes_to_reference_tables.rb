class AddIndexesToReferenceTables < ActiveRecord::Migration
  def change
    add_index :reference_albums, :name
    add_index :reference_albums, :external_id
    add_index :reference_albums, :external_type
    add_index :reference_albums, :reference_label_id

    add_index :reference_artists, :name
    add_index :reference_artists, :name_metaphone

    add_index :reference_labels, :name
    
    add_index :reference_track_artists, :reference_track_id
    add_index :reference_track_artists, :reference_track_artist

    add_index :reference_tracks, :name
    add_index :reference_tracks, :name_metaphone
    add_index :reference_tracks, :reference_album_id
  end
end
