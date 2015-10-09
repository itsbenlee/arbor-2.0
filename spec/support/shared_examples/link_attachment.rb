RSpec.shared_examples 'a link attachment' do
  feature 'create link attachment' do
    scenario "should create a link attachment" do
      VCR.use_cassette("create_#{entity_name}_link_attachment") do
        within '.new-link form#new_attachment' do
          fill_in :attachment_content, with: entity.content
          click_button 'Save'
        end
      end

      within '.attachment-content' do
        expect(page).to have_content entity.content
      end

      within '.attachment-thumbnail' do
        expect(find('img')[:src]).to include thumbnail_name
      end

      within '.attachment-activity' do
        expect(page).to have_content user.full_name
      end
    end
  end
end
