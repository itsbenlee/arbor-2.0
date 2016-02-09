require 'spec_helper'

feature 'Export backlog' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path project
  end

  scenario 'should display export to pdf link' do
    expect(page).to have_css('.export_backlog')
  end

  scenario 'should download PDF' do
    visit arbor_reloaded_project_export_backlog_path(project, format: :pdf, estimation: false)
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text(
      "#{project.name} Backlog.pdf"
    )
  end
end
