require 'spec_helper'
module ArborReloaded
  feature 'Intercom Services' do
    let(:user)             { create :user, email: 'sam_kemmer@gutmann.info' }
    let(:intercom_service) { ArborReloaded::IntercomServices.new(user) }

    before :each do
      sign_in user
    end

    scenario 'should create a user on Intercom' do
      VCR.use_cassette('intercom/create_user') do
        intercom_user = intercom_service.user_create_event
        expect(intercom_user.class).to eq(Intercom::User)
        expect(intercom_user.email).to eq(user.email)
      end
    end

    scenario 'should create a project event on Intercom' do
      VCR.use_cassette('intercom/create_project') do
        intercom_user = intercom_service.project_create_event
      end
    end

    scenario 'should create a user story event on Intercom' do
      VCR.use_cassette('intercom/create_user_story') do
        intercom_user = intercom_service.user_story_create_event
      end
    end

    scenario 'should create an AC event on Intercom' do
      VCR.use_cassette('intercom/create_ac') do
        intercom_user = intercom_service.criterion_create_event
      end
    end

    scenario 'should create an comment event on Intercom' do
      VCR.use_cassette('intercom/create_comment') do
        intercom_user = intercom_service.comment_create_event
      end
    end
  end
end
