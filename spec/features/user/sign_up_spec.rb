require 'spec_helper'

feature 'Sign up' do
  let!(:template_project)  { create :project, is_template: true }

  context 'for a user with invites' do
    let!(:project)  { create :project }
    let!(:invite)   { create :invite, email: 'testing@test.com', project: project }

    def create_user
      visit new_user_registration_path
      within '#signup' do
        find('#user_full_name').set('Name')
        find('#user_email').set('testing@test.com')
        find('#user_password').set('11111111')
        find('#user_password_confirmation').set('11111111')
        click_button('Sign up')
      end
    end

    scenario 'should delete the invite' do
      count_before = Invite.count
      create_user
      count_after = Invite.count
      expect(count_after).to eq(count_before - 1)
    end

    scenario 'should add user as member of the invite project' do
      create_user
      user = User.find_by(email:'testing@test.com')
      expect(user.projects.first.name).to eq(project.name)
    end
  end
end
