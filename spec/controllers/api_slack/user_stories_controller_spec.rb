require 'spec_helper'

RSpec.describe ApiSlack::UserStoriesController do
  describe 'POST create story' do
    let!(:user)        { create :user, slack_id: 'slackUser12345' }
    let!(:project)     { create :project, owner: user, slack_channel_id: 23456  }

    before :each do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:create_event).and_return(true)
    end

    it 'should create the story and send a success response when role, action and result are defined' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'As an Admin I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['attachments'][0]['title']).to eq 'New user story created'
      expect(Project.find(project.id).user_stories.last.role).to eq('Admin'.downcase)
      expect(Project.find(project.id).user_stories.last.action).to eq('to have privileges to all the database'.downcase)
      expect(Project.find(project.id).user_stories.last.result).to eq('I can check the tables.'.downcase)
    end

    it 'should create the story with description when role is not defined' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['attachments'][0]['title']).to eq 'New user story created'
      expect(Project.find(project.id).user_stories.last.description).to eq('I want to have privileges to all the database so that I can check the tables.'.downcase)
      expect(Project.find(project.id).user_stories.last.role).to be(nil)
    end

    it 'should had have created user story unless the text comes empty' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'I want to have privileges to all the database so that I can check the tables.',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['attachments'][0]['title']).to eq 'New user story created'
    end

    it 'should fail when channel id is missing' do
      post :create,
        format: :json,
        project_id: project.id,
        user_id: 'slackUser12345',
        text: 'I want to have privileges to all the database so that I can check the tables.'

      hash_response = JSON.parse(response.body)
      expect(hash_response['attachments'][0]['title']).to eq 'Error'
    end

    it 'should fail when text comes empty' do
      post :create,
        format: :json,
        user_id: 'slackUser12345',
        project_id: project.id,
        text: '',
        channel_id: '23456'

      hash_response = JSON.parse(response.body)
      expect(hash_response['attachments'][0]['text']).to eq 'You cannot create empty User stories.'
    end
  end
end
