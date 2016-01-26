namespace :itunes_tracks do
  desc 'update_all_ratings'
  task update_all_ratings: :environment do
    ItunesTrack.update_all_ratings
  end

  desc 'update_library'
  task update_library: :environment do
    ItunesXmlLibraryParser.update_library
  end
end
