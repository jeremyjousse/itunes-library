class Mp3Importer

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_reader(:filename)
  attr_accessor(:artist)
  attr_accessor(:title)
  attr_accessor(:time)



  def initialize(filename)

    @filename = filename

    if @filename.nil?
      raise ArgumentError, "filename is nil"
    end

    if !File.exists?(@filename)
      raise ArgumentError, "file does not exists"
    end

    @mp3 = Mp3File.new(@filename)

    #@mp3 = Mp3Info.open(@filename)
    #@mp3 = TagLib::MPEG::File.new(@filename)

    @artist = @mp3.id3tags[:artist]
    @title = @mp3.id3tags[:title]
    if @mp3.audio_properties[:length].present?
      @time = Time.at(@mp3.audio_properties[:length]).utc.strftime('%M:%S')
    end
  end


  def self.get_waiting_files

    files_to_import = []

    files_in_importer_folder = Dir.entries(ENV["ITUNES_LIBRARY_IMPORTER_FOLDER"])



    files_in_importer_folder.each do |file_in_importer_folder|



      if File.extname(ENV["ITUNES_LIBRARY_IMPORTER_FOLDER"] + file_in_importer_folder) == '.mp3'
        file_to_import = Mp3Importer.new(ENV["ITUNES_LIBRARY_IMPORTER_FOLDER"] + file_in_importer_folder)
         files_to_import <<  file_to_import
      end

    end

    files_to_import

  end

  def import_file_to_itunes_library

    mp3 = Mp3File.new(@filename)

    mp3.remove_id3_tags

    mp3.set_tags({artist: @artist, title: @title})

    File.rename @filename, ENV["AUTOMATICALLY_ADD_TO_ITUNES_LIBRARY_FOLDER"] + @artist + ' - ' + @title + '.mp3'

  end

  def persisted?
    false
  end

end
