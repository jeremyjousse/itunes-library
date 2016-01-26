class AddExternalIdToReferenceTracks < ActiveRecord::Migration
  def change
    add_column :reference_tracks, :external_id, :string
  end
end
