require 'spec_helper'

feature 'Delete stories', js: true do
  let!(:user)             { create :user }
  let!(:project)          { create :project, owner: user }
  let!(:user_story)       { create :user_story, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'should delete user story from project' do
    find("#select-stories#{user_story.id}", visible: false).trigger(:click)

    within '.sticky-menu' do
      find('a.icn-delete').click
    end

    within '#story-delete-modal' do
      find('#delete_stories_submit').click
    end

    visit arbor_reloaded_project_path(project.id)
    expect(page).to_not have_text user_story.role
    expect(page).to_not have_text user_story.action
    expect(page).to_not have_text user_story.result
  end
end
