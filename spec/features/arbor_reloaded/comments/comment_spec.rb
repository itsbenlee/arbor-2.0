require 'spec_helper'

feature 'Comment spec', js: true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let(:comment)     { build :comment, user: user }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path project
    find('.story-text').click
  end

  scenario 'should show me a comment creation form' do
    expect(page).to have_selector 'form.new_comment'
    within 'form.new_comment' do
      expect(page).to have_field :comment_comment
    end
  end

  scenario 'should create a new comment' do
    within 'form.new_comment' do
      fill_in(:comment_comment, with: comment.comment)
      find('input#save-comment', visible: false).trigger('click')
    end

    expect{ Comment.count }.to become_eq 1
    within '#comment-list' do
      expect(page).to have_content(comment.comment)
      expect(page).to have_content(comment.user_name)
    end
  end

  scenario 'should log the creation' do
    PublicActivity.with_tracking do
      within '#new_comment' do
        fill_in(:comment_comment, with: comment.comment)
        find('input#save-comment', visible: false).trigger('click')
        wait_for_ajax
        expect(PublicActivity::Activity.count).to eq(1)
        expect(PublicActivity::Activity.first.key).to eq('project.add_comment')
      end
    end
  end

  context 'when the user is the author of a comment' do
    let!(:comment) { create :comment, user_story: user_story, user: user }

    background do
      visit current_path
      find('.story-text').trigger('click')
    end

    scenario 'should be able to delete it' do
      within '#comment-list' do
        expect(page).to have_css('.delete-comment')
      end
    end
  end

  context 'when the user is not the author of a comment' do
    let!(:another_user) { create :user }
    let!(:comment)      { create :comment, user_story: user_story, user: another_user }

    background do
      visit current_path
      find('.story-text').trigger('click')
    end

    scenario 'should not be able to delete it' do
      within '#comment-list' do
        expect(page).not_to have_css('.delete-comment')
      end
    end
  end
end
