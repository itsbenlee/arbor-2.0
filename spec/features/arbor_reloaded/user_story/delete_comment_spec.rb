require 'spec_helper'

feature 'Delete comment on User Story modal' do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_story)   { create :user_story, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'Should be able to click on a user story and see a modal', js: true do
    find(".story-detail-link").click
    expect(page).to have_css('#story-detail-modal')
  end

  scenario 'Should be able to see the comment form', js: true do
    find(".story-detail-link").click
    expect(page).to have_css('#comment_comment')
  end

  context 'When there are comments' do
    let!(:comment) { create :comment, comment: 'This is a comment', user_story: user_story }

    scenario 'Should be able to see the comment' do
      find(".story-detail-link").click
      expect(page).to have_content('This is a comment')
    end

    scenario 'Should be able to see the delete comment icon' do
      find(".story-detail-link").click
      expect(page).to have_css('.icn-delete')
    end
  end
end
