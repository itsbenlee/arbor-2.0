require 'spec_helper'

feature 'User profile', js:true do
  let!(:user) { create :user,
    full_name: 'Jhon Doe',
    email: 'jhon.doe@mail.com'
  }

  context 'As a User logged in editing my profile' do
    background do
      sign_in user
      visit arbor_reloaded_user_path(user)
    end

    scenario 'I should be able to update my password' do
      within("form#edit_user_#{user.id}") do
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
      within("form#edit_user_#{user.id}") do
        find('#user_password').set('12345678')
        find('#user_password_confirmation').set('12345678910')
        find('#user_current_password').set(user.password)
        click_button('Save')
      end

      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario 'I should not be able to submit profile changes with wrong password' do
      within("form#edit_user_#{user.id}") do
        find('#user_email').set('test@getarbor.io')
        find('#user_current_password').set('wrong_password')
        click_button('Save')
      end

      expect(page).to have_content("Current password is invalid")
    end

    scenario 'When the user does not have an avatar defined the initial
      of his name should appear as avatar' do
      within find('.user-header') do
        expect(page.evaluate_script("$('#avatar-circle').text()")).to eq('J')
      end
    end

    scenario 'I should have my api key' do
      expect(page.evaluate_script("$('#arbor-token-field').text()")).to eq(user.access_token)
    end

    scenario 'I should see the copy token button' do
      expect(page).to have_content('Copy access token')
    end
  end
end
