RSpec.shared_examples 'a file attachment' do
  feature 'create file attachment' do
    scenario "should create a file attachment" do
      within '.new-file form#new_attachment' do
        attach_file 'attachment_content', entity.content.file.path
        click_button 'Save'
      end

      within '.attachment-content' do
        expect(page).to have_content entity.content.file.filename
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
