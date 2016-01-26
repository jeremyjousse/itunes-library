class AddLabelToItunesTracks < ActiveRecord::Migration
  def change
  	add_column :itunes_tracks, :label, :string
  end
end
