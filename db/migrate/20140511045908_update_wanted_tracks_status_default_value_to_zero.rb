class UpdateWantedTracksStatusDefaultValueToZero < ActiveRecord::Migration
def up
  change_column :wanted_tracks, :status, :integer, default: 0
end

def down
  change_column :wanted_tracks, :status, :integer, default: nil
end
end
