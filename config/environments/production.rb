Railsroot::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_files = false
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.version = '1.0'
  config.assets.digest = true
  config.log_level = :info
  config.assets.precompile += %w( vendor/modernizr.js )
  config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
end

ActionMailer::Base.smtp_settings = {
  address:              'smtp.sendgrid.net',
  port:                 '587',
  authentication:       :plain,
  user_name:            ENV['SENDGRID_USERNAME'],
  password:             ENV['SENDGRID_PASSWORD'],
  domain:               'heroku.com',
  enable_starttls_auto: true
}
