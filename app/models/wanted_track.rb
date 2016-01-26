class WantedTrack < ActiveRecord::Base
  enum status: { 'New' => 0, 'Found' => 1, 'Canceled' => -1 }

  scope :myfreemp3_not_searched, -> { where(found_in_myfreemp3: nil, status: 0).order(created_at: :desc).limit(100000) }

  def is_in_library
    same_file_in_library = ItunesTrack.where("artist_metaphone LIKE ? AND name_metaphone LIKE ? " , "%#{Text::Metaphone.metaphone(artist)}%" ,  "%#{Text::Metaphone.metaphone(title)}%").count
  end

  def self.reset_myfreemp3_found
    wanted_tracks = WantedTrack.where(searched: 1, found_in_myfreemp3: 0)
    wanted_tracks.each do |wanted_track|
      wanted_track.update(found_in_myfreemp3: nil)
    end
  end
end
