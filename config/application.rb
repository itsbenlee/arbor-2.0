require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Railsroot
  class Application < Rails::Application
    config.to_prepare do
      Devise::SessionsController.layout 'guest'
      Devise::RegistrationsController.layout 'guest'
      Devise::ConfirmationsController.layout 'guest'
      Devise::UnlocksController.layout 'guest'
      Devise::PasswordsController.layout 'guest'
    end

    config.assets.initialize_on_precompile = false
  end
end
