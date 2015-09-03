require 'spec_helper'

RSpec.describe ProjectsController do
  describe 'GET index' do
    context 'for a logged in user' do
      it 'should redirect to login' do
        get :index
        expect(response).to be_redirect
      end
    end

    context 'for a non logged in user' do
      it 'should respond with 200' do
        sign_in create :user
        get :index
        expect(response).to be_success
      end
    end
  end

  describe 'PUT update order' do
    let!(:user)        { create :user }
    let!(:project)     { create :project, owner: user }

    before :each do
      sign_in create :user
    end

    context 'in backlog' do
      it 'should reorder user stories' do
        first_story, second_story, third_story = set_user_stories_on_project(project)

        stories =  { '0' => { id: first_story.id, backlog_order: 2 },
                     '1' => { id: second_story.id, backlog_order: 3 },
                     '2' => { id: third_story.id, backlog_order: 1 } }

        put :order_stories, project_id: project.id, stories: stories

        first_story_updated, second_story_updated, third_story_updated =
          get_reordered(first_story, second_story, third_story)

        expect(first_story_updated.backlog_order).to eq 2
        expect(second_story_updated.backlog_order).to eq 3
        expect(third_story_updated.backlog_order).to eq 1
      end
    end
  end
end
