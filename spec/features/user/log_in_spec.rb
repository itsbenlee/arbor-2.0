require 'spec_helper'

feature 'Sign in' do
  context 'when a user is not logged in' do
    scenario 'there is no alert message on landing page' do
      visit root_url
      expect(page).not_to have_content('You need to sign in or sign up before continuing.')
    end

    scenario 'there is an alert message for urls other than landing page' do
      visit arbor_reloaded_projects_path
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'when the user logs in' do
    background do
      sign_in create :user
    end

    scenario 'should not show a success message' do
      expect(page).not_to have_content('Signed in successfully.')
    end
  end
end
