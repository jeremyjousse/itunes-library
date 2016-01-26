namespace :wanted_tracks do
  desc "update_found_in_myfreemp3"
  task :update_found_in_myfreemp3 => :environment do

    wanted_tracks = WantedTrack.myfreemp3_not_searched.limit(100).order(created_at: :desc)
    wanted_tracks.each do |wanted_track|


      wanted_track.found_in_myfreemp3 = Myfreemp3Seeker.search(wanted_track.artist, wanted_track.title)

      puts '-- update found_in_myfreemp3 for ' + wanted_track.artist + ' - ' + wanted_track.title + ' - Found ' + wanted_track.found_in_myfreemp3.to_s

      wanted_track.save
    end
  end


end
