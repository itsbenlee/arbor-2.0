class FileAttachment < Attachment
  mount_uploader :content, FileUploader
  mount_uploader :thumbnail, ThumbnailUploader
end
