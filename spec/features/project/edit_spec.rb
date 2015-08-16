require 'spec_helper'

feature 'Edit a project' do
  let!(:user) { create :user }
  let!(:project) do
    create(
      :project,
      name:    'Test Project',
      owner:   user,
      members: [user]
    )
  end

  before :each do
    ENV['MAXIMUM_MEMBER_COUNT'] = '4'
    sign_in user
    visit projects_path
  end

  scenario 'should display an edit project link on the projects index page' do
    expect(page).to have_link 'Edit'
    expect(page).to have_href edit_project_path(project)
  end

  scenario 'should show the current project name' do
    click_link 'Edit'
    expect(find('input#project_name').value).to eq 'Test Project'
  end

  scenario 'should not allow to edit a project name to an empty string' do
    click_link 'Edit'
    fill_in 'project_name', with: ''
    click_button 'Update Project'

    expect(page).to have_text "Name can't be blank"
  end

  scenario 'should successfully save a project with a valid project name' do
    click_link 'Edit'
    fill_in 'project_name', with: 'Changed Project'
    click_button 'Update Project'

    expect(page).to have_content 'Changed Project'
    expect(Project.first.name).to eq 'Changed Project'
  end

  context 'without members', js: true do
    before :each do
      visit edit_project_path project
    end

    scenario 'should only allow up to 4 users' do
      expect(all('input.member').count).to eq 1
      click_button 'New Member'
      expect(all('input.member').count).to eq 2

      3.times do
        click_button 'New Member'
      end

      expect(all('input.member').count).to eq 4
    end

    scenario 'should ignore empty email fields' do
      click_button 'New Member'
      click_button 'Update Project'

      expect(Project.first.members.count).to eq 1
      expect(Project.first.members).to include user
    end

    scenario 'should ignore non-existing users' do
      click_button 'New Member'
      fill_in 'member_0', with: 'non_existing@test.com'
      click_button 'Update Project'

      expect(Project.first.members.count).to eq 1
      expect(Project.first.members).to include user
    end
  end

  context 'with members', js: true do
    let(:member) { create :user, email: 'existing@test.com' }

    scenario 'should show all associated members' do
      project.members << member
      visit edit_project_path project

      [user.email, 'existing@test.com'].each do |email|
        expect(
          all('input.member').find do |input|
            input.value == email
          end
        ).not_to be_nil
      end
    end

    scenario 'should remove deleted members' do
      project.members << member
      visit edit_project_path project

      input = all('input.member').find do |input|
        input.value == 'existing@test.com'
      end

      fill_in input[:id], with: 'non_existing@test.com'
      click_button 'Update Project'

      visit project_path project
      expect(page).to have_content user.email
      expect(page).not_to have_content 'existing@test.com'
      expect(page).not_to have_content 'non_existing@test.com'
    end

    scenario 'should add new members' do
      visit edit_project_path project

      click_button 'New Member'
      fill_in 'member_1', with: member.email

      click_button 'Update Project'
      visit project_path project
      expect(page).to have_content user.email
      expect(page).to have_content member.email
    end
  end
end
