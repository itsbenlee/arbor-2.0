require 'spec_helper'

RSpec.describe LinkAttachment do
  let(:link_attachment) { create :link_attachment }
  subject               { link_attachment }

  it { should validate_presence_of :content }
  it { should belong_to(:project) }
  it { should belong_to(:user) }

  describe 'validate_content_url' do
    let(:valid_url)   { 'https://trello.com' }
    let(:invalid_url) { 'foo/bar' }

    it 'should verify valid urls' do
      attachment = build :link_attachment, content: valid_url
      attachment.send(:validate_content_url)

      expect(attachment.errors).to be_empty
    end

    it 'should reject invalid urls' do
      attachment = build :link_attachment, content: invalid_url
      attachment.send(:validate_content_url)

      expect(attachment.errors.count).to eq 1
    end
  end
end
