class FixReferenceTrackArtists < ActiveRecord::Migration
  def change

    drop_table :reference_track_artists

    create_table :reference_track_artists do |t|
      t.belongs_to :reference_track
      t.belongs_to :reference_artist
      t.timestamps
    end


  end
end
