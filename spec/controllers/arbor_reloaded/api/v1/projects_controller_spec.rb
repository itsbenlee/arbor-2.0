require 'spec_helper'

RSpec.describe ArborReloaded::Api::V1::ProjectsController do
  let(:user)         { create :user }
  let(:project_name) { Faker::App.name }
  let(:access_token) { ActionController::HttpAuthentication::Token.encode_credentials(user.access_token) }

  describe 'without user' do
    describe '#create' do
      subject { response }

      before do
        request.env['HTTP_AUTHORIZATION'] =
          ActionController::HttpAuthentication::Token.encode_credentials('fake credentials')
        post :create
      end

      it { should  have_http_status 401 }
    end
  end

  describe 'for common user' do
    describe '#create' do
      before do
        request.env['HTTP_AUTHORIZATION'] = access_token
        post :create, { project: { name: project_name } }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should return the right project name' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['name']).to eq(project_name)
      end
    end

    describe '#duplicated_create' do
      before do
        request.env['HTTP_AUTHORIZATION'] = access_token

        post :create, { project: { name: project_name } }
        post :create, { project: { name: project_name } }
      end

      it 'should return a success code' do
        expect(response.code.to_i).to eq(200)
      end

      it 'should return the right project name' do
        response_hash = JSON.parse(response.body)
        expect(response_hash['name']).to eq(project_name)
      end
    end
  end

  describe 'for project with starting date' do
    let(:project_starting_date) { 1.day.from_now }
    subject { JSON.parse response.body }

    before do
      request.env['HTTP_AUTHORIZATION'] = access_token
      post :create, { project: { name: project_name, starting_date: project_starting_date} }
    end

    it { should include('name' => project_name)}
    it { should include('starting_date' => project_starting_date.to_date.to_s)}
  end
end
