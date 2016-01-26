class AddExternalTypeAndExternalIdToReferenceAlbums < ActiveRecord::Migration
  def change
    add_column :reference_albums, :external_id, :string
    add_column :reference_albums, :external_type, :integer
  end
end
