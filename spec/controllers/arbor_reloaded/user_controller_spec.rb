require 'spec_helper'

RSpec.describe ArborReloaded::UsersController do
  let!(:user)        { create :user }

  before :each do
    sign_in user
  end

  describe 'PUT update' do
    let(:user) {
      create :user,
      full_name: 'Jhon Doe',
      email: 'jhon.doe@mail.com'
    }

    it 'updates my own user profile' do
      put :update,
        format: :json,
        id: user.id,
        full_name: 'Robert G. Halargas',
        email: 'robert.g@mail.com'

      hash_response = JSON.parse(response.body)

      expect(hash_response['success']).to eq(true)
      updated_user = User.find(hash_response['data']['id'])
      expect(updated_user.full_name).to eq('Robert G. Halargas')
      expect(updated_user.email).to eq('robert.g@mail.com')
    end

    it 'fails with a message when updating other user profile' do
      another_user = create(:user)
      expect {
        put :update,
        format: :json,
        id: another_user.id,
        full_name: 'Another Guy',
        email: 'another.g@mail.com'
      }.to raise_error("You are not authorized to edit other person's profile")
    end
  end

end
