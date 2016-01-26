class RenameLabelToPublisherInItunesTracks < ActiveRecord::Migration
  def change
  	rename_column :itunes_tracks, :label, :publisher
  end
end
