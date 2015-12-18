require 'spec_helper'

feature 'update project' do
  let(:project)         { create :project }
  let(:project_service) { ProjectServices.new(project) }

  scenario 'should load the response with the projects list url' do
    response = project_service.update_project

    expect(response.success).to eq(true)
    expect(response.data[:return_url]).to eq(arbor_reloaded_projects_list_path)
  end
end
