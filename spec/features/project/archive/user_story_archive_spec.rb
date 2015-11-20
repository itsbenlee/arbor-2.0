require 'spec_helper'

feature 'List user stories' do
  let!(:user)        { create :user }
  let!(:project)     { create :project }
  let!(:user_story)  { create :user_story, project: project, archived: true }
  let!(:user_story2) { create :user_story, project: project, role: 'visitor' }

  background do
    sign_in user
  end

  context 'archive section' do
    scenario 'should list the archived stories' do
      visit project_archives_path project

      within '.archived-user-stories' do
        expect(page).to have_text user_story.log_description
        expect(page).not_to have_text user_story2.log_description
      end
    end
  end
end
