require 'spec_helper'

feature 'Sign out', js: true do
  context 'when the user logs in' do
    background do
      sign_in create :user
      visit arbor_reloaded_projects_path
    end

    scenario 'clicking the logout should sign the user out' do
      within '.top-bar' do
        find('.icn-signout').trigger('click')
      end
      expect(page).to have_content('Signed out successfully')
    end
  end
end
