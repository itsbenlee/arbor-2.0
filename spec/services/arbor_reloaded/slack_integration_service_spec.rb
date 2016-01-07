require 'spec_helper'
module ArborReloaded
  feature 'create user story' do
    let(:user)              { create :user }
    let(:project)         { create :project }
    let(:slack_integration_service) { ArborReloaded::SlackIntegrationService.new(project) }

    scenario 'should create a user story using text' do
      params = {text: 'As an Admin I want to have privileges to all the database so that I can check the tables.'}
      response = slack_integration_service.build_user_story(params[:text], user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('Admin')
      expect(user_story_created.action).to eq('to have privileges to all the database')
      expect(user_story_created.result).to eq('so that I can check the tables.')
    end

    scenario 'should fail with descriptive error if Role is missing' do
      params = {text: 'Admin I want to have privileges to all the database so that I can check the tables.'}
      response = slack_integration_service.build_user_story(params[:text], user)
      expect(response.errors).to have_content('Missing Role')
    end

    scenario 'should fail with descriptive error if Action is missing' do
      params = {text: 'As an Admin have privileges to all the database so that I can check the tables.'}
      response = slack_integration_service.build_user_story(params[:text], user)
      expect(response.errors).to have_content('Missing Action')
    end

    scenario 'should fail with descriptive error if Result is missing' do
      params = {text: 'As an Admin I want to have privileges to all the database.'}
      response = slack_integration_service.build_user_story(params[:text], user)
      expect(response.errors).to have_content('Missing Result')
    end
  end
end
