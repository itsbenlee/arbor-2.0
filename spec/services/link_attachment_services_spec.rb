require 'spec_helper'

describe 'LinkAttachmentServices' do
  let(:html_link)  { build :html_link_attachment }
  let(:image_link) { build :image_link_attachment }
  let(:plain_link) { build :plain_link_attachment }
  let(:pdf_link)   { build :pdf_link_attachment }

  feature 'fetch_http_content_type' do
    {
      html:  'text/html',
      image: 'image/png',
      plain: 'text/plain',
      pdf:   'application/pdf'
    }.each_pair do |type, response|
      scenario "should determine http #{type} content" do
        VCR.use_cassette("determine_http_content_type_#{type}") do
          service = LinkAttachmentServices.new(send("#{type}_link".to_sym))
          http_content_type = service.send(:fetch_http_content_type)
          expect(http_content_type).to eq response
        end
      end
    end
  end

  feature 'determine_content_type' do
    %w(html image plain pdf).each do |type|
      scenario "should determine #{type} content" do
        VCR.use_cassette("determine_content_type_#{type}") do
          service = LinkAttachmentServices.new(send("#{type}_link".to_sym))
          content_type = service.send(:determine_content_type)
          expect(content_type).to eq type
        end
      end
    end
  end

  feature 'set_metadata' do
    %w(html image plain pdf).each do |type|
      scenario "should set metadata for #{type} correctly" do
        VCR.use_cassette("set_metadata_#{type}") do
          link_attachment = send("#{type}_link".to_sym)
          service = LinkAttachmentServices.new(link_attachment)
          service.send(:set_metadata)
          expect(link_attachment.mime_type).to eq type
        end
      end
    end
  end
end

