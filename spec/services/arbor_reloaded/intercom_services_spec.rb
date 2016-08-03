require 'spec_helper'
module ArborReloaded
  feature 'Services for Intercom' do
    let(:user)             { create :user, email: 'sam_kemmer@gutmann.info' }
    let(:intercom_service) { ArborReloaded::IntercomServices.new(user) }

    before :each do
      sign_in user
    end

    scenario 'should create a user' do
      skip 'fails randomly'

      VCR.use_cassette('intercom/create_user') do
        intercom_user = intercom_service.user_create_event
        expect(intercom_user.class).to eq(Intercom::User)
        expect(intercom_user.email).to eq(user.email)
      end
    end

    scenario 'should not raise an error creating user' do
      VCR.use_cassette('intercom/create_user') do
        expect{ intercom_service.user_create_event }.not_to raise_error
      end
    end

    scenario 'should create a project event' do
      VCR.use_cassette('intercom/create_project') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.create_project')) }.not_to raise_error
      end
    end

    scenario 'should create a user story event' do
      VCR.use_cassette('intercom/create_user_story') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.create_story')) }.not_to raise_error
      end
    end

    scenario 'should create an AC event' do
      VCR.use_cassette('intercom/create_ac') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.create_criterion')) }.not_to raise_error
      end
    end

    scenario 'should create an comment event' do
      VCR.use_cassette('intercom/create_comment') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.create_comment')) }.not_to raise_error
      end
    end

    scenario 'should create a trello export event' do
      VCR.use_cassette('intercom/export_to_trello') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.trello_export')) }.not_to raise_error
      end
    end

    scenario 'should create a pdf export event' do
      VCR.use_cassette('intercom/export_to_pdf') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.pdf_export')) }.not_to raise_error
      end
    end

    scenario 'should create a connect to slack event' do
      VCR.use_cassette('intercom/connect_to_slack') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.slack_connect')) }.not_to raise_error
      end
    end

    scenario 'should create a favorite project event' do
      VCR.use_cassette('intercom/favorite_project') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.favorite_project')) }.not_to raise_error
      end
    end

    scenario 'should create an estimate story event' do
      VCR.use_cassette('intercom/estimate_story') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.estimate_story')) }.not_to raise_error
      end
    end
  end
end
