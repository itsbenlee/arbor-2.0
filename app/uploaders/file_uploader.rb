class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  process :set_content_type
  process :save_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def save_content_type
    model.mime_type = extract_type
  end

  def extract_type
    type = file.content_type
    parts = type.split '/'
    parts[0] == 'image' ? 'image' : 'other'
  end
end
