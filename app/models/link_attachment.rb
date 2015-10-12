class LinkAttachment < Attachment
  validate :validate_content_url

  mount_uploader :thumbnail, ThumbnailUploader

  private

  def validate_content_url
    return if content =~ /\A#{URI.regexp(%w(http https))}\z/
    errors[:content] << I18n.t('attachment.link.error')
  end
end
