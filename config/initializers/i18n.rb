if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |_exception, _locale, key, _options|
    fail "missing translation: #{ key }"
  end
end
