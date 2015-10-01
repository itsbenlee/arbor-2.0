class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  process :set_content_type
  process :save_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  private

  def save_content_type
    type = extract_type
    return model.mime_type = 'other' unless type && type.in?(
      FileAttachment::TYPES
    )
    model.mime_type = type
  end

  def extract_type
    type = file.content_type
    return unless type.include? '/'
    parts = type.split '/'
    parts[0] == 'image' ? 'image' : parts[1]
  end
end
