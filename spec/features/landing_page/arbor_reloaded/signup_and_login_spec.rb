require 'spec_helper'

feature 'Sign up to Arbor' do
  let(:new_user) { build :user }
  let(:user)     { create :user }

  context 'when ENABLE_RELOADED is true' do
    background do
      ENV['ENABLE_RELOADED'] = 'true'
    end

    after :each do
      ENV['ENABLE_RELOADED'] = 'false'
    end

    scenario 'after sign up should redirect me to arbor reloaded' do
      visit new_user_registration_path

      within '#signup' do
        fill_in :user_full_name, with: new_user.full_name
        fill_in :user_email, with: new_user.email
        fill_in :user_password, with: 'foobar123'
        fill_in :user_password_confirmation, with: 'foobar123'

        click_button 'Sign up'
      end
      expect(current_path).to eq('/arbor_reloaded')
    end

    scenario 'after log in should redirect me to arbor reloaded' do
      visit new_user_session_path

      within '#login' do
        find('#user_email.login').set user.email
        find('#user_password.login').set user.password
        find('#login_button').click()
      end

      expect(current_path).to eq('/arbor_reloaded')
    end
  end

  context 'when ENABLE_RELOADED is false' do
    background do
      ENV['ENABLE_RELOADED'] = 'false'
      visit new_user_registration_path
    end

    scenario 'after sign up should redirect me to old arbor' do
      visit new_user_registration_path

      within '#signup' do
        fill_in :user_full_name, with: new_user.full_name
        fill_in :user_email, with: new_user.email
        fill_in :user_password, with: 'foobar123'
        fill_in :user_password_confirmation, with: 'foobar123'

        click_button 'Sign up'
      end

      expect(current_path).to eq(root_path)
    end

    scenario 'after log in should redirect me to old arbor' do
      visit new_user_session_path

      within '#login' do
        find('#user_email.login').set user.email
        find('#user_password.login').set user.password
        find('#login_button').click()
      end

      expect(current_path).to eq(root_path)
    end
  end
end
