require 'spec_helper'

feature 'Delete hypothesis' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:user_story)  { create :user_story, hypothesis: hypothesis }


  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show delete link' do
    expect(page).to have_css '.icon-trash'
  end

  scenario 'should delete the hypothesis after clicking the link' do
    within '.hypothesis-show' do
      find('.delete-hypothesis').click
    end

    expect(Hypothesis.count).to eq 0
    expect(page).not_to have_content hypothesis.description
  end

  scenario 'should not delete hypotheses with assigned user stories' do
    hypothesis.user_stories << user_story
    visit project_hypotheses_path project

    within '.hypothesis-show' do
      find('.delete-hypothesis').click
    end

    expect(hypothesis.user_stories.count).to eq 1
    expect(page).to have_content(
      'You are not allowed to delete hypotheses with assigned user stories'
    )
    within "#edit_user_story_#{user_story.id}" do
      expect(find('#user_story_action').value).to have_text user_story.action
    end
  end
end
