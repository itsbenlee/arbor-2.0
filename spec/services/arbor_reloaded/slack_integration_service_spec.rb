require 'spec_helper'
module ArborReloaded
  feature 'create user story' do
    let(:user)              { create :user }
    let(:project)         { create :project, slack_channel_id: 23456 }
    let(:slack_integration_service) { ArborReloaded::SlackIntegrationService.new(project) }

    scenario 'should create a user story using text' do
      text = 'As an Admin I want to have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('Admin'.downcase)
      expect(user_story_created.action).to eq('to have privileges to all the database')
      expect(user_story_created.result).to eq('i can check the tables.')
    end

    scenario 'should do nothing with slack_enabled = false' do
      project.update_attribute(:slack_enabled, false)
      text = 'As an Admin I want to have privileges to all the database so that I can check the tables.'

      response = slack_integration_service.build_user_story(text, user)
      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(slack_integration_service.user_story_notify(user_story_created)).to eq(nil)
      expect(slack_integration_service.comment_notify(response.data[:user_story_id], 'comment')).to eq(nil)
    end

    scenario 'should do send notify with slack_iw_url defined && slack_enabled true' do
      project.update_attribute(:slack_iw_url, 'https://hooks.slack.com/services/VALID_CODE')
      project.update_attribute(:slack_enabled, true)

      text = 'As an Admin I want to have privileges to all the database so that I can check the tables.'

      usResponse = slack_integration_service.build_user_story(text, user)
      user_story_created = UserStory.find(usResponse.data[:user_story_id])

      VCR.use_cassette('slack/notifications') do
        response = slack_integration_service.comment_notify(usResponse.data[:user_story_id], 'comment')
        expect(response.parsed_response).to eq("ok")
      end

      VCR.use_cassette('slack/notifications') do
        response = slack_integration_service.user_story_notify(user_story_created)
        expect(response.parsed_response).to eq("ok")
      end
    end
  end
end
