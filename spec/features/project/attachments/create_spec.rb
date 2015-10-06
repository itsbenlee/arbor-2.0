require 'spec_helper'

feature 'Create a new attachment' do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let(:plain_link)    { build :plain_link_attachment }
  let(:html_link)     { build :html_link_attachment }
  let(:pdf_link)      { build :pdf_link_attachment }
  let(:image_link)    { build :image_link_attachment }
  let(:other_link)    { build :other_link_attachment }

  let(:image_file)    { build :image_file_attachment }
  let(:text_file)     { build :text_file_attachment }
  let(:pdf_file)      { build :pdf_file_attachment }
  let(:other_file)    { build :other_file_attachment }

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

  scenario 'should let me switch to a file creation form and back', js: true do
    find('a#attachment-switcher').trigger('click')
    expect(find('.new-file', visible: false).visible?).to be true
    expect(find('.new-link', visible: false).visible?).to be false
    within '.new-file' do
      expect(page).to have_field :attachment_content
    end

    find('a#attachment-switcher').trigger('click')
    expect(find('.new-file', visible: false).visible?).to be false
    expect(find('.new-link', visible: false).visible?).to be true
  end

  scenario 'should change the attachment switcher text', js: true do
    switcher = find 'a#attachment-switcher'
    expect(switcher.text).to eq 'Upload File'
    switcher.trigger('click')
    expect(switcher.text).to eq 'Paste Link'
    switcher.trigger('click')
    expect(switcher.text).to eq 'Upload File'
  end

  context 'as a link' do
    context 'html attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { html_link }
        let(:entity_name)    { 'html' }
        let(:thumbnail_name) { 'home-hero.png' }
      end
    end

    context 'plain attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { plain_link }
        let(:entity_name)    { 'plain' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end

    context 'pdf attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { pdf_link }
        let(:entity_name)    { 'pdf' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end

    context 'image attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { image_link }
        let(:entity_name)    { 'image' }
        let(:thumbnail_name) { 'PAL_signals.png' }
      end
    end

    context 'other attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { other_link }
        let(:entity_name)    { 'other link' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
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

    context 'pdf file attachment' do
      it_behaves_like 'a file attachment' do
        let(:entity)         { pdf_file }
        let(:entity_name)    { 'pdf file' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end

    context 'image file attachment' do
      it_behaves_like 'a file attachment' do
        let(:entity)         { image_file }
        let(:entity_name)    { 'image file' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end

    context 'txt file attachment' do
      it_behaves_like 'a file attachment' do
        let(:entity)         { text_file }
        let(:entity_name)    { 'text file' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end

    context 'other attachment' do
      it_behaves_like 'a file attachment' do
        let(:entity)         { other_file }
        let(:entity_name)    { 'other file' }
        let(:thumbnail_name) { 'default_thumbnail.jpg' }
      end
    end
  end
end
