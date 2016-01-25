require 'spec_helper'

RSpec.describe ApiSlack::ChannelsController do
  describe 'POST channel list' do
    it 'response should be ok' do
      get :index,
        format: :json,
        token: 'xoxp-4750359453-4758261479-19070813203-2155c19760'

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to be(true)
    end
  end
end
