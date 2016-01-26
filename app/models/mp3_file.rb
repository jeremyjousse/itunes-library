class Mp3File

  include ActiveModel::Validations
  require 'taglib'
  require "mp3info"

  attr_reader(:filename)
  attr_reader(:mp3)
  attr_reader(:id3tags)
  attr_reader(:audio_properties)
  attr_reader(:cover)


  #ID3V2_USED_FRAMES = {'artist': 'TPE1', 'title': 'TIT2', 'publisher': 'TPUB', 'album': 'TALB', 'year': 'TYER', 'genre': 'TCON', 'track_position': 'TRCK'}
  ID3V2_USED_FRAMES = {artist: 'TPE1', title: 'TIT2', album: 'TALB', genre: 'TCON', track_position: 'TRCK', publisher: 'TPUB', release_date: 'TDRL', year: 'TDRC'} # 
  #TDOR (Original release time => timestamp)
  #, year: 'TYER'

  def initialize(filename)

  	@filename = filename

  	if @filename.nil?
  		raise ArgumentError, "filename is nil"
  	end

  	if !File.exists?(@filename)
		  raise ArgumentError, "file -" + @filename + "- does not exists"
	 end

    @file = TagLib::MPEG::File.new(@filename)

    @id3tags = {}

    self.fetch_id3tags
    self.audio_properties



  end


  def tag_version_valid?

    if !self.has_id3v2_tags?
      return false
    end

    if @file.id3v2_tag.header.major_version != 4
      return false
    end

    # if self.has_id3v1_tags?
    #   return false
    # end

    return true

  end


  def has_id3v1_tags?



    if !@file.id3v1_tag.empty?
      return true
    end

    return false

  end

  def id3v2_tag_version
    if self.has_id3v2_tags?
      return @file.id3v2_tag.header.major_version
    end

    return nil

  end


  def has_id3v2_tags?

    if !@file.id3v2_tag.nil? && !@file.id3v2_tag.empty?
      return true
    end

    return false

  end

  def remove_id3v1_tags

    if !@file.id3v1_tag.nil? && !@file.id3v1_tag.empty?
      require "mp3info"

        @mp3 = Mp3Info.open(@filename)
        @mp3.removetag1
        @mp3.flush
        @mp3.close


        @file.close
        @file = nil

        @file = TagLib::MPEG::File.new(@filename)

        if !self.has_id3v1_tags?
          return true
        end
    end

    return false

  end


  def fetch_id3tags
    @id3tags = {}

    ID3V2_USED_FRAMES.each do |tag_sympbol, frame_name|
      if @file.id3v2_tag != nil && @file.id3v2_tag.frame_list(frame_name).first.to_s != nil
        @id3tags[tag_sympbol] = @file.id3v2_tag.frame_list(frame_name).first.to_s
      else
        @id3tags[tag_sympbol] = nil
      end
    end

    @id3tags
  end

  def get_cover

    @cover = @file.id3v2_tag.frame_list('APIC').first

    if !@cover.nil?
      #Rails.logger.info " il y a une image ------"
      return @cover
    else
      Struct.new("Cover", :picture, :mime_type)
      @cover = Cover.new(open(Rails.root.join('app/assets/images/','vinyl.jpg'), "rb").read, "image/jpeg")
    end




  end

  def audio_properties
    @audio_properties = {}

    if !@file.audio_properties.nil?
      @audio_properties[:bitrate] = @file.audio_properties.bitrate
      @audio_properties[:sample_rate] = @file.audio_properties.sample_rate
      @audio_properties[:length] = @file.audio_properties.length
    end

    return @audio_properties


  end

  def get_id3_tag(tag_sympbol)
    if !ID3V2_USED_FRAMES[tag_sympbol].nil?
      return @file.id3v2_tag.frame_list(ID3V2_USED_FRAMES[tag_sympbol]).first.to_s
    end

    return nil
  end


  def remove_id3_tags
    @mp3 = Mp3Info.open(@filename)
  	@mp3.removetag1
	  @mp3.removetag2
  	@mp3.flush
    @mp3.close

    @file.close
    @file = nil
    @file = TagLib::MPEG::File.new(@filename)

  end

  def set_tags(hash_tags = {})

    cover = @file.id3v2_tag.frame_list('APIC').first
    if !cover.nil?
      @temp_cover_picture = cover.picture
      @temp_cover_mime_type = cover.mime_type
    end
    #
    temp_other_tags = {}

    temp_other_tags[:TKEY] = @file.id3v2_tag.frame_list("TKEY").first.to_s unless @file.id3v2_tag.frame_list("TKEY").nil?
    temp_other_tags[:TBPM] = @file.id3v2_tag.frame_list("TBPM").first.to_s unless @file.id3v2_tag.frame_list("TBPM").nil?
    # temp_other_tags[:TDOR] = @file.id3v2_tag.frame_list("TDOR").first.to_s unless @file.id3v2_tag.frame_list("TDOR").nil?

    temp_relative_volume_frame = @file.id3v2_tag.frame_list("RVA2").first unless @file.id3v2_tag.frame_list("RVA2").nil?

    #
    temp_geob_tags = []
    unless @file.id3v2_tag.frame_list("GEOB").nil?
      @file.id3v2_tag.frame_list("GEOB").each do |temp_geob_tag|
        extracted_tags = {}
        extracted_tags[:text_encoding] = temp_geob_tag.text_encoding
        extracted_tags[:mime_type] = temp_geob_tag.mime_type
        extracted_tags[:description] = temp_geob_tag.description
        extracted_tags[:object] = temp_geob_tag.object

        temp_geob_tags.push(extracted_tags)
      end
    end


    striped = @file.strip()

    @file.save
    @file.close
    @file = nil

    @file = TagLib::MPEG::File.new(@filename)





  	hash_tags.each do |tag_sympbol, tag_value|


      if !tag_value.nil? && !ID3V2_USED_FRAMES[tag_sympbol].nil?

        if tag_sympbol.to_s == 'artist'
          @file.id3v2_tag.artist = tag_value.to_s
          Rails.logger.info '+++++-------- set tag ' + tag_sympbol.to_s + ' to ' + tag_value.to_s + ' in ID3V2_USED_FRAMES[tag_sympbol] ' +ID3V2_USED_FRAMES[tag_sympbol]
        elsif tag_sympbol.to_s == 'album'
          @file.id3v2_tag.album = tag_value.to_s
          Rails.logger.info '+++++-------- set tag ' + tag_sympbol.to_s + ' to ' + tag_value.to_s + ' in ID3V2_USED_FRAMES[tag_sympbol] ' +ID3V2_USED_FRAMES[tag_sympbol]
        elsif tag_sympbol.to_s == 'title'
          @file.id3v2_tag.title = tag_value.to_s
          Rails.logger.info '+++++-------- set tag ' + tag_sympbol.to_s + ' to ' + tag_value.to_s + ' in ID3V2_USED_FRAMES[tag_sympbol] ' +ID3V2_USED_FRAMES[tag_sympbol]
        else

        if tag_sympbol.to_s == 'genre' && tag_value.to_s == 'Not found'
          tag_value = ''
          Rails.logger.info '+++++-------- set tag ' + tag_sympbol.to_s + ' to ' + tag_value.to_s

        end

        if tag_sympbol.to_s == 'release_date' && tag_value.to_s != ''
          # tag_value = Date.parse(tag_value.to_s).to_time.to_i
          # tag_value = Date.parse(tag_value.to_s).to_time.to_i
