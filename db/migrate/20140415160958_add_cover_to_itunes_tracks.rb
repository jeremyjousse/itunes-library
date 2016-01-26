class AddCoverToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :cover, :string
  end
end
