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
      expect(user_story_created.description).to be_nil
    end

    scenario 'should create a user story using another availables verbs' do
      text = 'As an Admin I could have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('Admin'.downcase)
      expect(user_story_created.action).to eq('have privileges to all the database')
      expect(user_story_created.result).to eq('i can check the tables.')
      expect(user_story_created.description).to be_nil
    end

    scenario 'should create a user story using another availables verbs' do
      text = 'As a Admin I should have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('Admin'.downcase)
      expect(user_story_created.action).to eq('have privileges to all the database')
      expect(user_story_created.result).to eq('i can check the tables.')
      expect(user_story_created.description).to be_nil
    end

    scenario 'should create a user story using another availables verbs' do
      text = 'As an Admin I must have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('Admin'.downcase)
      expect(user_story_created.action).to eq('have privileges to all the database')
      expect(user_story_created.result).to eq('i can check the tables.')
      expect(user_story_created.description).to be_nil
    end

    scenario 'should create a user story with description when role is not given (normal format)' do
      text = 'I want to have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when action is not given (normal format)' do
      text = 'As an Admin so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when result is not given (normal format)' do
      text = 'As an Admin I want to have privileges to all the database'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when role and result are not given (normal format)' do
      text = 'I want to have privileges to all the database'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when role and action are not given (normal format)' do
      text = 'so that I can check the tables'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when result and action are not given (normal format)' do
      text = 'As an Admin'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end


    scenario 'should create a user story with description when only label of role is given' do
      text = 'As an I want to have privileges to all the database so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when only label of result is given' do
      text = 'As an Admin I want to have privileges to all the database so'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when only label of action is given' do
      text = 'As an Admin I want so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when only labels of role action are given' do
      text = 'As an I want so that I can check the tables.'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when only labels are given' do
      text = 'As an I want so that'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should create a user story with description when anything else is given' do
      text = 'Add slack integration to arbor'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end


    scenario 'create user story with non resctricted format' do
      text = 'aS     User   i   Should    Action   SO    Result'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to eq('user')
      expect(user_story_created.action).to eq('action')
      expect(user_story_created.result).to eq('result')
      expect(user_story_created.description).to be_nil
    end

    scenario 'create user story with description when role, action and result are disordered' do
      text = 'So that result as a user I want action'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'create user story with description when role, action and result are disordered' do
      text = 'as a user So that result I want action'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'create user story with description when role, action and result are disordered' do
      text = 'as a user So that I want'
      response = slack_integration_service.build_user_story(text, user)

      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(user_story_created.role).to be_nil
      expect(user_story_created.action).to be_nil
      expect(user_story_created.result).to be_nil
      expect(user_story_created.description).to eq(text.downcase)
    end

    scenario 'should do nothing with slack_enabled = false' do
      project.update_attribute(:slack_enabled, false)
      text = 'As an Admin I want to have privileges to all the database so that I can check the tables.'

      response = slack_integration_service.build_user_story(text, user)
      user_story_created = UserStory.find(response.data[:user_story_id])
      expect(slack_integration_service.user_story_notify(user_story_created, 'link')).to eq(nil)
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
        response = slack_integration_service.user_story_notify(user_story_created, 'link')
        expect(response.parsed_response).to eq("ok")
      end
    end
  end
end
