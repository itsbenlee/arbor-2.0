CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.development?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AMAZON_KEY'],
      aws_secret_access_key: ENV['AMAZON_SECRET']
    }
    config.storage = :fog
    config.fog_directory = ENV['AMAZON_BUCKET_NAME']
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  else
    config.storage = :file
  end
end
