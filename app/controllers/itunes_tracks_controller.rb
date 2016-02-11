class ItunesTracksController < ApplicationController
  before_action :set_itunes_track, only: [:show, :edit, :update, :destroy]

  def index
    params[:per_page] = 10 if params[:per_page].nil?

    @search_params = put_and_get_search_params_in_session('itunes_tracks',{'search' => params[:q], 'page' => params[:page], 'per_page' => params[:per_page]},params[:filter])

    @q = ItunesTrack.paginate(:page => @search_params['page'], :per_page => @search_params['per_page']).search(@search_params['search'])

    @itunes_tracks = @q.result(distinct: true)
    @total_items = ItunesTrack.all.count
    @total_items_selected = @itunes_tracks.count
  end

  def show
    @itunes_track = ItunesTrack.find(params[:id])
    @itunes_track.update_file_path

    @mp3 = Mp3File.new(@itunes_track.translated_file_location_to_file_name)
  end

  def show_cover
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])
    @mp3 = Mp3File.new(@itunes_track.translated_file_location_to_file_name)

    cover = @mp3.get_cover
    response.headers['Cache-Control'] = "public, max-age=#{12.hours.to_i}"
    response.headers['Content-Type'] = cover.mime_type
    response.headers['Content-Disposition'] = 'inline'
    render text: cover.picture
  end

  def update_cover
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])

    @itunes_track.cover = params[:cover]
    @itunes_track.update(itunes_track_update_cover_params)

    @itunes_track.update_cover_tag

    respond_to do |format|
      format.html { redirect_to edit_itunes_track_path(@itunes_track), notice: 'Itunes track was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # GET /itunes_tracks/new
  def new
    @itunes_track = ItunesTrack.new
  end

  # GET /itunes_tracks/1/edit
  def edit
    @itunes_track = ItunesTrack.find(params[:id])
    @itunes_track.update_file_path
    @itunes_track.get_rating_from_itunes

    @mp3 = Mp3File.new(@itunes_track.translated_file_location_to_file_name)

    @reference_tracks = @itunes_track.search_in_references
  end

  def edit_now_playing
    persistent_id = ItunesTrack.now_playing
    respond_to do |format|
      if !persistent_id.nil?
        @itunes_track = ItunesTrack.find_by_persistent_id(persistent_id.strip)

        format.html { redirect_to edit_itunes_track_path(@itunes_track) }
      else
        format.html { redirect_to itunes_tracks_path, warning: 'No playing tra(ck) {  }' }
      end
    end
  end

  # POST /itunes_tracks
  # POST /itunes_tracks.json
  def create
    @itunes_track = ItunesTrack.new(itunes_track_params)

    respond_to do |format|
      if @itunes_track.save

        @itunes_track.update_tags_and_path

        format.html { redirect_to itunes_tracks_path, notice: 'Itunes track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @itunes_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @itunes_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /itunes_tracks/1
  # PATCH/PUT /itunes_tracks/1.json
  def update
    respond_to do |format|
      if @itunes_track.update(itunes_track_params)
        @itunes_track.update_tags_and_path

        format.html { redirect_to edit_itunes_track_path(@itunes_track), notice: 'Itunes track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @itunes_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /itunes_tracks/1/edit
  def rate
    @itunes_track = ItunesTrack.find(params[:id])

    @itunes_track.set_rating(params['rating'])

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def update_missing_informations
    ItunesTrack.update_missing_informations
  end

  def update_references
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])
    BeatportReferencesSeeker.new(@itunes_track.artist, @itunes_track.name)
    JunoReferencesSeeker.new(@itunes_track.artist, @itunes_track.name)
    DiscogsReferencesSeeker.new(@itunes_track.artist, @itunes_track.name)

    respond_to do |format|
      format.html { redirect_to edit_itunes_track_path(@itunes_track), notice: 'Itunes track was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def update_from_reference
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])
    reference_track = ReferenceTrack.find(params[:reference_track_id])

    if !reference_track.id.nil?
      artist_string = ''
      reference_track.reference_artists.each do |artist|
        artist_string = artist_string + ', ' unless artist_string == ''
        artist_string = artist_string + artist.name.gsub(/(\w+)/) {|s| s.capitalize}
      end
      update_hash = {artist: artist_string,name: reference_track.name, album: reference_track.reference_album.name, year: reference_track.reference_album.year, publisher: reference_track.reference_album.reference_label.name, track_number: reference_track.track_position, track_count: reference_track.reference_album.track_number,
        release_date: reference_track.reference_album.release_date}
      @itunes_track.update(update_hash)

      @itunes_track.update_tags_and_path
    end
    respond_to do |format|
        format.html { redirect_to edit_itunes_track_path(@itunes_track), notice: 'Itunes track was successfully updated.' }
        format.json { head :no_content }
    end
  end

  def update_cover_from_reference
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])
    reference_album_cover = ReferenceAlbumCover.find(params[:reference_album_cover_id])

    unless reference_album_cover.id.nil?
      @itunes_track.cover = File.open(reference_album_cover.reference_album.reference_album_covers.first.cover.file.file)
      @itunes_track.save
      @itunes_track.update_cover_tag
    end

    respond_to do |format|
      format.html { redirect_to edit_itunes_track_path(@itunes_track), notice: 'Itunes track was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def update_waiting_references
    UpdateWaitingReferencesJob.perform_later
    redirect_to itunes_tracks_path
  end

  def easy_complet
    @itunes_track = ItunesTrack.easy_updatable.limit(1)
                    .order(created_at: :desc).first
    @itunes_track.update_file_path
    @itunes_track.get_rating_from_itunes

    @mp3 = Mp3File.new(@itunes_track.translated_file_location_to_file_name)

    @reference_tracks = @itunes_track.search_in_references.limit(30)
    redirect_to easy_update_skeep_path(@itunes_track) if @reference_tracks.count > 100
  end

  def easy_update
    @itunes_track = ItunesTrack.find(params[:itunes_track_id])
    reference_track = ReferenceTrack.find(params[:reference_track_id])
    unless reference_track.id.nil?
      artist_string = ''
      reference_track.reference_artists.each do |artist|
        artist_string += ', ' unless artist_string == ''
        artist_string += artist.name.gsub(/(\w+)/, &:capitalize)
      end
      update_hash = { artist: artist_string, name: reference_track.name, album: reference_track.reference_album.name, year: reference_track.reference_album.year, publisher: reference_track.reference_album.reference_label.name, track_number: reference_track.track_position, track_count: reference_track.reference_album.track_number,
        release_date: reference_track.reference_album.release_date}
      @itunes_track.update(update_hash)
      @itunes_track.update_tags_and_path
      @itunes_track.cover = File.open(reference_track.reference_album.reference_album_covers.first.cover.file.file)
      @itunes_track.save
      @itunes_track.update_cover_tag
    end
    respond_to do |format|
      format.html { redirect_to easy_complet_itunes_tracks_path, notice: 'Itunes track was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def easy_update_skeep
    respond_to do |format|
      @itunes_track = ItunesTrack.find(params[:itunes_track_id])
      if @itunes_track.update(searched: 3)
        format.html { redirect_to easy_complet_itunes_tracks_path, notice: 'Itunes track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'easy_complet' }
        format.json { render json: @itunes_track.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @itunes_track.destroy
    respond_to do |format|
      format.html { redirect_to itunes_tracks_url }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_itunes_track
      @itunes_track = ItunesTrack.find(params[:id])
    end

    def itunes_track_params
      params.require(:itunes_track).permit(:name, :artist, :album, :genre, :size, :total_time, :track_number, :track_count, :year, :publisher, :release_date)
    end

    def itunes_track_update_cover_params
      params.require(:itunes_track).permit(:cover)
    end

    def itunes_track_rating_params
      params.require(:itunes_track).permit(:rating)
    end
end
