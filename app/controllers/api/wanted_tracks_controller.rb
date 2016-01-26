module Api
  # Itunes Track controller
  class WantedTracksController < ApplicationController
    def index
      page = (params[:page] || 1).to_i
      wanted_tracks = WantedTrack.page(page).per(10)
      render json: wanted_tracks,
             meta: { total_pages: wanted_tracks.total_pages }
    end
  end
end
