require 'spec_helper'

feature 'Export backlog' do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }

  let!(:user_stories) do
    create_list :user_story, 2, project: project, hypothesis: nil
  end

  let!(:acceptance_criterions) do
    user_stories.map do |story|
      story.acceptance_criterions << create_list(:acceptance_criterion, 2, user_story: story)
    end.flatten
  end

  let!(:constraints) do
    user_stories.map do |story|
      story.constraints << create_list(:constraint, 2, user_story: story)
    end.flatten
  end

  background do
    sign_in user
    visit project_user_stories_path project
  end

  scenario 'can export the backlog' do
    expect(page).to have_css('#export-button')
  end

  scenario 'can export the backlog in PDF format' do
    expect(page).to have_css('#pdf_export_link')
  end

  scenario 'can download PDF' do
    visit project_backlog_export_path project, format: :pdf
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text(
      "#{project.name} Backlog.pdf"
    )
  end

  scenario 'can view all contents of the backlog' do
    visit project_backlog_export_path project, format: :pdf, debug: true
    user_stories.each do |story|
      %i(role action result).each do |field|
        expect(page).to have_content story.send(field)
      end
    end

    constraints.map do |constraint|
      expect(page).to have_content constraint.description
    end
    acceptance_criterions.map do |acceptance_criterion|
      expect(page).to have_content acceptance_criterion.description
    end
  end
end
