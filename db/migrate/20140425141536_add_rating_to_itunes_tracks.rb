class AddRatingToItunesTracks < ActiveRecord::Migration
  def change
    add_column :itunes_tracks, :rating, :integer
  end
end
