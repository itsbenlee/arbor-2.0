require 'spec_helper'

RSpec.describe ArborReloaded::ProjectsController do
  describe 'PUT update' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user, favorite: false }

    before :each do
      sign_in user
    end

    describe 'PUT update order' do
      context 'in backlog' do
        it 'should reorder user stories' do
          story_1 = create :user_story, project: project, backlog_order: 1
          story_2 = create :user_story, project: project, backlog_order: 2
          story_3 = create :user_story, project: project, backlog_order: 3

          stories =  { '0' => { id: story_1.id, backlog_order: 2 },
                       '1' => { id: story_2.id, backlog_order: 3 },
                       '2' => { id: story_3.id, backlog_order: 1 } }

          put :order_stories, project_id: project.id, stories: stories

          expect(UserStory.find(story_1.id).backlog_order).to eq 2
          expect(UserStory.find(story_2.id).backlog_order).to eq 3
          expect(UserStory.find(story_3.id).backlog_order).to eq 1
        end
      end
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

      it 'returns the projects list partial with html format' do
        get :list_projects, format: :html
        expect(response.body).to have_content(project.name)
        expect(response.body).to have_content(project2.name)
      end

      it 'should send a success response and the projects with json format' do
        get :list_projects, format: :json

        hash_response = JSON.parse(response.body)
        expect(hash_response['success']).to eq(true)
        route_helper = Rails.application.routes.url_helpers(project)
        expected_result =
        [
          { 'label' => project2.name, 'value' => route_helper.arbor_reloaded_project_user_stories_path(project2) },
          { 'label' => project.name, 'value' => route_helper.arbor_reloaded_project_user_stories_path(project) }
        ]
        expect((hash_response['data']['projects'] - expected_result).blank?).to be_truthy
      end
    end
  end
end
