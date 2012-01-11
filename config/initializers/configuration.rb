# config/initializers/configuration.rb
class Configuration
  class << self
    attr_accessor :facebook_app_id, :facebook_host, :bitly_username, :bitly_api_id
  end
end