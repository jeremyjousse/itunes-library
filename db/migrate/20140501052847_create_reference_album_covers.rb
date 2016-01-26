class CreateReferenceAlbumCovers < ActiveRecord::Migration
  def change
    create_table :reference_album_covers do |t|
      t.integer :reference_album_id
      t.string :cover
    end
  end
end
