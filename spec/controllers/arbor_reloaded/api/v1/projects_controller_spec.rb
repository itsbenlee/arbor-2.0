require 'spec_helper'

RSpec.describe ArborReloaded::Api::V1::ProjectsController do
  describe 'without user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials('fake credentials')
        post :create
      end

      it 'should return an unauthorization code' do
        expect(response.code.to_i).to eq(401)
      end
    end
  end

  describe 'for common user' do
    let(:user) { create :user }

    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials(user.access_token)

        @project_name = Faker::App.name
        post :create, { project: { name: @project_name } }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should return the right project name' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['name']).to eq(@project_name)
      end
    end

    describe '#duplicated_create' do
      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials(user.access_token)

        @project_name = Faker::App.name
        post :create, { project: { name: @project_name } }
        post :create, { project: { name: @project_name } }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should return the right project name' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['name']).to eq(@project_name)
      end
    end
  end
end
