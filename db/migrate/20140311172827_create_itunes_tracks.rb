class CreateItunesTracks < ActiveRecord::Migration
  def change
    create_table :itunes_tracks do |t|
      t.string :name
      t.string :artist
      t.string :album
      t.string :genre
      t.integer :size
      t.integer :total_time
      t.integer :track_number
      t.integer :track_count
      t.integer :year
      t.integer :bit_rate
      t.integer :sample_rate
      t.integer :artwork_count
      t.string :persistent_id
      t.text :location

      t.timestamps
    end
  end
end
