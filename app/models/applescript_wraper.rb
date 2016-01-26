class ApplescriptWraper

  include ActiveModel::Validations


  def self.get_path_of_persistent_id(persistent_id)

    script = Rails.root.join('script', 'applescript', 'getPatbOfPersistentID')
    result = `/usr/bin/osascript #{script} #{persistent_id}`
    
  end



  def self.get_rating_of_persistent_id(persistent_id)

    script = Rails.root.join('script', 'applescript', 'get_rating_of_persistent_id')
    result = `/usr/bin/osascript #{script} #{persistent_id}`
    
  end

  def self.set_rating_of_persistent_id(persistent_id, rating)

    script = Rails.root.join('script', 'applescript', 'set_rating_of_persistent_id')
    result = `/usr/bin/osascript #{script} #{persistent_id} #{rating}`

    #exec("osascript -e 'tell application \"iTunes\" to set rating of (first track of library playlist 1 whose persistent ID is \"".$_REQUEST['persistentId']."\") to ".$_REQUEST['rate']."'");

  end

  def self.get_now_playing

	script = Rails.root.join('script', 'applescript', 'get_now_playing')

    result = `/usr/bin/osascript #{script}`
    
  end



end


