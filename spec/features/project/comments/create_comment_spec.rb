require 'spec_helper'

feature 'Create a new comment' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let(:comment)     { build :comment, user: user }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
  end

  scenario 'should show me a comment creation form', js: true do
    expect(page).to have_selector 'form.new_comment'
    within 'form.new_comment' do
      expect(page).to have_field :comment_comment
    end
  end

  scenario 'should create a new comment', js: true do
    within 'form.new_comment' do
      fill_in(:comment_comment, with: comment.comment)
      find('input#save-comment', visible: false).trigger('click')
    end

    expect{ Comment.count }.to become_eq 1
    within '.user-story-edit-form' do
      expect(page).to have_content(comment.comment)
      expect(page).to have_content(comment.user_name)
    end
  end

  scenario 'should log the creation', js: true do
    PublicActivity.with_tracking do
      within 'form.new_comment' do
        fill_in(:comment_comment, with: comment.comment)
        find('input#save-comment', visible: false).trigger('click')
        wait_for_ajax
        expect(PublicActivity::Activity.count).to eq(1)
        expect(PublicActivity::Activity.first.key).to eq('project.add_comment')
      end
    end
  end
end
