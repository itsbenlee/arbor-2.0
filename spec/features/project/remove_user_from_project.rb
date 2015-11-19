require 'spec_helper'

feature 'Show project details' do
  let!(:user)     { create :user }
  let!(:member)   { create :user }
  let!(:member_2) { create :user }
  let!(:project) { create :project, members: [user, member, member_2]}

  background  do
    ENV['FROM_EMAIL_ADDRESS'] = 'no-reply@getarbor.io'
    sign_in user
    visit project_path project
  end

  scenario 'should show the delete icon on input', js: true do
    find_link('Edit').click
    expect(page).to have_link('Delete member')
  end

  scenario 'it should not show deleted user', js: true do
    find_link('Edit').click
    within('.member-field#member_0') do
      find_link('Delete member').click
    end
    expect(page).not_to have_content member_2.email
  end
end
