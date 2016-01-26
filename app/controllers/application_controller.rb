class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def itunes_play
  	result = `/usr/bin/osascript -e 'tell app "iTunes" to play'`
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def itunes_next
  	result = `/usr/bin/osascript -e 'tell app "iTunes" to next track'`
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def itunes_previous
  	result = `/usr/bin/osascript -e 'tell app "iTunes" to previous track'`
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def update_library
    UpdateLibraryFromItunesJob.perform_later
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def update_all_ratings
    UpdateAllRatingsJob.perform_later
  end

  def long_update_library
    LongUpdateLibraryFromItunesJob.perform_later
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def put_and_get_search_params_in_session(controller_name, params_hash , filter)
    session[:listing_filter_params]  ||= Hash.new

    search_params_hash = { 'search' => {}, 'page' => 1, 'per_page' => 10, 'reseted' => nil }


    if filter == 'reset'
       search_params_hash['reseted'] = true
    elsif session[:listing_filter_controller_name] == controller_name

      if !params_hash['search'].nil?
        params_hash['search'].each do |search_param_key,search_param_value|
          search_params_hash['search'][search_param_key] = search_param_value
        end
      else
        search_params_hash['search'] = session[:listing_filter_params]['search']
      end

      search_params_hash['search'].delete_blank


			if !(search_params_hash['search'].to_a - session[:listing_filter_params]['search'].to_a).empty?
        logger.info "----- --- -- -- - reset page : search"
        logger.info '----' + search_params_hash['search'].to_a.to_s
        logger.info '----' + session[:listing_filter_params]['search'].to_a.to_s
				params_hash['page'] = 1
			end

      if !params_hash['per_page'].nil?
        search_params_hash['per_page'] = params_hash['per_page']
      else
        search_params_hash['per_page'] = session[:listing_filter_params]['per_page']
      end

      if !params_hash['page'].nil?
        search_params_hash['page'] = params_hash['page']
      else
        search_params_hash['page'] = session[:listing_filter_params]['page']
      end

    end

    if search_params_hash['per_page'].to_s != session[:listing_filter_params]['per_page'].to_s
      logger.info "----- --- -- -- - reset page : per_page"
      logger.info "---- - - -session[:listing_filter_params]['per_page'] '" + session[:listing_filter_params]['per_page'].to_s + "' --- --- search_params_hash[per_page] '" + search_params_hash['per_page'].to_s + "'"
      search_params_hash['page'] = 1
    end


    session[:listing_filter_controller_name] = controller_name
    session[:listing_filter_params] = search_params_hash

    if search_params_hash['reseted'] == true
      redirect_to   request.env['PATH_INFO']
    end

    search_params_hash
  end

end
