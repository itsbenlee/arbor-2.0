require 'spec_helper'

feature 'Create a new project' do
  let!(:user) { create :user }

  background do
    sign_in user
    visit projects_path
  end

  scenario 'should display a new project link on the projects index page' do
    within '.content-general' do
      expect(page).to have_link 'Create new project'
    end
  end

  scenario 'should not allow to create a project without a name' do
    within '.content-general' do
      click_link 'Create new project'
    end
    click_button 'Save Project'

    expect(page).to have_text "Name can't be blank"
  end

  scenario 'should successfully save a project with a valid project name' do
    within '.content-general' do
      click_link 'Create new project'
    end
    fill_in 'project_name', with: 'Test Project'
    click_button 'Save Project'

    expect(page).to have_content 'Test Project'
    expect(Project.first.name).to eq 'Test Project'
  end

  context 'with members provided', js: true do
    before :each do
      visit new_project_path
      fill_in 'project_name', with: 'Test Project'
    end

    scenario 'should ignore empty email fields' do
      click_button 'New Member'
      click_button 'Save Project'

      expect(Project.first.members.count).to eq 1
      expect(Project.first.members).to include user
    end

    scenario 'should ignore non-existing users' do
      click_button 'New Member'
      fill_in 'member_0', with: 'non_existing@test.com'
      click_button 'Save Project'

      expect(Project.first.members.count).to eq 1
      expect(Project.first.members).to include user
    end

    scenario 'should add existing users to the project' do
      additional_member = create :user, email: 'existing@test.com'

      click_button 'New Member'
      fill_in 'member_0', with: 'existing@test.com'
      click_button 'Save Project'

      expect(Project.first.members.count).to eq 2
      [user, additional_member].each do |member|
        expect(Project.first.members).to include user
      end
    end
  end
end
