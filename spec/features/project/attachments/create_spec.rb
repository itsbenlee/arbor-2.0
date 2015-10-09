require 'spec_helper'

feature 'Create a new attachment' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }
  let(:link)     { build :link_attachment }
  let(:file)     { build :file_attachment }

  background do
    sign_in user
    visit project_attachments_path project
  end

  scenario 'should show me a link creation form when I enter', js: true do
    expect(find('.new-link', visible: false).visible?).to be true
    within '.new-link' do
      expect(page).to have_field :attachment_content
    end
  end

  scenario 'should not show me a file creation form when I enter', js: true do
    expect(find('.new-file', visible: false).visible?).to be false
  end

  scenario 'should let me switch to a file creation form', js: true do
    find('a#attachment-switcher').trigger('click')
    expect(find('.new-file', visible: false).visible?).to be true
    expect(find('.new-link', visible: false).visible?).to be false
    within '.new-file' do
      expect(page).to have_field :attachment_content
    end
  end

  scenario 'should change the attachment switcher text', js: true do
    switcher = find 'a#attachment-switcher'
    expect(switcher.text).to eq 'UPLOAD FILE'
  end

  context 'as a link' do
    it_behaves_like 'a link attachment' do
      let(:entity)         { link }
      let(:entity_name)    { 'link' }
      let(:thumbnail_name) { 'default_link_thumbnail.jpg' }
    end
  end

  context 'as a file', js: true do
    before :each do
      FileUploader.enable_processing = true
      find('a#attachment-switcher').trigger('click')
    end

    after :each do
      FileUploader.enable_processing = false
    end

    it_behaves_like 'a file attachment' do
      let(:entity)         { file }
      let(:entity_name)    { 'file' }
      let(:thumbnail_name) { 'default_file_thumbnail.jpg' }
    end
  end
end
