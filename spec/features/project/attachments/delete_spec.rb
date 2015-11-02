require 'spec_helper'

feature 'Delete an attachment' do
  let!(:user)   { create :user }
  let(:project) { create :project, owner: user }
  let!(:file)   { create :file_attachment, project: project }


  background do
    sign_in user
    visit project_attachments_path project
  end

  scenario 'should delete an attachment', js: true do
    expect(page).to have_css '.icon-trash'
    a = Attachment.count
    find('#delete-attachment').click()
    expect(page).to_not have_css '.icon-trash'
    expect(Attachment.count).to be < a
  end
end