# Rails.logger.info '--------release_date ' + tag_value.to_s
        end
          #if get_id3_tag(tag_sympbol) != tag_value

          #Rails.logger.info '-------- set tag ' + tag_sympbol.to_s + ' to ' + tag_value.to_s + ' in ID3V2_USED_FRAMES[tag_sympbol] ' +ID3V2_USED_FRAMES[tag_sympbol]

          tag = TagLib::ID3v2::TextIdentificationFrame.new(ID3V2_USED_FRAMES[tag_sympbol], TagLib::String::UTF8)
          texts = [tag_value.to_s]
          tag.field_list = texts

          @file.id3v2_tag.add_frame(tag)
            # @file.id3v2_tag.add_frame(TagLib::ID3v2::TextIdentificationFrame.new(ID3V2_USED_FRAMES[tag_sympbol], TagLib::String::UTF8))
            # @file.id3v2_tag.frame_list(ID3V2_USED_FRAMES[tag_sympbol]).first.text = tag_value.to_s

        end
    	end

    end
    #
    # @file.id3v2_tag.add_frame(temp_other_tags[:TKEY]) unless temp_other_tags[:TKEY].nil?
    # @file.id3v2_tag.add_frame(temp_other_tags[:RVA2]) unless temp_other_tags[:TKEY].nil?
    temp_other_tags.each do |tag_key, tag_value|
      if !tag_value.nil?
        tag = TagLib::ID3v2::TextIdentificationFrame.new(tag_key.to_s, TagLib::String::UTF8)
        texts = [tag_value]
        tag.field_list = texts
        @file.id3v2_tag.add_frame(tag)
      end
    end

    unless temp_relative_volume_frame.nil?
      tag = TagLib::ID3v2::RelativeVolumeFrame.new('RVA2')
#       ---- RVA2 "SeratoGain"
# ---- RVA2 channels [1]
# ---- RVA2 channel_type 1
# ---- RVA2 volume_adjustment_index 0
# ---- RVA2 volume_adjustment 0.0
      tag.identification = 'SeratoGain'
      tag.channel_type = 1
      tag.set_volume_adjustment_index(0)
      tag.set_volume_adjustment(0.0)

      # texts = [temp_relative_volume_frame]
      # tag.field_list = texts
      @file.id3v2_tag.add_frame(tag)
    end

    unless temp_geob_tags.nil?
      temp_geob_tags.each do |temp_geob_tag|
        tag = TagLib::ID3v2::GeneralEncapsulatedObjectFrame.new()
        tag.text_encoding = temp_geob_tag[:text_encoding]
        tag.mime_type = temp_geob_tag[:mime_type]
        tag.description = temp_geob_tag[:description]
        tag.object = temp_geob_tag[:object]
        @file.id3v2_tag.add_frame(tag)
      end
    end


    if !@temp_cover_picture.nil?
      apic = TagLib::ID3v2::AttachedPictureFrame.new
      apic.mime_type = @temp_cover_mime_type
      apic.description = "Cover"
      apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
      apic.picture = @temp_cover_picture
      @file.id3v2_tag.add_frame(apic)
    end




    @file.save
    @file.close
    @file = nil

    @file = TagLib::MPEG::File.new(@filename)

  end


  def set_cover(cover_url)

  apic = TagLib::ID3v2::AttachedPictureFrame.new
  apic.mime_type = "image/jpeg"
  apic.description = "Cover"
  apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
  apic.picture = File.open(Rails.root.join('public/' + cover_url), 'rb') { |f| f.read }

  @file.id3v2_tag.add_frame(apic)


    @file.save
    @file.close
    @file = nil

    @file = TagLib::MPEG::File.new(@filename)

  end

end
