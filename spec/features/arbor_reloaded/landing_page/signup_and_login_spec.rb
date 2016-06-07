require 'spec_helper'

feature 'Sign up to Arbor' do
  let!(:template_project) { create :project, is_template: true }
  let(:new_user)          { build :user }
  let(:user)              { create :user }

  background do
    allow_any_instance_of(ArborReloaded::IntercomServices)
      .to receive(:user_create_event).and_return(true)
  end

  context 'on sign up' do
    background do
      visit new_user_registration_path

      within '#signup' do
        fill_in :user_full_name, with: new_user.full_name
        fill_in :user_email, with: new_user.email
        fill_in :user_password, with: 'foobar123'
        fill_in :user_password_confirmation, with: 'foobar123'

        click_button 'Sign up'
      end
    end

    scenario 'should redirect me to root' do
      expect(current_path).to eq(root_path)
    end

    scenario 'should create a template project' do
      user = User.find_by(email: new_user.email)

      expect(user.projects.count).to eq(1)
      project = user.projects.first

      expect(project.name).to eq(template_project.name)
      expect(project.user_stories).to eq(template_project.user_stories)
      expect(project.canvas).to eq(template_project.canvas)
      expect(project.owner).to eq(user)
    end

    scenario 'should favorite the template project' do
      user = User.find_by(email: new_user.email)
      expect(user.projects.first.favorite).to be true
    end
  end

  scenario 'after log in should redirect me to root' do
    visit new_user_session_path

    within '#login' do
      find('#user_email.login').set user.email
      find('#user_password.login').set user.password
      find('#login_button').click()
    end

    expect(current_path).to eq(root_path)
  end
end
