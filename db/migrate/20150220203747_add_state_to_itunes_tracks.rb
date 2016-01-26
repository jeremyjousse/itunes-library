class AddStateToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :state, :integer, default: 0
  end
end
