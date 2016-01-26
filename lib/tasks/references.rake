namespace :references do
  desc 'update'
  task update: :environment do
    itunes_tracks = ItunesTrack.not_searched.not_completed.limit(100)
                    .order(created_at: :desc)
    itunes_tracks.each do |itunes_track|
      Rails.logger.info '-- -- -- -- -- -- -- -- -- -- -- -- -- -- '
      Rails.logger.info '-- update references for ' \
        + itunes_track.artist + ' - ' + itunes_track.name
      BeatportReferencesSeeker.new(itunes_track.artist, itunes_track.name)
      JunoReferencesSeeker.new(itunes_track.artist, itunes_track.name)
      DiscogsReferencesSeeker.new(itunes_track.artist, itunes_track.name)

      itunes_track.search_in_references
      itunes_track.save
    end
  end
end
