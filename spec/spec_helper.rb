require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  ENV['FROM_EMAIL_ADDRESS'] = 'no-reply@getarbor.io'
  ENV['MAXIMUM_MEMBER_COUNT'] = '16'
  ENV['VERSION'] = '1.0'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  require 'capybara/rspec'
  require 'capybara/rails'
  require 'capybara/poltergeist'
  require 'factory_girl_rails'
  require 'public_activity/testing'

  PublicActivity.enabled = false

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  Capybara.register_driver :poltergeist do |app|
    options = { inspector: true, timeout: 1.minutes}
    Capybara::Poltergeist::Driver.new(app, options)
  end

  Capybara.javascript_driver = :poltergeist

  Rails.logger.level = 4

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_spec_type_from_file_location!
    config.infer_base_class_for_anonymous_controllers = false
    config.order = 'random'

    config.include WaitForAjax, type: :feature
    config.include FactoryGirl::Syntax::Methods
    config.include Devise::TestHelpers, type: :controller
    config.include Capybara::Auth::Helpers, type: :feature
    config.include UserStoryHelper, type: :controller
    config.include UserStoryHelper, type: :feature

    config.before :suite do
      DatabaseRewinder.clean_with :truncation
    end

    config.before :each do |example_group|
      if Capybara.current_driver == :rack_test
        DatabaseRewinder.strategy = :transaction
      else
        page.driver.browser.url_blacklist = ['http://use.typekit.net']
        DatabaseRewinder.strategy = :truncation
      end
      DatabaseRewinder.start
    end

    config.after do
      DatabaseRewinder.clean
    end
  end
end

Spork.each_run do
end
