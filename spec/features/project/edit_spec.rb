require 'spec_helper'

feature 'Edit a project' do
  ENV['FROM_EMAIL_ADDRESS'] = 'no-reply@getarbor.io'
  let!(:user) { create :user }
  let!(:project) do
    create(
      :project,
      name:    'Test Project',
      owner:   user,
      members: [user]
    )
  end

  background do
    sign_in user
    visit projects_path
  end

  scenario 'should display an edit project link on the projects index page' do
    expect(page).to have_href edit_project_path(project)
  end

  scenario 'should show the current project name' do
    visit edit_project_path project
    expect(find('input#project_name').value).to eq 'Test Project'
  end

  scenario 'should not allow to edit a project name to an empty string' do
    visit edit_project_path project
    fill_in 'project_name', with: ''
    click_button 'Update Project'

    expect(page).to have_text "Name can't be blank"
  end

  scenario 'should successfully save a project with a valid project name' do
    visit edit_project_path project
    fill_in 'project_name', with: 'Changed Project'
    click_button 'Update Project'

    expect(page).to have_content 'Changed Project'
    expect(Project.first.name).to eq 'Changed Project'
  end

  context 'without members', js: true do
    before :each do
      visit edit_project_path project
    end

    scenario 'should ignore empty email fields' do
      click_button 'New Member'
      click_button 'Update Project'

      expect(Project.first.members.count).to eq 1
      expect(Project.first.members).to include user
    end

    context 'with invites' do
      background do
        click_button 'New Member'
        fill_in 'member_0', with: 'email@email.com'
        click_button 'Update Project'
      end

      scenario 'should create an invite for non-existing users' do
        expect(Invite.first.email).to eq('email@email.com')
        expect(Invite.first.project.name).to eq('Test Project')
      end

      scenario 'should send an email invite for non-existing users' do
        expect(ActionMailer::Base.deliveries.last.to.first)
          .to have_content('email@email.com')
      end
    end
  end

  context 'with a user that is not the project owner' do
    let(:new_owner) { create :user }

    background do
      project.members << new_owner
      project.update_attributes(owner: new_owner)
      visit edit_project_path project
    end

    scenario 'should not modify the project owner when another user edits' do
      click_button 'New Member'
      fill_in 'member_0', with: 'email@email.com'
      click_button 'Update Project'

      expect{ project.reload }.not_to change{ project.owner }
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

      fill_in input[:id], with: 'test@test.com'
      click_button 'Update Project'

      visit project_path project
      expect(page).to have_content user.email
      expect(page).not_to have_content 'existing@test.com'
      within '.email-invited' do
        expect(page).to have_content 'test@test.com'
      end
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

    scenario 'should send an email invite to new members' do
      visit edit_project_path project

      click_button 'New Member'
      fill_in 'member_1', with: member.email

      click_button 'Update Project'
      expect(ActionMailer::Base.deliveries.last.to.first)
        .to have_content(member.email)
    end
  end
end
