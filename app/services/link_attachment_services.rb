require 'resolv-replace.rb'
require 'httpclient'

class LinkAttachmentServices
  VALID_TYPES = %w(html pdf image plain)

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

  def set_metadata_html
    page = MetaInspector.new @link_attachment.content
    @link_attachment.remote_thumbnail_url = page.images.best
  end

  def set_metadata_pdf
  end

  def set_metadata_plain
  end

  def set_metadata_image
    @link_attachment.remote_thumbnail_url = @link_attachment.content
  end

  def set_metadata_other
  end

  def determine_content_type
    http_content_type = fetch_http_content_type
    if http_content_type
      category, type = http_content_type.split('/')
      return category if category.in? VALID_TYPES
      return type if type.in? VALID_TYPES
    end

    'other'
  end

  def fetch_http_content_type
    response = HTTPClient.new.head(
      @link_attachment.content,
      follow_redirect: true
    )
    return if response.status != 200
    type = response.content_type
    return type.split(';')[0] if type.include?(';')
    type
  end
end
