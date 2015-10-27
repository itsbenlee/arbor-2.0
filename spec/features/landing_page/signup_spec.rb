require 'spec_helper'

feature 'Sign up to Arbor' do
  let(:user) { build :user }

  scenario 'should show me the minimum password length when I enter' do
    visit new_user_session_path

    expect(page).to have_content 'Minimum 8 characters'
  end

  scenario 'should sign me up when I enter all credentials correctly' do
    visit new_user_session_path
    within '#signup' do
      fill_in :user_full_name, with: user.full_name
      fill_in :user_email, with: user.email
      fill_in :user_password, with: 'foobar123'
      fill_in :user_password_confirmation, with: 'foobar123'

      click_button 'Sign up'
    end

    expect(page).to have_selector '#sidebar'
  end

  scenario 'should not show me the signup successful message' do
    visit new_user_session_path
    within '#signup' do
      fill_in :user_full_name, with: user.full_name
      fill_in :user_email, with: user.email
      fill_in :user_password, with: 'foobar123'
      fill_in :user_password_confirmation, with: 'foobar123'

      click_button 'Sign up'
    end

    expect(page).not_to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'should show me an error when I enter mismatching passwords' do
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

  scenario 'should show me an error when I enter too short passwords' do
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
