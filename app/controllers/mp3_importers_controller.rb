class Mp3ImportersController < ApplicationController
  def index
    @files_to_import = Mp3Importer::get_waiting_files
  end

  def edit
  	file_to_import_url = params['file']
	  @file_to_import = Mp3Importer.new(file_to_import_url)
    @file_to_import.artist = @file_to_import.artist.titleize unless @file_to_import.artist.nil?
    @file_to_import.title = @file_to_import.title.titleize unless @file_to_import.title.nil?
  end

  def create

  	file_to_import_url = params['mp3_importer']['filename']

logger.info '-------------' + file_to_import_url

	@file_to_import = Mp3Importer.new(file_to_import_url)

	@file_to_import.artist = params['mp3_importer']['artist']
	@file_to_import.title = params['mp3_importer']['title']


	@file_to_import.import_file_to_itunes_library

    respond_to do |format|

		format.html { redirect_to mp3_importers_path, notice: 'Track was successfully Imported.' }
	end
  end


end
