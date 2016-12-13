# Home Controller
class HomeController < ApplicationController
  layout 'angular'

  def index
    @rails_version = Rails::VERSION::STRING
    @ruby_version = RUBY_VERSION.to_s + '-p' + RUBY_PATCHLEVEL.to_s
  end
end
