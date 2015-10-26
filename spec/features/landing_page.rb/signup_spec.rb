require 'spec_helper'

feature 'Sign up to Arbor' do
  let(:user) { build :user }

  scenario 'when I enter all credentials correctly I can sign up' do
    visit new_user_session_path
    within '#signup' do
      fill_in :user_full_name, with: user.full_name
      fill_in :user_email, with: user.email
      fill_in :user_password, with: 'foobar123'
      fill_in :user_password_confirmation, with: 'foobar123'

      click_button 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'When I enter mismatching passwords I should get an error' do
    visit new_user_session_path
    within '#signup' do
      fill_in :user_full_name, with: user.full_name
      fill_in :user_email, with: user.email
      fill_in :user_password, with: 'foobar123'
      fill_in :user_password_confirmation, with: 'foobar12'

      click_button 'Sign up'
    end

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'When I enter too short passwords I should get an error' do
    visit new_user_session_path
    within '#signup' do
      fill_in :user_full_name, with: user.full_name
      fill_in :user_email, with: user.email
      fill_in :user_password, with: 'foobar'
      fill_in :user_password_confirmation, with: 'foobar'

      click_button 'Sign up'
    end

    expect(page).to have_content 'Password is too short'
  end
end
