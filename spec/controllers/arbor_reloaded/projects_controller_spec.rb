require 'spec_helper'

RSpec.describe ArborReloaded::ProjectsController do
  describe 'PUT update' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user, favorite: false }

    before :each do
      sign_in user
    end

    describe 'PUT update' do
      it 'should send a success response with the projects url when json' do
        put :update, format: :json, id: project.id, project: {
            favorite: true
          }

        project.reload
        expect(project.favorite).to be_truthy

        hash_response = JSON.parse(response.body)
        expect(hash_response['success']).to eq(true)
        expect(hash_response['data']['return_url']).to eq(arbor_reloaded_projects_list_path)
      end
    end

    it 'should redirect to back when html' do
      request.env['HTTP_REFERER'] = arbor_reloaded_project_canvases_path(project.id)
      put :update, format: :html, id: project.id, project: {
          name: 'NewName'
        }

      project.reload
      expect(project.name).to eq('NewName')
      expect(response).to be_redirect
    end

    describe 'list_projects' do
      let!(:project2) { create :project, owner: user, favorite: false }
      render_views

      it 'returns the projects list partial' do
        get :list_projects
        expect(response.body).to have_content(project.name)
        expect(response.body).to have_content(project2.name)
      end
    end
  end
end
