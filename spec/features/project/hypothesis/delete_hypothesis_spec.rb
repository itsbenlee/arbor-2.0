require 'spec_helper'

feature 'Delete hypothesis' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:user_story)  { build :user_story }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show delete link' do
    expect(page).to have_css '.icon-trash'
  end

  scenario 'should delete the hypothesis after clicking the link' do
    find('.delete-hypothesis').click

    expect(Hypothesis.count).to eq 0
    expect(page).not_to have_content hypothesis.description
  end

  scenario 'should not delete associated epics' do
    user_story.hypothesis = hypothesis
    user_story.save

    visit project_hypotheses_path project

    within "#edit_user_story_#{user_story.id}" do
      expect(find('#user_story_role').value).to have_text user_story.role
      expect(find('#user_story_action').value).to have_text user_story.action
      expect(find('#user_story_result').value).to have_text user_story.result
    end

    find('.delete-hypothesis').click

    expect(UserStory.count).to eq 1
    expect(page).not_to have_css "#edit_user_story_#{user_story.id}"
  end
end
