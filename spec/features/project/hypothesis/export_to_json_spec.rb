require 'spec_helper'

feature 'Export hypothesis to json as a project member' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project}

  background do
    sign_in user
    visit project_hypotheses_path(project_id: project.id)
  end

  scenario 'can download csv' do
    visit project_hypotheses_export_path(project, format: :json)
    response_headers = page.response_headers
    expect(response_headers['Content-Disposition']).to have_text('inline')

    type = hypothesis.hypothesis_type_description
    expect(page).to have_text("\"name\":\"#{project.name}\"")
    expect(page).to have_text("\"description\":\"#{hypothesis.description}\"")
    expect(page).to have_text("\"order\":#{hypothesis.order}")
    expect(page).to have_text("\"type\":{\"description\":\"#{type}\"")
  end
end
