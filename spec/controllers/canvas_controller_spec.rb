require 'spec_helper'

RSpec.describe CanvasController do
  describe 'GET index' do
    before :each do
      @project = create :project
      @canvas  = create :canvas, { project: @project }
    end
    context 'for a non logged in user' do
      it 'should redirect to login' do
        get :index, { project_id: @project.id }
        expect(response).to be_redirect
      end
    end

    context 'for a non logged in user' do
      it 'should respond with 200' do
        user = create :user
        @project.members.push(user)
        sign_in user
        get :index, { project_id: @project.id }
        expect(response).to be_success
      end
    end
  end
end
