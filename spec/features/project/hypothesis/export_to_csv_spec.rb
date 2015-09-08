require 'spec_helper'

feature 'Export hypothesis to csv as a project member' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project}

  background do
    sign_in user
    visit project_hypotheses_path(project_id: project.id)
  end

  scenario 'can export hypotheses' do
    expect(page).to have_css('#export-button')
  end

  scenario 'can export hypotheses on csv format' do
    expect(page).to have_css('#csv_export_link')
  end

  scenario 'can export hypotheses on json format' do
    expect(page).to have_css('#json_export_link')
  end

  scenario 'can export hypotheses on trello format' do
    expect(page).to have_css('#trello_export_link')
  end

  scenario 'can download csv' do
    visit project_hypotheses_export_path(project, format: :csv)
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text('inline')
    expect(page).to have_text(hypothesis.description)
  end

  scenario 'can download csv with a goal' do
    goal = create :goal, hypothesis: hypothesis
    visit project_hypotheses_export_path(project, format: :csv)
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text('inline')
    expect(page).to have_text(goal.title)
  end

  scenario 'can download csv with a user story' do
    user_story = create :user_story, hypothesis: hypothesis, action: 'MY AMAZING ACTION'
    visit project_hypotheses_export_path(project, format: :csv)
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text('inline')
    expect(page).to have_text(user_story.action)
  end
end
