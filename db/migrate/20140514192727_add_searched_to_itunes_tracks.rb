class AddSearchedToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :searched, :integer, default: 0
  end
end
