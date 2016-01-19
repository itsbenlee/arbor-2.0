require 'spec_helper'

feature 'Comment icon link with notification badge on User Story list' do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_story)   { create :user_story, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'Should be able to see the comment icon at the right of the user story' do
    within '.backlog-user-story' do
      expect(page).to have_css('.icn-comments')
    end
  end
end
