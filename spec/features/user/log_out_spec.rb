require 'spec_helper'

feature 'Sign in' do
  context 'when the user logs in' do
    background do
      sign_in create :user
    end

    scenario 'should show the logout button' do
      expect(page).to have_css('#sidebar a.logout')
    end

    scenario 'clicking the logout should sign the user out' do
      find('#sidebar a.logout').click
      expect(page).to have_content('Signed out successfully')
    end
  end
end
