class AddReleaseDateToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :release_date, :date, default: nil
  end
end
