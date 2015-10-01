require 'spec_helper'

feature 'Create a new attachment' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }
  let(:plain)    { build :plain_link_attachment }
  let(:html)     { build :html_link_attachment }
  let(:pdf)      { build :pdf_link_attachment }
  let(:image)    { build :image_link_attachment }

  context 'as a link' do
    background do
      sign_in user
      visit project_attachments_path project
    end

    scenario 'should show me a link creation form' do
      expect(page).to have_field :attachment_content
    end

    context 'html attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { html }
        let(:entity_name)    { 'html' }
        let(:thumbnail_name) { 'home-hero.png' }
      end
    end

    context 'plain attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { plain }
        let(:entity_name)    { 'plain' }
        let(:thumbnail_name) { 'default_thumbnail.png' }
      end
    end

    context 'pdf attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { pdf }
        let(:entity_name)    { 'pdf' }
        let(:thumbnail_name) { 'default_thumbnail.png' }
      end
    end

    context 'image attachment' do
      it_behaves_like 'a link attachment' do
        let(:entity)         { image }
        let(:entity_name)    { 'image' }
        let(:thumbnail_name) { 'PAL_signals.png' }
      end
    end
  end
end
