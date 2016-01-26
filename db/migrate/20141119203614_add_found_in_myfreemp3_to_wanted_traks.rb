class AddFoundInMyfreemp3ToWantedTraks < ActiveRecord::Migration
  def change
    add_column :wanted_tracks, :found_in_myfreemp3, :integer, default: nil
  end
end
