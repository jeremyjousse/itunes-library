# LongUpdateLibraryFromItunesJob
class UpdateAllRatingsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    ItunesTrack.update_all_ratings
  end
end
