class CreateWantedTracks < ActiveRecord::Migration
  def change
    create_table :wanted_tracks do |t|
      t.string :artist
      t.string :title
      t.integer :status
      t.integer :searched

      t.timestamps
    end
  end
end
