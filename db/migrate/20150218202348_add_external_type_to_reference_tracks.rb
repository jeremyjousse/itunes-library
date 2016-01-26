class AddExternalTypeToReferenceTracks < ActiveRecord::Migration
  def change
    add_column :reference_tracks, :external_type, :integer
  end
end
