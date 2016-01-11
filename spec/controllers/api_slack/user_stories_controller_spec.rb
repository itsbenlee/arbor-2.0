require 'spec_helper'

RSpec.describe ApiSlack::UserStoriesController do
  describe 'PUT create story' do
    let!(:user)        { create :user }
    let!(:project)     { create :project, owner: user }

    it 'should create the story and send a success response' do
      post :create,
        format: :json,
        project_id: project.id,
        text: 'As an Admin I want to have privileges to all the database so that I can check the tables.'


      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(true)
      expect(Project.find(project.id).user_stories.last.role).to eq('Admin')
      expect(Project.find(project.id).user_stories.last.action).to eq('to have privileges to all the database')
      expect(Project.find(project.id).user_stories.last.result).to eq('so that I can check the tables.')
    end

    it 'should fail when text is wrong and send a failure response' do
      post :create,
        format: :json,
        project_id: project.id,
        text: 'I want to have privileges to all the database so that I can check the tables.'


      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(false)
      expect(hash_response['errors']).to have_content('Missing Role')
    end
  end
end
