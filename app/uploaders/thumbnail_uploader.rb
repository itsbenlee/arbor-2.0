class ThumbnailUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    send "default_#{model.mime_type}_url"
  end

  private

  def default_pdf_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_thumbnail.jpg'
    )
  end

  def default_plain_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_thumbnail.jpg'
    )
  end

  def default_html_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_thumbnail.jpg'
    )
  end

  def default_image_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_thumbnail.jpg'
    )
  end

  def default_other_url
    ActionController::Base.helpers.image_path(
      'fallbacks/attachments/default_thumbnail.jpg'
    )
  end
end
