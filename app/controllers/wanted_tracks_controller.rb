class WantedTracksController < ApplicationController
  before_action :set_wanted_track, only: [:show, :edit, :update, :destroy]
  def index
    params[:per_page] = 10 if params[:per_page].nil?

    @search_params = put_and_get_search_params_in_session('wanted_tracks',{'search' => params[:q], 'page' => params[:page], 'per_page' => params[:per_page]},params[:filter])
    @search = WantedTrack.search(@search_params['search'])
    @search.sorts = 'created_at desc'

    @wanted_tracks = @search.result(distinct: true).paginate(:page => @search_params['page'], :per_page => @search_params['per_page'])
    @total_items = WantedTrack.all().count
    @total_items_selected = @wanted_tracks.count
  end

  def new
    @wanted_track = WantedTrack.new
  end

  def edit
  end

  def search_file
    require 'open-uri'
    require 'erb'

    @wanted_track = WantedTrack.find(params[:wanted_track_id])

    if params[:download_site] == 'myfreemp3'
      @url = 'http://www.my-free-mp3.com/mp3/' + ERB::Util.url_encode(@wanted_track.artist.gsub('&', '')) +'%20' + ERB::Util.url_encode(@wanted_track.title)
    end

    unless @url.nil?
      @wanted_track.searched = 1
      @wanted_track.save
    end

    respond_to do |format|
      format.js { render 'searched' }
    end
  end

  def new_listing
  end

  def new_listing_add
    if !params[:new_listing].nil? && !params[:new_listing][:listing].nil?

      tracks = []
      tracks = params[:new_listing][:listing].split("\n")
      tracks.each do |track|
        track_detail = []
        track_detail = track.split(' - ')
        if track_detail.count == 2
          WantedTrack.create(artist: track_detail[0], title: track_detail[1])
        end
      end


    end

    respond_to do |format|
        format.js { render action: 'reload' }
    end

  end

  def new_import
    @import = JunoPlaylist.new
  end

  def new_import_select
    if params[:juno_playlist][:url].index('http://www.junodownload.com/charts/')
      @import = JunoPlaylist.new
      @import.url = params[:juno_playlist][:url]
      @tracks = @import.parse_chart
    elsif params[:juno_playlist][:url].index('http://www.residentadvisor.net/dj-charts.aspx?top=50')
      @import = ResidentAdvisorPlaylist.new
      @import.url = params[:juno_playlist][:url]
      @tracks = @import.parse_top50
    elsif params[:juno_playlist][:url].index('http://www.residentadvisor.net/dj/') # TODO transform into regex
      @import = ResidentAdvisorPlaylist.new
      @import.url = params[:juno_playlist][:url]
      @tracks = @import.parse_dj_chart
    else
      return false
    end

    require 'uri'
    @tracks_checked = []
    @tracks.each do |track|
      @tracks_checked << URI.encode(track.to_json)
    end

  end

  def new_import_add
    if !params[:juno_playlist].nil?
      playlist = params[:juno_playlist]
    elsif !params[:resident_advisor_playlist].nil?
      playlist = params[:resident_advisor_playlist]
    else
      playlist = nil
    end

    playlist[:tracks].each do |json_track|
      if !json_track.nil?

        json_track_decoded = URI.decode(json_track)
        if !json_track_decoded.nil? && json_track_decoded.length > 2
          track = JSON.parse(json_track_decoded)
          #logger.info '---------' +   track['artist'].inspect

          WantedTrack.create(artist: track['artist'], title: track['title'])
        end
      end
    end

    respond_to do |format|
      format.js { render action: 'reload' }
    end
  end

  def purge
    WantedTrack.where(status: 1).delete_all
    redirect_to wanted_tracks_path, notice: 'Wanted tracks have been purged'
  end

  # POST /wanted_tracks
  # POST /wanted_tracks.json
  def create
    @wanted_track = WantedTrack.new(wanted_track_params)

    respond_to do |format|
      if @wanted_track.save
        format.html { redirect_to wanted_tracks_path, notice: 'Wanted track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @wanted_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @wanted_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wanted_tracks/1
  # PATCH/PUT /wanted_tracks/1.json
  def update
    respond_to do |format|
      if @wanted_track.update(wanted_track_params)
        format.html { redirect_to @wanted_track, notice: 'Wanted track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wanted_track.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_wanted_tracks_found_in_myfreemp3
    UpdateWantedTracksFoundInMyfreemp3Job.perform_later
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def set_found
    @wanted_track = WantedTrack.find(params[:wanted_track_id])
    @wanted_track.status = 'Found'
    @wanted_track.save
    respond_to do |format|
      format.html { redirect_to wanted_tracks_path, notice: 'Wanted track was marked as found.' }
    end
  end

  def destroy
    @wanted_track.destroy
    respond_to do |format|
      format.html { redirect_to wanted_tracks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wanted_track
      @wanted_track = WantedTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wanted_track_params
      params.require(:wanted_track).permit(:artist, :title)
    end
end
