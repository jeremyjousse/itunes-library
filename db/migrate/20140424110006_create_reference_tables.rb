class CreateReferenceTables < ActiveRecord::Migration
  def change
    create_table :reference_artists do |t|
      t.string :name
      t.string :name_metaphone
      t.timestamps
    end

    create_table :reference_labels do |t|
      t.string :name
      t.timestamps
    end

    create_table :reference_albums do |t|
      t.string :name
      t.integer :year
      t.integer :track_number
      t.integer :reference_label_id
      t.timestamps
    end

    create_table :reference_tracks do |t|
      t.string :name
      t.string :name_metaphone
      t.integer :duration
      t.integer :track_position
      t.integer :reference_album_id
      t.text :sample_url
      t.timestamps
    end

    create_table :reference_track_artists do |t|
      t.string :reference_track_id
      t.string :reference_track_artist
      t.integer :year
      t.timestamps
    end
  end
end
