require 'spec_helper'

feature 'Delete user_story' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:user_story) do
    create :user_story, project: project, hypothesis: hypothesis
  end

  background do
    sign_in user
  end

  scenario 'should show delete link on lab section' do
    visit project_hypotheses_path project
    expect(page).to have_css '.delete-user-story'
  end

  scenario 'should delete the user story after clicking the link on lab section' do
    visit project_hypotheses_path project
    find('.delete-user-story').click

    expect(UserStory.count).to eq 0
    %i(role action result).each do |field|
      expect(page).not_to have_content user_story.send(field)
    end
  end

  scenario 'should show delete link on backlog section' do
    visit project_user_stories_path project
    expect(page).to have_css '.delete-story a'
  end

  scenario 'should delete the user story after clicking the link on backlog section' do
    visit project_user_stories_path project
    find('.delete-story a').click

    expect(UserStory.count).to eq 0
    %i(role action result).each do |field|
      expect(page).not_to have_content user_story.send(field)
    end
  end
end
