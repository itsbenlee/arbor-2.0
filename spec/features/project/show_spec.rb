require 'spec_helper'

feature 'Show project details' do
  let!(:user)    { create :user }
  let!(:member)  { create :user }
  let!(:project) { create :project, members: [user, member] }

  background do
    ENV['FROM_EMAIL_ADDRESS'] = 'no-reply@getarbor.io'
    sign_in user
    visit project_path project
  end

  scenario 'should show the project name on the sidebar' do
    within '.sidebar-project-list' do
      expect(page).to have_content(project.name)
    end
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

  scenario 'should not show the delete project link for common users', js: true do
    expect(page).not_to have_link('Delete project')
  end

  scenario 'should not display the edit form', js: true do
    expect(page).not_to have_css('form#edit_project')
  end

  scenario 'should display the edit form when edit is clicked', js: true do
    find_link('Edit').click
    expect(page).to have_css('form#edit_project')
  end

  context 'the user is the project owner' do
    background do
      project.update_attributes(owner: user)
      visit project_path project
    end

    scenario 'should be able to delete the project' do
      find_link('Delete project').click
      expect{ project.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
