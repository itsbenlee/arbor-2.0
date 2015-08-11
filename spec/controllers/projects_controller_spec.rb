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
end
