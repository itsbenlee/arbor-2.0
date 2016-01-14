require 'spec_helper'

feature 'Story detail modal', js:true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project, estimated_points: 1 }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
    find('.story-detail-link').click
  end

  scenario 'should display the details modal' do
    expect(page).to have_css('#story-detail-modal')
  end

  scenario 'should be able to estimate a story' do
    find('#fibonacci-dropdown').find('option[value="13"]').select_option
    wait_for_ajax
    user_story.reload
    expect(user_story.estimated_points).to eq(13)
  end

  scenario 'should be able to edit a story' do
    within '#story-detail-modal' do
      find('.sentence').click
      fill_in 'role-input', with: 'developer'
      find('#save-user-story').click
    end
    wait_for_ajax
    user_story.reload
    expect(user_story.role).to eq('developer')
  end

  scenario 'should be able to see other actions' do
    find('.story-actions').click
    within '#story-detail-modal' do
      expect(page).to have_css('a.icn-delete')
      expect(page).to have_css('a.icn-archive')
    end
  end
end
