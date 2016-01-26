# UpdateLibraryFromItunesJob
class UpdateLibraryFromItunesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    ItunesXmlLibraryParser.update_library
  end
end
