class ThumbnailUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_limit: [120, 90]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    send "default_#{model.type}_url"
  end

  private

  def default_link_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_link_thumbnail.jpg'
    )
  end

  def default_file_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_file_thumbnail.jpg'
    )
  end
end
