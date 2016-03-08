require 'spec_helper'
module ArborReloaded
  feature 'Intercom Services' do
    let(:user)             { create :user, email: 'sam_kemmer@gutmann.info' }
    let(:intercom_service) { ArborReloaded::IntercomServices.new(user) }

    before :each do
      sign_in user
    end

    scenario 'should create a user on Intercom' do
    #VCR.use_cassette('intercom/create_user') do
      intercom_user = intercom_service.user_create_event
      expect(intercom_user.class).to eq(Intercom::User)
      expect(intercom_user.email).to eq(user.email)
    #end
    end

    scenario 'should log create project event on Intercom' do
      intercom_user = intercom_service.project_create_event
      debugger
    end
  end
end
