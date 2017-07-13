require 'spec_helper'
module ArborReloaded
  feature 'IntercomServices errors handler' do
    let(:user)             { create :user, email: 'sam_kemmer@gutmann.info' }
    let(:intercom_service) { ArborReloaded::IntercomServices.new(user) }

    before :each do
      error = Intercom::ResourceNotFound.new 'error message'

      expect_any_instance_of(Intercom::Service::Event).to receive(:create).and_raise error
      sign_in user
    end

    scenario 'should handle an Intercom::ResourceNotFound', skip: true do
      VCR.use_cassette('intercom/create_user') do
        expect{ intercom_service.create_event(I18n.t('intercom_keys.create_project')) }.not_to raise_error
      end
    end
  end
end
