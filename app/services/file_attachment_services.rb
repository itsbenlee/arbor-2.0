class FileAttachmentServices
  def initialize(file_attachment)
    @file_attachment = file_attachment
  end

  def set_metadata
    return if @file_attachment.mime_type == 'other'
    @file_attachment.thumbnail = File.open @file_attachment.content.path
  end
end
