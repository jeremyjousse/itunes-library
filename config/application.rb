require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module ItunesLibrary
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.assets.paths << Rails.root.join(
                           'vendor',
                           'assets',
                           'bower_components'
                           )
  end
end
