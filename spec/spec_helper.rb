require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'false'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'capybara/rspec'
  require 'capybara/rails'
  require 'factory_girl_rails'

  FactoryGirl.factories.clear
  FactoryGirl.reload

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  Capybara.javascript_driver = :webkit

  # Change rails logger level to reduce IO during tests
  Rails.logger.level = 4

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.order = 'random'

    config.include FactoryGirl::Syntax::Methods

    # Uncomment if you want to include Devise. Add devise to your gemfile
    # config.include Devise::TestHelpers, type: :controller

    config.before :each do |example_group|
      if Capybara.current_driver == :rack_test
        DatabaseRewinder.strategy = :transaction
      else
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
  # This code will be run each time you run your specs.
end
