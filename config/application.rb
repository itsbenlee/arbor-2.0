require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
Dotenv.load(
  File.expand_path("../../.env.#{Rails.env}", __FILE__)
) unless Rails.env.production?

module Railsroot
  class Application < Rails::Application
    config.middleware.use Rack::Deflater
    config.assets.initialize_on_precompile = false
  end
end
