class AddTagVersionToItunesTracks < ActiveRecord::Migration
  def change
  	add_column :itunes_tracks, :tag_version, :integer, default: 0
  end
end
