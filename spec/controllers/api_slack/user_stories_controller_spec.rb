require 'spec_helper'

RSpec.describe ApiSlack::UserStoriesController do
  describe 'POST create story' do
    let!(:user)        { create :user, slack_id: 'slackUser12345' }
    let!(:project)     { create :project, owner: user, slack_channel_id: 23456  }

    it 'should create the story and send a success response' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'As an Admin I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'


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
        user_id: 'slackUser12345',
        text: 'I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(false)
      expect(hash_response['errors']).to have_content('Missing Role')
    end

    it 'should fail when channel id is missing and send a failure response' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'I want to have privileges to all the database so that I can check the tables.'


      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(false)
      expect(hash_response['errors']).to have_content('channel_id is missing')
    end

    it 'should fail when user id is missing and send a failure response' do
      post :create,
        format: :json,
        project_id: project.id,
        text: 'I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(false)
      expect(hash_response['errors']).to have_content('user_id is missing')
    end

    it 'should fail when user id is not related to the project and send a failure response' do
      create :user, slack_id: 'UnathorizedUser123'
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'UnathorizedUser123',
        text: 'I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(false)
      expect(hash_response['errors']).to have_content("User doesn't have permissions on project")
    end
  end
end
