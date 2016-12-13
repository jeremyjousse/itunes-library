# Apple Script Wrapper
class ApplescriptWrapper
  include ActiveModel::Validations

  def self.get_path_of_persistent_id(persistent_id)
    script = Rails.root.join('script', 'applescript', 'getPatbOfPersistentID')
    `/usr/bin/osascript #{script} #{persistent_id}`
  end

  def self.get_rating_of_persistent_id(persistent_id)
    script = Rails.root.join('script', 'applescript', 'get_rating_of_persistent_id')
    `/usr/bin/osascript #{script} #{persistent_id.to_i}`
  end

  def self.set_rating_of_persistent_id(persistent_id, rating)
    script = Rails.root.join('script', 'applescript', 'set_rating_of_persistent_id')
    `/usr/bin/osascript #{script} #{persistent_id} #{rating}`
  end

  def self.now_playing
    script = Rails.root.join('script', 'applescript', 'get_now_playing')
    `/usr/bin/osascript #{script}`
  end
end
