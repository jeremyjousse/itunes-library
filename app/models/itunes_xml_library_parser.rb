class ItunesXmlLibraryParser
  include ActiveModel::Validations
  def self.update_library
    filename = File.expand_path('~/Music/iTunes/iTunes Music Library.xml')
    doc = Nokogiri::XML(File.open(filename, 'r'))
    counter = 0
    imported_files = Array.new
    files_in_itunes_library = doc.xpath('/plist/dict/dict/dict').count
    Rails.logger.info "#{files_in_itunes_library} files in the library"


	doc.xpath('/plist/dict/dict/dict').each do |node|

  		hash     = Hash.new("Not found")
  		last_key = nil

  		node.children.each do |child|
  			next if child.blank?

		    if child.name == 'key'
		      last_key = child.text.tr('A-Z','a-z').tr(' ','_')
		    else
		      hash[last_key] = child.text
		    end
		end

    # puts Track Type</key><string>Remote
    # puts '---- track_type ' +hash['track_type'].to_s
    next if hash['track_type'].to_s == 'Remote'

    next if hash['kind'] != 'Fichier audio MPEG'

    hash['track_id'] = hash['track_id'].to_i

    itunes_track = ItunesTrack.where(:persistent_id => hash['persistent_id']).first_or_initialize

    itunes_track.artist = hash['artist']
    itunes_track.name = hash['name']
    itunes_track.album = hash['album']
    itunes_track.genre = hash['genre']
    itunes_track.size = hash['size'].to_i
    itunes_track.total_time = hash['total_time'].to_i
    itunes_track.track_number = hash['track_number'].to_i
    itunes_track.track_count = hash['track_count'].to_i
    itunes_track.year = hash['year']
    itunes_track.bit_rate = hash['bit_rate'].to_i
    itunes_track.sample_rate = hash['sample_rate'].to_i
    itunes_track.artwork_count = hash['artwork_count']
    itunes_track.location = hash['location']
    itunes_track.save

    # puts '-------- track ' + hash['artist'].to_s + '- ' + hash['name'].to_s

    counter += 1

    imported_files << hash['persistent_id']

    if counter % 20 == 0
      puts '-------- counter ' + (counter*100/files_in_itunes_library).to_s + "% -------- progression"
    end

  end

	ItunesTrack.all.find_each do |itunes_track|

		if !imported_files.include?(itunes_track.persistent_id)
			puts '------- !!! ' + itunes_track.persistent_id + ' was deleted from library'
			itunes_track.destroy
		end

	end
	puts "#{files_in_itunes_library} files in the library"
	puts "#{counter} items"
  end


end
