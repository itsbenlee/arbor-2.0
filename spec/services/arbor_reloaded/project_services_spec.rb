require 'spec_helper'
module ArborReloaded
  feature 'update project' do
    let(:project)         { create :project }
    let(:project_service) { ArborReloaded::ProjectServices.new(project) }

    scenario 'should load the response with the projects list url' do
      response = project_service.update_project
      route_helper = Rails.application.routes.url_helpers

      expect(response.success).to eq(true)
      expect(response.data[:return_url]).to eq(route_helper.arbor_reloaded_projects_list_path)
    end
  end
end
