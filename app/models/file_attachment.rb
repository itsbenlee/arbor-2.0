class FileAttachment < Attachment
  TYPES = %w(pdf image plain)

  mount_uploader :content, FileUploader
  mount_uploader :thumbnail, ThumbnailUploader
end
