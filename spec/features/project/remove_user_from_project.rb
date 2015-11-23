require 'spec_helper'

feature 'Show project details' do
  let!(:user)     { create :user }
  let!(:member)   { create :user }
  let!(:member_2) { create :user }
  let!(:project) { create :project, members: [user, member, member_2]}

  background do
    sign_in user
    visit project_path project
    find_link('Edit').click
  end

  scenario 'should show the delete icon on input', js: true do
    expect(page).to have_link('Delete member')
  end

  scenario 'it should not show deleted user', js: true do
    within('#member_1') do
      user_to_delete = find_field('project[member_1]').value
      expect(find_field('project[member_1]').value).to have_text user_to_delete
      find_link('Delete member').click
    end
    expect(page).not_to have_content member.email
    expect(page).to have_content user.email
    expect(page).to have_content member_2.email
  end
end
