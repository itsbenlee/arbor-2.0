require 'spec_helper'

feature 'Connect to Jira' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path project
  end

  context 'clicking More' do
    before do
      click_link 'More...'
    end

    scenario 'should display connect link' do
      expect(page).to have_text('Connect to JIRA')
    end

    context 'clicking connect' do
      before do
        click_link 'Connect to JIRA'
      end

      scenario 'displays the sign in form' do
        expect(page).to have_css('#jira-modal')
        expect(page).to have_text('Sign in into JIRA')
      end
    end
  end
end
