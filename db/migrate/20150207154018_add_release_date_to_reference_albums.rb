class AddReleaseDateToReferenceAlbums < ActiveRecord::Migration
  def change
    add_column :reference_albums, :release_date, :date, default: nil
  end
end
