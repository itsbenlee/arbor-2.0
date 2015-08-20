require 'spec_helper'

feature 'Show project details' do
  let!(:user)    { create :user }
  let!(:member)  { create :user }
  let!(:project) { create :project, members: [user, member] }

  background do
    sign_in user
    visit project_path project
  end

  scenario 'should show an edit link' do
    expect(page).to have_href edit_project_path(project)
  end

  scenario 'should show the project name' do
    expect(page).to have_content project.name
  end

  scenario 'should show the names of all members' do
    expect(page).to have_content user.full_name
    expect(page).to have_content member.full_name
  end

  scenario 'should show the email addresses of all members' do
    expect(page).to have_content user.email
    expect(page).to have_content member.email
  end
end
