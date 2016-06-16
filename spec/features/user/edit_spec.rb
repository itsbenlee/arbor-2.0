require 'spec_helper'

feature 'Edit Profile', js: true do
  let(:user) { create :user }

  context 'As a User logged in editing my profile' do
    background do
      sign_in user
      visit arbor_reloaded_user_path(user.id)
    end

    scenario 'I should be able to edit the information' do
      within ("form#edit_user_#{user.id}") do
        find('#edit-user-profile-btn').trigger('click')
      end

      expect(page).to have_css('#save-user-profile')
      expect(page).to have_css('#cancel-btn')
    end

    scenario 'I should be able to update my password' do
      within ("form#edit_user_#{user.id}") do
        find('#edit-user-profile-btn').trigger('click')
        find('#user_password').set('12345678')
        find('#user_password_confirmation').set('12345678')
        find('#user_current_password').set(user.password)
        click_button('Save')
      end

      sign_out

      visit new_user_session_path
      find('#user_email.login').set user.email
      find('#user_password.login').set('12345678')
      find('#login_button').click()

      expect(page).to have_content('No projects yet')
    end

    scenario 'I should not be able to change password with different passwords' do
      within ("form#edit_user_#{user.id}") do
        find('#edit-user-profile-btn').trigger('click')
        find('#user_password').set('12345678')
        find('#user_password_confirmation').set('12345678910')
        find('#user_current_password').set(user.password)
        click_button('Save')
      end

      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario 'I should not be able to submit profile changes with wrong password' do
      within ("form#edit_user_#{user.id}") do
        find('#edit-user-profile-btn').trigger('click')
        find('#user_email').set('test@getarbor.io')
        find('#user_current_password').set('wrong_password')
        click_button('Save')
      end

      expect(page).to have_content("Current password is invalid")
    end
  end
end
