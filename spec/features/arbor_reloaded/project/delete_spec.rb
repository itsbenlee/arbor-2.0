require 'spec_helper'

feature 'delete project' do
  let!(:user)     { create :user }
  let!(:user2)    { create :user }
  let!(:project)  { create :project, owner: user }

  context 'when the user is owner' do
    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project.id)
    end

    scenario 'should show me the delete link' do
      expect(page).to have_css('.icn-delete')
    end
  end

  context 'when the user is not owner' do
    background do
      project.members << user2
      sign_in user2
      visit arbor_reloaded_project_user_stories_path(project.id)
    end

    scenario 'should not show me the delete link' do
      expect(page).not_to have_css('.delete-project')
    end
  end
end
