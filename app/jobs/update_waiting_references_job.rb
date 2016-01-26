# Update all waiting references
class UpdateWaitingReferencesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    itunes_tracks = ItunesTrack.where.not(state: 2).not_searched.limit(100)
                    .order(rating: :desc, created_at: :desc)
    itunes_tracks.each do |itunes_track|
      BeatportReferencesSeeker.new(itunes_track.artist, itunes_track.name)
      JunoReferencesSeeker.new(itunes_track.artist, itunes_track.name)
      DiscogsReferencesSeeker.new(itunes_track.artist, itunes_track.name)

      itunes_track.search_in_references
      itunes_track.save
    end
  end
end
