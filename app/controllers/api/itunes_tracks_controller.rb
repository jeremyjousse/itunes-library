module Api
  # Itunes Track controller
  class ItunesTracksController < Api::ApiController
    def index
      page = (params[:page] || 1).to_i
      itunes_tracks = ItunesTrack.page(page).per(10)
      render json: itunes_tracks,
             meta: { total_pages: itunes_tracks.total_pages }
      # params[:per_page] = 10 if params[:per_page].nil?
      # @q = ItunesTrack
      #      .paginate(page: params[:page],
      #                per_page: params[:per_page])
      #      .search(params[:q])
      #
      # itunes_tracks = @q.result(distinct: true)
      # total_items = ItunesTrack.all.count
      # total_items_selected = itunes_tracks.count
      #
      # render json: itunes_tracks,
      #        meta: { total_pages: total_items, total: total_items, selected: total_items_selected }
    end
  end
end
