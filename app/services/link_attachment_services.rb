require 'resolv-replace.rb'
require 'httpclient'

class LinkAttachmentServices
  VALID_TYPES = %w(image)
  IMAGE_TYPES = %w(jpg png tiff jpeg)

  def initialize(link_attachment)
    @link_attachment = link_attachment
  end

  def set_metadata
    @link_attachment.send(:validate_content_url)
    return unless @link_attachment.errors[:content].empty?

    content_type = determine_content_type
    send "set_metadata_#{content_type}" if content_type
    @link_attachment.mime_type = content_type
  end

  private

  def set_metadata_image
    @link_attachment.remote_thumbnail_url = @link_attachment.content
  end

  def set_metadata_other
  end

  def determine_content_type
    http_content_type = fetch_http_content_type
    return 'other' unless http_content_type
    category, type = http_content_type.split('/')
    return category if category.in? VALID_TYPES
    return 'image' if type.in? IMAGE_TYPES
    'other'
  end

  def fetch_http_content_type
    response = HTTPClient.new.head(
      @link_attachment.content,
      follow_redirect: true
    )
    return unless response.status == 200
    type = response.content_type
    return type unless type.include?(';')
    type.split(';')[0]
  end
end
