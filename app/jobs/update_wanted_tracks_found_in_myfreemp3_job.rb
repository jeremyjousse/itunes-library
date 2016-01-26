class UpdateWantedTracksFoundInMyfreemp3Job < ActiveJob::Base
  queue_as :default

  def perform(*args)
    wanted_tracks = WantedTrack.myfreemp3_not_searched.limit(1000).order(created_at: :desc)
    wanted_tracks.each do |wanted_track|

      wanted_track.found_in_myfreemp3 = Myfreemp3Seeker.search(wanted_track.artist, wanted_track.title)
      Rails.logger.info '-- update found_in_myfreemp3 for ' + wanted_track.artist + ' - ' + wanted_track.title + ' - Found ' + wanted_track.found_in_myfreemp3.to_s

      wanted_track.save
    end
  end
end
