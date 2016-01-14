require 'spec_helper'

feature 'Copy project', js: true do
  let!(:user)             { create :user }
  let!(:project)          { create :project, owner: user }
  let!(:another_project)  { create :project, owner: user }
  let!(:user_story)       { create :user_story, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project.id)
  end

  scenario 'should copy user story on another project' do

    within '.backlog-user-story' do
      find("#select-stories#{user_story.id}", visible: false).trigger(:click)
    end

    within '.sticky-menu' do
      find('a.icn-copy').click
    end

    within '#copy-stories-modal' do
      select another_project.name, from: 'copy_story_project_id'
      find('#copy_stories_submit').click
    end

    visit arbor_reloaded_project_user_stories_path(another_project.id)
    within '.backlog-user-story' do
      expect(page).to have_text user_story.role
      expect(page).to have_text user_story.action
      expect(page).to have_text user_story.result
    end
  end
end
